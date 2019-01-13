(* Read a graph from a file,
 * Write a graph to a file. *)

open Graph

type path = string

val get_flot: (string*string)-> string
val get_capa: (string*string)-> string
val first_elm: id list -> id
val next_elm: id list -> id -> id

(* Values are read as strings. *)
val from_file: path -> string graph


(* Similarly, we write only a string graph.
 * Use Graph.map if necessary to prepare the input graph. *)

val write_file: path -> (string*string) graph -> unit
val write_file_chemin: path -> id list -> (string*string) graph -> id -> id -> unit
val export : path -> (string*string) graph -> unit