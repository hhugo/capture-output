//Provides: capture_output_saved_stdout
var capture_output_saved_stdout
//Provides: capture_output_saved_stderr
var capture_output_saved_stderr

//Provides: capture_output_setup
//Requires: caml_global_data, caml_ml_channels
//Requires: capture_output_saved_stderr, capture_output_saved_stdout
function capture_output_setup (voutput, vstdout, vstderr){
  capture_output_saved_stderr = caml_ml_channels[vstderr];
  capture_output_saved_stdout = caml_ml_channels[vstdout];
  var output = caml_ml_channels[voutput];
  caml_ml_channels[vstdout] = output;
  caml_ml_channels[vstderr] = output;
  return 0;
}

//Provides: capture_output_restore
//Requires: caml_global_data, caml_ml_channels
//Requires: capture_output_saved_stderr, capture_output_saved_stdout
function capture_output_restore (vstdout, vstderr){
  caml_ml_channels[vstdout] = capture_output_saved_stdout;
  caml_ml_channels[vstderr] = capture_output_saved_stderr;
  return 0;
}
