(lang dune 3.17)
(name capture-output)

(maintainers "hugo.heuzard@gmail.com")
(authors "Hugo Heuzard")
(homepage "https://github.com/hhugo/capture-output")
(documentation "https://hhugo.github.io/capture-output/")
(bug_reports "https://github.com/hhugo/capture-output/issues")
(source (github hhugo/capture-output))
(license MIT)

(generate_opam_files true)

(package
 (name capture-output)
 (synopsis "Capture output written to out_channels")
 (description
  "An OCaml library for capturing output written to out_channels, with support\nfor native, JavaScript (js_of_ocaml), and WebAssembly (wasm_of_ocaml) targets.")
 (depends
  (ocaml (>= 4.06.1))
  (ocamlformat (and (= 0.28.1) :with-test))
  (js_of_ocaml :with-test)
  (wasm_of_ocaml-compiler :with-test)))
