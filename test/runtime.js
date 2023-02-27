//Provides: capture_output_log
//Requires: caml_ml_output,caml_ml_string_length,caml_string_of_jsbytes
function capture_output_log(fd, x) {
    var s = caml_string_of_jsbytes(x);
    caml_ml_output(fd, s, 0, caml_ml_string_length(s));
  }

//Provides: capture_output_print_stdout
//Requires: capture_output_log
function capture_output_print_stdout(unit) {
  capture_output_log(1, "stdout from external");
  return 0
}

//Provides: capture_output_print_stderr
//Requires: capture_output_log
function capture_output_print_stderr(unit) {
  capture_output_log(2, "stderr from external");
  return 0
}
