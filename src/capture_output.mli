module Expert : sig
  type t

  external setup : into:out_channel -> out_channel -> t = "capture_output_setup"
  external restore : out_channel -> t -> unit = "capture_output_restore"
end

val capture_channel' : out_channel -> into:out_channel -> f:(unit -> 'a) -> 'a
val capture_channel : out_channel -> f:(unit -> 'a) -> string * 'a
val capture_stdout : f:(unit -> 'a) -> string * 'a
val capture_stderr : f:(unit -> 'a) -> string * 'a
val capture : f:(unit -> 'a) -> string * 'a
