module Expert = struct
  type t

  external setup : into:out_channel -> out_channel -> t = "capture_output_setup"
  external restore : out_channel -> t -> unit = "capture_output_restore"
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
  let t = Expert.setup ~into chan in
  let r = f () in
  flush stdout;
  let () = Expert.restore chan t in
  r

let capture_channel chan ~f =
  with_channel_proxy (fun into -> capture_channel' chan ~into ~f)

let capture_stdout ~f = capture_channel stdout ~f
let capture_stderr ~f = capture_channel stderr ~f

let capture ~f =
  with_channel_proxy (fun oc ->
      flush stderr;
      flush stdout;
      let stdout_t = Expert.setup ~into:oc stdout in
      let stderr_t = Expert.setup ~into:oc stderr in
      let r = f () in
      flush stderr;
      flush stdout;
      let () = Expert.restore stdout stdout_t in
      let () = Expert.restore stderr stderr_t in
      r)
