# out-channel-redirect

An OCaml library for redirecting and capturing output written to `out_channel`s, with support for native, JavaScript (js_of_ocaml), and WebAssembly (wasm_of_ocaml) targets.

On native, it works by redirecting file descriptors at the OS level (via `dup`/`dup2`), so it captures output from OCaml code as well as C stubs and foreign calls. On JavaScript and WebAssembly targets, it redirects at the channel level using the runtime's channel primitives.

## Installation

```
opam install out-channel-redirect
```

## Usage

```ocaml
(* Capture an out_channel into a string *)
let output, result = Out_channel_redirect.capture_channel stdout ~f:(fun () ->
    print_endline "hello";
    42)
(* output = "hello\n", result = 42 *)

(* Convenience shorthands for stdout, stderr, or both *)
let output, result = Out_channel_redirect.capture_stdout ~f:(fun () -> print_endline "hello"; 42)
let output, result = Out_channel_redirect.capture_stderr ~f:(fun () -> prerr_endline "hello"; 42)
let output, result = Out_channel_redirect.capture ~f:(fun () ->
    print_endline "hello"; prerr_endline "world"; 42)
```

### Redirecting a channel into another

`redirect` redirects a channel into another without capturing to a string:

```ocaml
Out_channel_redirect.redirect stderr ~into:stdout ~f:(fun () ->
    prerr_endline "this goes to stdout now")
```

### Expert API

For manual control over redirection lifetime:

```ocaml
let redir = Out_channel_redirect.Expert.redirect ~into:stdout stderr in
prerr_endline "redirected to stdout";
Out_channel_redirect.Expert.stop redir
```

## API

```ocaml
module Expert : sig
  type redirection
  val redirect : into:out_channel -> out_channel -> redirection
  val stop : redirection -> unit
end

val redirect : out_channel -> into:out_channel -> f:(unit -> 'a) -> 'a
val capture_channel : out_channel -> f:(unit -> 'a) -> string * 'a
val capture_stdout : f:(unit -> 'a) -> string * 'a
val capture_stderr : f:(unit -> 'a) -> string * 'a
val capture : f:(unit -> 'a) -> string * 'a
```

## Requirements

- OCaml >= 4.08
- Dune >= 3.17

## License

MIT
