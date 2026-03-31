//Provides: capture_output_init_channels
//Requires: caml_ml_output,caml_ml_string_length,caml_string_of_jsbytes
var capture_output_stdout, capture_output_stderr;
function capture_output_init_channels(stdout, stderr) {
  capture_output_stdout = stdout;
  capture_output_stderr = stderr;
  return 0;
}

//Provides: capture_output_print_stdout
//Requires: capture_output_init_channels,caml_ml_output,caml_ml_string_length,caml_string_of_jsbytes
function capture_output_print_stdout(unit) {
  var s = caml_string_of_jsbytes("stdout from external");
  caml_ml_output(capture_output_stdout, s, 0, caml_ml_string_length(s));
  return 0
}

//Provides: capture_output_print_stderr
//Requires: capture_output_init_channels,caml_ml_output,caml_ml_string_length,caml_string_of_jsbytes
function capture_output_print_stderr(unit) {
  var s = caml_string_of_jsbytes("stderr from external");
  caml_ml_output(capture_output_stderr, s, 0, caml_ml_string_length(s));
  return 0
}
