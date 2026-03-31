//Provides: out_channel_redirect_setup
//Requires: caml_ml_channel_redirect
function out_channel_redirect_setup (voutput, vtocapture){
  return caml_ml_channel_redirect(vtocapture, voutput);
}

//Provides: out_channel_redirect_restore
//Requires: caml_ml_channel_restore
function out_channel_redirect_restore (captured, old){
  return caml_ml_channel_restore(captured, old);
}
