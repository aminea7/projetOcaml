open Printf
open Graph

type path = string
type arc = string*string

(* Format of text files: lines of the form
 *
 *  v id               (node with the given identifier)
 *  e label id1 id2    (arc with the given (string) label. Goes from node id1 to node id2.)
 *
 *)

 let get_option arc = match arc with
 |Some x -> x
 |_ -> failwith "Error get_option" ;;

let get_flot s = match s with
    |(f,c)->f
    |_->failwith "Error get_flot"

let get_capa s = match s with
        |(f,c)->c
        |_->failwith "Error get_capa"

let first_elm list = match list with
    |h::rest -> h
    |[]-> failwith "File vide"

    (* Recuperer elm suivant (file) *)
let rec next_elm list x = match list with
|h1::rest -> if h1=x then first_elm rest else (next_elm rest x)
|h1::[]-> "Fin de la liste [next_elm]"
|_ -> failwith "Error next_elm"


let write_file path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "=== Graph file ===\n\n" ;

  (* Write all nodes *)
  v_iter graph (fun id _ -> fprintf ff "v %s\n" id) ;
  fprintf ff "\n" ;

  (* Write all arcs *)
  (*v_iter graph (fun id out -> List.iter (fun (id2, lbl) -> fprintf ff "e \"%s\" %s %s\n" lbl id id2) out) ;*)
  v_iter graph (fun id out -> List.iter (fun (id2, lbl) -> fprintf ff "e \"%s/%s\" %s %s\n" (get_flot lbl) (get_capa lbl) id id2) out) ;


  fprintf ff "\n=== End of graph ===\n" ;

  close_out ff ;
  ()

  let write_file_chemin path chemin gr =

    (* Open a write-file. *)
    let ff = open_out path in

    (* Write in this file. *)
    fprintf ff "=== Graph file ===\n\n" ;

    (* Write all nodes *)
    v_iter gr (fun id _ -> fprintf ff "v %s\n" id) ;
    fprintf ff "\n" ;

    (* Write all arcs *)
    (*v_iter graph (fun id out -> List.iter (fun (id2, lbl) -> fprintf ff "e \"%s\" %s %s\n" lbl id id2) out) ;*)
    List.iter (fun id -> fprintf ff "e \"%s/%s\" %s %s\n" (get_flot (get_option (Graph.find_arc gr id (next_elm ["df"] id)))) (get_capa (get_option (Graph.find_arc gr id (next_elm chemin id)))) id (next_elm chemin id)) chemin ;

    fprintf ff "\n=== End of graph ===\n" ;

    close_out ff ;
    ()


(* Reads a line with a node. *)
let read_node graph line =
  try Scanf.sscanf line "v %s" (fun id -> add_node graph id)
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a line with an arc. *)
let read_arc graph line =
  try Scanf.sscanf line "e \"%s@\" %s %s" (fun label id1 id2 -> add_arc graph id1 id2 label)
  with e ->
    Printf.printf "Cannot read arc in line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"

let from_file path =

  let infile = open_in path in

  (* Read all lines until end of file. *)
  let rec loop graph =
    try
      let line = input_line infile in
      let graph2 =
        (* Ignore empty lines *)
        if line = "" then graph

        (* The first character of a line determines its content : v or e.
         * Lines not starting with v or e are ignored. *)
        else match line.[0] with
          | 'v' -> read_node graph line
          | 'e' -> read_arc graph line
          | _ -> graph
      in
      loop graph2
    with End_of_file -> graph
  in

  let final_graph = loop empty_graph in

  close_in infile ;
  final_graph
