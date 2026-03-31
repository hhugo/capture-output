# 0.1

- Initial release
- Redirect and capture output written to `out_channel`s
- Support for native (via `dup`/`dup2`), JavaScript (js_of_ocaml), and WebAssembly (wasm_of_ocaml)
- Exception-safe capture with `Fun.protect`
- Expert API for manual redirection lifetime control
