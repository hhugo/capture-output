let expect ~here ~expected s =
  if String.equal expected s then ()
  else (
    Printf.eprintf "%s\n" here;
    Printf.eprintf "Expected %s\nReceived %s\n" expected s;
    exit 2)

let () =
  let s, () =
    Capture_output.capture ~f:(fun () ->
        Printf.printf "printf%!";
        Printf.eprintf "eprintf%!")
  in
  expect ~here:__LOC__ ~expected:"printfeprintf" s

let () =
  let s, inner =
    Capture_output.capture ~f:(fun () ->
        let (inner : string), () =
          Capture_output.capture_stdout ~f:(fun () ->
              Printf.printf "printf%!";
              Printf.eprintf "eprintf%!")
        in
        inner)
  in
  expect ~here:__LOC__ ~expected:"eprintf" s;
  expect ~here:__LOC__ ~expected:"printf" inner

let () =
  let s, inner =
    Capture_output.capture ~f:(fun () ->
        let (inner : string), () =
          Capture_output.capture_stderr ~f:(fun () ->
              Printf.printf "printf%!";
              Printf.eprintf "eprintf%!")
        in
        inner)
  in
  expect ~here:__LOC__ ~expected:"printf" s;
  expect ~here:__LOC__ ~expected:"eprintf" inner

let () =
  let s1, (s2, (s3, ())) =
    Capture_output.capture_stderr ~f:(fun () ->
        Capture_output.capture_stderr ~f:(fun () ->
            Capture_output.capture_stderr ~f:(fun () -> Printf.eprintf "HERE%!")))
  in
  expect ~here:__LOC__ ~expected:"" s1;
  expect ~here:__LOC__ ~expected:"" s2;
  expect ~here:__LOC__ ~expected:"HERE" s3

let () =
  let s1, () =
    Capture_output.capture_stderr ~f:(fun () ->
        let s, () =
          Capture_output.capture_stderr ~f:(fun () ->
              let s, () =
                Capture_output.capture_stderr ~f:(fun () ->
                    Printf.eprintf "HERE%!")
              in
              Printf.eprintf "%s%!" s)
        in
        Printf.eprintf "%s%!" s)
  in
  expect ~here:__LOC__ ~expected:"HERE" s1

let () =
  let s, () =
    Capture_output.capture_stdout ~f:(fun () ->
        Capture_output.capture_channel' stderr ~into:stdout ~f:(fun () ->
            Printf.eprintf "HERE%!"))
  in
  expect ~here:__LOC__ ~expected:"HERE" s

let () =
  let s, () =
    Capture_output.capture_channel' stderr ~into:stdout ~f:(fun () ->
        Capture_output.capture_stderr ~f:(fun () -> Printf.eprintf "HERE%!"))
  in
  expect ~here:__LOC__ ~expected:"HERE" s

(* FIX ??? *)
let () =
  let s1, s2 =
    Capture_output.capture_stdout ~f:(fun () ->
        let s, () =
          Capture_output.capture_channel' stderr ~into:stdout ~f:(fun () ->
              Capture_output.capture_stdout ~f:(fun () ->
                  Printf.eprintf "HERE%!"))
        in
        s)
  in
  expect ~here:__LOC__ ~expected:"HERE" s1;
  expect ~here:__LOC__ ~expected:"" s2

let () =
  let s, () =
    Capture_output.capture ~f:(fun () ->
        Capture_output_test_helper.capture_output_print_stdout ())
  in
  expect ~here:__LOC__ ~expected:"stdout from external" s

let () =
  let s, () =
    Capture_output.capture ~f:(fun () ->
        Capture_output_test_helper.capture_output_print_stderr ())
  in
  expect ~here:__LOC__ ~expected:"stderr from external" s
