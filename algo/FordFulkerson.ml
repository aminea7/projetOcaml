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

  (* initialiser le graf*)
  let graph = Graph.map graph (fun chaine -> ("0",chaine))   in

(* Démonstration que les arcs inverses fonctionnent
  let graph2 = Graph.algo1 graph graph _source _sink in
  let graph2 = Graph.algo graph2 graph _source _sink in
 *)

  let graph2 = Graph.algo graph graph _source _sink in
  let graph2 = Graph.maj_remove graph2 graph in


  (*
  (* Afficher un chemin  (id list), pour vérifier si notre chaine était optimale*)
  let () = Gfile.write_file_chemin outfile test1 graph _source _sink in *)

(*Afficher graphe en dot format*)
  let () = Gfile.export outfile graph2 in


(*Afficher en type graph comme en entrée *)
 (*let () = Gfile.write_file outfile graph in  *)

  ()
