let expect ~here ~expected s =
  if String.equal expected s then ()
  else (
    Printf.eprintf "%s\n" here;
    Printf.eprintf "Expected: %s\nReceived: %s\n" expected s;
    exit 2)

let () =
  let s, () =
    Out_channel_redirect.capture ~f:(fun () ->
        Printf.printf "printf%!";
        Printf.eprintf "eprintf%!")
  in
  expect ~here:__LOC__ ~expected:"printfeprintf" s

let () =
  let s, inner =
    Out_channel_redirect.capture ~f:(fun () ->
        let (inner : string), () =
          Out_channel_redirect.capture_stdout ~f:(fun () ->
              Printf.printf "printf%!";
              Printf.eprintf "eprintf%!")
        in
        inner)
  in
  expect ~here:__LOC__ ~expected:"eprintf" s;
  expect ~here:__LOC__ ~expected:"printf" inner

let () =
  let s, inner =
    Out_channel_redirect.capture ~f:(fun () ->
        let (inner : string), () =
          Out_channel_redirect.capture_stderr ~f:(fun () ->
              Printf.printf "printf%!";
              Printf.eprintf "eprintf%!")
        in
        inner)
  in
  expect ~here:__LOC__ ~expected:"printf" s;
  expect ~here:__LOC__ ~expected:"eprintf" inner

let () =
  let s1, (s2, (s3, ())) =
    Out_channel_redirect.capture_stderr ~f:(fun () ->
        Out_channel_redirect.capture_stderr ~f:(fun () ->
            Out_channel_redirect.capture_stderr ~f:(fun () -> Printf.eprintf "HERE%!")))
  in
  expect ~here:__LOC__ ~expected:"" s1;
  expect ~here:__LOC__ ~expected:"" s2;
  expect ~here:__LOC__ ~expected:"HERE" s3

let () =
  let s1, () =
    Out_channel_redirect.capture_stderr ~f:(fun () ->
        let s, () =
          Out_channel_redirect.capture_stderr ~f:(fun () ->
              let s, () =
                Out_channel_redirect.capture_stderr ~f:(fun () ->
                    Printf.eprintf "HERE%!")
              in
              Printf.eprintf "%s%!" s)
        in
        Printf.eprintf "%s%!" s)
  in
  expect ~here:__LOC__ ~expected:"HERE" s1

let () =
  let s, () =
    Out_channel_redirect.capture_stdout ~f:(fun () ->
        Out_channel_redirect.capture_channel' stderr ~into:stdout ~f:(fun () ->
            Printf.eprintf "HERE%!"))
  in
  expect ~here:__LOC__ ~expected:"HERE" s

let () =
  let s, () =
    Out_channel_redirect.capture_channel' stderr ~into:stdout ~f:(fun () ->
        Out_channel_redirect.capture_stderr ~f:(fun () -> Printf.eprintf "HERE%!"))
  in
  expect ~here:__LOC__ ~expected:"HERE" s

let () =
  let s1, s2 =
    Out_channel_redirect.capture_stdout ~f:(fun () ->
        let s, () =
          Out_channel_redirect.capture_channel' stderr ~into:stdout ~f:(fun () ->
              Out_channel_redirect.capture_stdout ~f:(fun () ->
                  Printf.eprintf "HERE%!"))
        in
        s)
  in
  expect ~here:__LOC__ ~expected:"HERE" s1;
  expect ~here:__LOC__ ~expected:"" s2

let () =
  let s, () =
    Out_channel_redirect.capture ~f:(fun () ->
        Capture_output_test_helper.capture_output_print_stdout ())
  in
  expect ~here:__LOC__ ~expected:"stdout from external" s

let () =
  let s, () =
    Out_channel_redirect.capture ~f:(fun () ->
        Capture_output_test_helper.capture_output_print_stderr ())
  in
  expect ~here:__LOC__ ~expected:"stderr from external" s

(* Exception safety: capture_stdout restores channel on exception *)
let () =
  (try
     ignore
       (Out_channel_redirect.capture_stdout ~f:(fun () ->
            Printf.printf "before%!";
            failwith "test exception"))
   with Failure _ -> ());
  let s, () =
    Out_channel_redirect.capture_stdout ~f:(fun () -> Printf.printf "after%!")
  in
  expect ~here:__LOC__ ~expected:"after" s

(* Exception safety: capture_stderr restores channel on exception *)
let () =
  (try
     ignore
       (Out_channel_redirect.capture_stderr ~f:(fun () ->
            Printf.eprintf "before%!";
            failwith "test exception"))
   with Failure _ -> ());
  let s, () =
    Out_channel_redirect.capture_stderr ~f:(fun () -> Printf.eprintf "after%!")
  in
  expect ~here:__LOC__ ~expected:"after" s

(* Exception safety: capture restores both channels on exception *)
let () =
  (try
     ignore
       (Out_channel_redirect.capture ~f:(fun () ->
            Printf.printf "before%!";
            Printf.eprintf "before%!";
            failwith "test exception"))
   with Failure _ -> ());
  let s, () =
    Out_channel_redirect.capture ~f:(fun () ->
        Printf.printf "stdout%!";
        Printf.eprintf "stderr%!")
  in
  expect ~here:__LOC__ ~expected:"stdoutstderr" s

(* Expert.stop idempotency: calling stop twice should not crash *)
let () =
  let s, () =
    Out_channel_redirect.capture_stdout ~f:(fun () ->
        let redir = Out_channel_redirect.Expert.redirect ~into:stdout stderr in
        Printf.eprintf "redirected%!";
        Out_channel_redirect.Expert.stop redir;
        Out_channel_redirect.Expert.stop redir)
  in
  expect ~here:__LOC__ ~expected:"redirected" s

(* capture_channel called directly with stdout *)
let () =
  let s, () =
    Out_channel_redirect.capture_channel stdout ~f:(fun () ->
        Printf.printf "direct channel%!")
  in
  expect ~here:__LOC__ ~expected:"direct channel" s

(* capture_channel called directly with stderr *)
let () =
  let s, () =
    Out_channel_redirect.capture_channel stderr ~f:(fun () ->
        Printf.eprintf "direct stderr%!")
  in
  expect ~here:__LOC__ ~expected:"direct stderr" s

(* Large output: exceed typical buffer sizes *)
let () =
  let big = String.make 100_000 'x' in
  let s, () =
    Out_channel_redirect.capture_stdout ~f:(fun () ->
        print_string big;
        flush stdout)
  in
  expect ~here:__LOC__ ~expected:big s

(* Exception safety: capture_channel' restores on exception *)
let () =
  let _, () =
    Out_channel_redirect.capture_stdout ~f:(fun () ->
        try
          Out_channel_redirect.capture_channel' stderr ~into:stdout ~f:(fun () ->
              Printf.eprintf "before%!";
              failwith "test exception")
        with Failure _ -> ())
  in
  let s, () =
    Out_channel_redirect.capture_stderr ~f:(fun () -> Printf.eprintf "restored%!")
  in
  expect ~here:__LOC__ ~expected:"restored" s
