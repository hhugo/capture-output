module Expert = struct
  type t

  external setup : into:out_channel -> out_channel -> t = "capture_output_setup"
  external restore : out_channel -> t -> unit = "capture_output_restore"

  type redirection = { mutable restore : unit -> unit }

  let redirect ~into c =
    let t = setup ~into c in
    { restore = (fun () -> restore c t) }

  let stop t =
    let f = t.restore in
    t.restore <- (fun () -> ());
    f ()
end

let with_channel_proxy f =
  let fname, oc = Filename.open_temp_file "" "" in
  let r = f oc in
  close_out oc;
  let ic = open_in_bin fname in
  let c = really_input_string ic (in_channel_length ic) in
  close_in ic;
  (c, r)

let capture_channel' chan ~into ~f =
  flush stdout;
  let t = Expert.redirect chan ~into in
  let r = f () in
  flush stdout;
  let () = Expert.stop t in
  r

let capture_channel chan ~f =
  with_channel_proxy (fun into -> capture_channel' chan ~into ~f)

let capture_stdout ~f = capture_channel stdout ~f
let capture_stderr ~f = capture_channel stderr ~f

let capture ~f =
  with_channel_proxy (fun oc ->
      flush stderr;
      flush stdout;
      let stdout_t = Expert.redirect stdout ~into:oc in
      let stderr_t = Expert.redirect stderr ~into:oc in
      let r = f () in
      flush stderr;
      flush stdout;
      let () = Expert.stop stdout_t in
      let () = Expert.stop stderr_t in
      r)
