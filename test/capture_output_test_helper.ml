external init_channels : out_channel -> out_channel -> unit
  = "capture_output_init_channels"

let () = init_channels stdout stderr

external capture_output_print_stdout : unit -> unit
  = "capture_output_print_stdout"

external capture_output_print_stderr : unit -> unit
  = "capture_output_print_stderr"
