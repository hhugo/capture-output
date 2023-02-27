let () =
  let l =
    Capture_output.capture ~f:(fun () ->
        Printf.printf "printf\n";
        Printf.eprintf "eprintf\n")
    |> String.split_on_char '\n'
  in
  match l with
  | [] | [ "" ] -> assert false
  | _ -> List.iter (fun s -> Printf.printf "> %s\n" s) l
