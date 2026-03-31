# capture-output

An OCaml library for capturing stdout and stderr output, with support for native, JavaScript (js_of_ocaml), and WebAssembly (wasm_of_ocaml) targets.

On native, it works by redirecting file descriptors at the OS level (via `dup`/`dup2`), so it captures output from OCaml code as well as C stubs and foreign calls. On JavaScript and WebAssembly targets, it redirects at the channel level using the runtime's channel primitives.

## Installation

```
opam install capture-output
```

## Usage

```ocaml
(* Capture both stdout and stderr *)
let output, result = Capture_output.capture ~f:(fun () ->
    print_endline "hello";
    prerr_endline "world";
    42)
(* output = "hello\nworld\n", result = 42 *)

(* Capture stdout only *)
let output, result = Capture_output.capture_stdout ~f:(fun () ->
    print_endline "hello";
    42)

(* Capture stderr only *)
let output, result = Capture_output.capture_stderr ~f:(fun () ->
    prerr_endline "hello";
    42)
```

### Redirecting to a specific channel

`capture_channel'` redirects a channel into another without capturing to a string:

```ocaml
(* Redirect stderr into stdout *)
Capture_output.capture_channel' stderr ~into:stdout ~f:(fun () ->
    prerr_endline "this goes to stdout now")
```

### Expert API

For manual control over redirection lifetime:

```ocaml
let redir = Capture_output.Expert.redirect ~into:stdout stderr in
prerr_endline "redirected to stdout";
Capture_output.Expert.stop redir
```

## API

```ocaml
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
```

## Requirements

- OCaml >= 4.06.1
- Dune >= 2.0

## License

MIT
