(module
   (import "env" "caml_ml_get_channel_fd"
      (func $caml_ml_get_channel_fd (param (ref eq)) (result i32)))
   (import "env" "caml_ml_set_channel_fd"
      (func $caml_ml_set_channel_fd (param (ref eq)) (param i32)))

   (func (export "out_channel_redirect_setup")
      (param $voutput (ref eq)) (param $vtocapture (ref eq)) (result (ref eq))
      (local $old_fd i32)
      (local.set $old_fd
         (call $caml_ml_get_channel_fd (local.get $vtocapture)))
      (call $caml_ml_set_channel_fd (local.get $vtocapture)
         (call $caml_ml_get_channel_fd (local.get $voutput)))
      (ref.i31 (local.get $old_fd)))

   (func (export "out_channel_redirect_restore")
      (param $vcaptured (ref eq)) (param $vold (ref eq)) (result (ref eq))
      (call $caml_ml_set_channel_fd (local.get $vcaptured)
         (i31.get_s (ref.cast (ref i31) (local.get $vold))))
      (ref.i31 (i32.const 0)))
)
