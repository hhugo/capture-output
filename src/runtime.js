//Provides: capture_output_setup
//Requires: caml_global_data, caml_ml_channels
function capture_output_setup (voutput, vtocapture){
  var old = caml_ml_channels[vtocapture];
  var output = caml_ml_channels[voutput];
  caml_ml_channels[vtocapture] = output;
  return old;
}

//Provides: capture_output_restore
//Requires: caml_global_data, caml_ml_channels
function capture_output_restore (captured, old){
  caml_ml_channels[captured] = old;
  return 0;
}
