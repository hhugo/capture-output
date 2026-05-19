(** Redirect and capture output written to {!Stdlib.out_channel}s.

    Redirections operate on the underlying file descriptor, so output written by
    C stubs or foreign code is captured as well as output written through
    OCaml's [Stdlib] channels. *)

(** {1 Redirecting} *)

val redirect : out_channel -> into:out_channel -> f:(unit -> 'a) -> 'a
(** [redirect c ~into ~f] runs [f ()] with everything written to [c] redirected
    into [into]. [c] is flushed before and after [f], and the redirection is
    removed even if [f] raises. *)

(** {1 Capturing} *)

val capture_channel : out_channel -> f:(unit -> 'a) -> string * 'a
(** [capture_channel c ~f] runs [f ()] and returns [(s, r)] where [s] is
    everything written to [c] during the call and [r] is [f]'s result. *)

val capture_channels : out_channel list -> f:(unit -> 'a) -> string list * 'a
(** [capture_channels cs ~f] runs [f ()] and returns one captured string per
    channel in [cs], in the same order, along with [f]'s result. *)

val capture_channels_interleaved :
  out_channel list -> f:(unit -> 'a) -> string * 'a
(** [capture_channels_interleaved cs ~f] runs [f ()] and returns a single string
    containing everything written to any channel in [cs], in write order, along
    with [f]'s result. *)

(** {1 Convenience for stdout and stderr} *)

val capture_stdout : f:(unit -> 'a) -> string * 'a
(** [capture_stdout] is [capture_channel stdout]. *)

val capture_stderr : f:(unit -> 'a) -> string * 'a
(** [capture_stderr] is [capture_channel stderr]. *)

val capture_outputs : f:(unit -> 'a) -> string * string * 'a
(** [capture_outputs ~f] is [capture_channels [stdout; stderr] ~f], with the two
    strings returned as a flat triple [(stdout, stderr, r)]. *)

val capture_outputs_interleaved : f:(unit -> 'a) -> string * 'a
(** [capture_outputs_interleaved] is
    [capture_channels_interleaved [stdout; stderr]]. *)

val capture : f:(unit -> 'a) -> string * 'a
(** Alias for {!capture_outputs_interleaved}, kept for backwards compatibility.
*)

(** {1 Expert interface} *)

module Expert : sig
  (** Low-level interface for installing and removing redirections manually.
      Prefer the high-level functions above — they take care of flushing and
      cleanup for you. *)

  type redirection

  val redirect : into:out_channel -> out_channel -> redirection
  (** [redirect ~into c] starts redirecting everything written to [c] into
      [into]. The caller is responsible for flushing [c] before calling and for
      invoking {!stop} to undo the redirection. *)

  val stop : redirection -> unit
  (** [stop r] undoes the redirection installed by {!redirect}. Calling [stop]
      more than once on the same redirection is a no-op. *)
end
