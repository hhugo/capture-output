external setup :
  output:out_channel -> stdout:out_channel -> stderr:out_channel -> unit
  = "capture_output_setup"

external restore : stdout:out_channel -> stderr:out_channel -> unit
  = "capture_output_restore"

let capture ~f =
  let fname, oc = Filename.open_temp_file "" "" in
  flush stderr;
  flush stdout;
  let () = setup ~output:oc ~stdout ~stderr in
  f ();
  flush stderr;
  flush stdout;
  let () = restore ~stdout ~stderr in
  close_out oc;
  let ic = open_in_bin fname in
  let c = really_input_string ic (in_channel_length ic) in
  close_in ic;
  c
