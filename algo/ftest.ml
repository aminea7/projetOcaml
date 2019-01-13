open Graph

let () =

  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)

  (* These command-line arguments are not used for the moment. *)
  and _source = Sys.argv.(2)
  and _sink = Sys.argv.(3)
  in

  (* Open file *)
  let graph = Gfile.from_file infile in

  (*On peut test map ici*)
  (*let graph = Graph.map graph (fun chaine -> "0/"^chaine)   in*)
  let graph = Graph.map graph (fun chaine -> ("0",chaine))   in

  (*let pred3 = Graph.r_pred "3" graph  in *)
  let graph2 = Graph.algo graph _source _sink in


   (*let chaine = Graph.chemin graph _source _sink [_source] [_source] in*)

(*
  (* Rewrite the graph that has been read. *)
  let () = Gfile.write_file_chemin outfile test1 graph _source _sink in
*)

(*
  let min = Graph.min_flot (liste_aug_flots graph chaine) in
  let graph2 = Graph.maj_gr graph chaine min in

  let chaine2 = Graph.chemin graph2 _source _sink [_source] [_source] in

  let () = Gfile.write_file_chemin outfile chaine2 graph _source _sink in
*)

  let () = Gfile.write_file outfile graph2  in

  ()
