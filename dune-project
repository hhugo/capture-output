(lang dune 3.17)
(name out-channel-redirect)

(maintainers "hugo.heuzard@gmail.com")
(authors "Hugo Heuzard")
(homepage "https://github.com/hhugo/out-channel-redirect")
(documentation "https://hhugo.github.io/out-channel-redirect/")
(bug_reports "https://github.com/hhugo/out-channel-redirect/issues")
(source (github hhugo/out-channel-redirect))
(license MIT)

(generate_opam_files true)

(package
 (name out-channel-redirect)
 (synopsis "Redirect and capture output written to out_channels")
 (description
  "An OCaml library for redirecting and capturing output written to out_channels, with support\nfor native, JavaScript (js_of_ocaml), and WebAssembly (wasm_of_ocaml) targets.")
 (depends
  (ocaml (>= 4.08))
  (ocamlformat (and (= 0.28.1) :with-dev-setup))
  (js_of_ocaml :with-test))
 (depopts (wasm_of_ocaml-compiler :with-test)))
