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

let capture_channels_interleaved chans ~f =
  with_channel_proxy (fun oc ->
      List.iter flush chans;
      let ts = List.map (fun c -> Expert.redirect c ~into:oc) chans in
      Fun.protect f ~finally:(fun () ->
          List.iter flush chans;
          List.iter Expert.stop (List.rev ts)))

let capture_channels chans ~f =
  let rec loop = function
    | [] -> ([], f ())
    | c :: rest ->
        let s, (ss, r) =
          with_channel_proxy (fun oc ->
              flush c;
              let t = Expert.redirect c ~into:oc in
              Fun.protect
                (fun () -> loop rest)
                ~finally:(fun () ->
                  flush c;
                  Expert.stop t))
        in
        (s :: ss, r)
  in
  loop chans

let capture_stdout ~f = capture_channel stdout ~f
let capture_stderr ~f = capture_channel stderr ~f

let capture_outputs ~f =
  match capture_channels [ stdout; stderr ] ~f with
  | [ out; err ], r -> (out, err, r)
  | _ -> assert false

let capture_outputs_interleaved ~f =
  capture_channels_interleaved [ stdout; stderr ] ~f

let capture ~f = capture_outputs_interleaved ~f
