//Provides: capture_output_setup
//Requires: caml_ml_channel_redirect
function capture_output_setup (voutput, vtocapture){
  return caml_ml_channel_redirect(vtocapture, voutput);
}

//Provides: capture_output_restore
//Requires: caml_ml_channel_restore
function capture_output_restore (captured, old){
  return caml_ml_channel_restore(captured, old);
}
