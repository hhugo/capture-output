module Expert : sig
  type redirection

  val redirect : into:out_channel -> out_channel -> redirection
  val stop : redirection -> unit
end

val capture_channel' : out_channel -> into:out_channel -> f:(unit -> 'a) -> 'a
val capture_channel : out_channel -> f:(unit -> 'a) -> string * 'a
val capture_stdout : f:(unit -> 'a) -> string * 'a
val capture_stderr : f:(unit -> 'a) -> string * 'a
val capture : f:(unit -> 'a) -> string * 'a
