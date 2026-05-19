module Expert : sig
  type redirection

  val redirect : into:out_channel -> out_channel -> redirection
  val stop : redirection -> unit
end

val redirect : out_channel -> into:out_channel -> f:(unit -> 'a) -> 'a
val capture_channel : out_channel -> f:(unit -> 'a) -> string * 'a
val capture_channels : out_channel list -> f:(unit -> 'a) -> string list * 'a

val capture_channels_interleaved :
  out_channel list -> f:(unit -> 'a) -> string * 'a

val capture_stdout : f:(unit -> 'a) -> string * 'a
val capture_stderr : f:(unit -> 'a) -> string * 'a
val capture_outputs : f:(unit -> 'a) -> string * string * 'a
val capture_outputs_interleaved : f:(unit -> 'a) -> string * 'a
val capture : f:(unit -> 'a) -> string * 'a
