# Unreleased

- Fix `capture_channel'` flushing stdout instead of the target channel
- Add exception safety to capture functions via `Fun.protect`
- Fix stop order in `capture` to LIFO (matching setup order)
- Clean up temp files in `with_channel_proxy`
- Fix JS runtime for current js_of_ocaml channel representation
- Add wasm_of_ocaml support
- Add README with usage examples and API reference
- Improve test coverage (exception safety, `Expert.stop` idempotency, large output)
