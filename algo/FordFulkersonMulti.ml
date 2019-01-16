open Graph

let () =

  if Array.length Sys.argv <> 5 then
    begin
      (*Printf.printf "\nUsage: %s infile source1 source2 source1 source1 sink outfile\n\n%!" Sys.argv.(0) ;
*)
      exit 0
    end ;


  let infile = Sys.argv.(1)
  and source1 = Sys.argv.(2)
  and source2 = Sys.argv.(3)
  and source3 = Sys.argv.(4)
  and source4 = Sys.argv.(5)

  and sink1 = Sys.argv.(6)
  and sink2 = Sys.argv.(7)
  and sink3 = Sys.argv.(8)
  and sink4 = Sys.argv.(9)

  and outfile = Sys.argv.(10)

  in

  (* Open file *)
  let graph = Gfile.from_file infile in

  (* Créer une source générale*)
  let source0 = "Source0" in
  let graph2 = add_node graph source0 in
  let graph2 = add_arc graph2 source0 source1 "10000" in
  let graph2 = add_arc graph2 source0 source2 "10000" in
  let graph2 = add_arc graph2 source0 source3 "10000" in
  let graph2 = add_arc graph2 source0 source4 "10000" in
  (* Créer une destination générale*)
  let sink0 = "Sink0" in
  let graph2 = add_node graph2 sink0 in
  let graph2 = add_arc graph2 sink1 sink0 "10000" in
  let graph2 = add_arc graph2 sink2 sink0 "10000" in
  let graph2 = add_arc graph2 sink3 sink0  "10000" in
  let graph2 = add_arc graph2 sink4 sink0 "10000" in

  (* initialiser le graf*)
  let graph = Graph.map graph (fun chaine -> ("0",chaine))   in
  let graph2 = Graph.map graph2 (fun chaine -> ("0",chaine))   in

  let graph3 = Graph.algo graph2 graph source0 sink0 in
  let graph3 = Graph.maj_remove graph3 graph in

  (*
  (* Afficher un chemin  (id list), pour vérifier si notre chaine était optimale*)
  let () = Gfile.write_file_chemin outfile test1 graph _source _sink in *)

(*Afficher graphe en dot format*)
  let () = Gfile.export outfile graph3 in


(*Afficher en type graph comme en entrée *)
 (*let () = Gfile.write_file outfile graph in  *)

  ()
