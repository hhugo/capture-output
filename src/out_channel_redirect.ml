module Expert = struct
  type t

  external setup : into:out_channel -> out_channel -> t
    = "out_channel_redirect_setup"

  external restore : out_channel -> t -> unit = "out_channel_redirect_restore"

  type redirection = { mutable restore : unit -> unit }

  let redirect ~into c =
    let t = setup ~into c in
    { restore = (fun () -> restore c t) }

  let stop t =
    let f = t.restore in
    t.restore <- (fun () -> ());
    f ()
end

let with_channel_proxy f =
  let fname, oc = Filename.open_temp_file "" "" in
  Fun.protect
    ~finally:(fun () ->
      close_out_noerr oc;
      Sys.remove fname)
    (fun () ->
      let r = f oc in
      close_out oc;
      let ic = open_in_bin fname in
      let c = really_input_string ic (in_channel_length ic) in
      close_in ic;
      (c, r))

let redirect chan ~into ~f =
  flush chan;
  let t = Expert.redirect chan ~into in
  Fun.protect f ~finally:(fun () ->
      flush chan;
      Expert.stop t)

let capture_channel chan ~f =
  with_channel_proxy (fun into -> redirect chan ~into ~f)

let capture_stdout ~f = capture_channel stdout ~f
let capture_stderr ~f = capture_channel stderr ~f

let capture ~f =
  with_channel_proxy (fun oc ->
      flush stderr;
      flush stdout;
      let stdout_t = Expert.redirect stdout ~into:oc in
      let stderr_t = Expert.redirect stderr ~into:oc in
      Fun.protect f ~finally:(fun () ->
          flush stderr;
          flush stdout;
          Expert.stop stderr_t;
          Expert.stop stdout_t))
