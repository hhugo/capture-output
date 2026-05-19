# Unreleased

- Add `capture_channels` and `capture_channels_interleaved` for capturing
  a list of channels (separately or merged into one string)
- Add `capture_outputs` and `capture_outputs_interleaved` for stdout and
  stderr (separately or merged)
- `capture` is now an alias for `capture_outputs_interleaved`

# 0.1

- Initial release
- Redirect and capture output written to `out_channel`s
- Support for native (via `dup`/`dup2`), JavaScript (js_of_ocaml), and WebAssembly (wasm_of_ocaml)
- Exception-safe capture with `Fun.protect`
- Expert API for manual redirection lifetime control
