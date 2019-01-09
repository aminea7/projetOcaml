
(* Type of a directed graph in which arcs have labels of type 'a. *)
type 'a graph

(* Each node has a unique identifier (a name). *)
type id = string

exception Graph_error of string


(**************  CONSTRUCTORS  **************)

(* The empty graph. *)
val empty_graph: 'a graph

(* Add a new node with the given identifier.
 * @raise Graph_error if the id already exists. *)
val add_node: 'a graph -> id -> 'a graph

(* add_arc gr id1 id2 lbl  : adds an arc from node id1 to node id2 with label lbl
 * If an arc already exists between id1 and id2, its label is replaced by lbl.
 * @raise Graph_error if id1 or id2 does not exist in the graph. *)
val add_arc: 'a graph -> id -> id -> 'a -> 'a graph


(**************  GETTERS  *****************)

(* node_exists gr id  indicates if the node with identifier id exists in graph gr. *)
val node_exists: 'a graph -> id -> bool

(* Type of lists of outgoing arcs of a node.
 * An arc is represented by a pair of the destination identifier and the arc label. *)
type 'a out_arcs = (id * 'a) list

(* Find the out_arcs of a node.
 * @raise Graph_error if the id is unknown in the graph. *)
val out_arcs: 'a graph -> id -> 'a out_arcs

(* find_arc gr id1 id2  finds an arc between id1 and id2 and returns its label. Returns None if the arc does not exist.
* @raise Graph_error if id1 is unknown. *)
val find_arc: 'a graph -> id -> id -> 'a option


(**************  COMBINATORS, ITERATORS  **************)

val append : string list -> string list -> string list

(* Iterate on all nodes.
 * v_iter gr f
 * f is applied with each node: f id (list-of-successors) *)
val v_iter: 'a graph -> (id -> 'a out_arcs -> unit) -> unit

val v_fold: 'a graph -> ('b -> id -> 'a out_arcs -> 'b) -> 'b -> 'b

(* maps all arcs of the graph
 * Nodes keep the same identifiers. *)
val map: 'a graph -> ('a -> 'b) -> 'b graph



(* vérifications *)
val add_elm: id list -> id -> id list
val verif_flot: (string*string) -> bool
val verif_flot_pos: (string*string) -> bool
val verif_list: id list -> id -> bool
val exists_elm: id list -> id -> bool
val first_elm: id list -> id


    (* Recherche de Succésseurs/Prédecesseurs, sans et avec prise en compte du flot *)
val r_pred: id-> 'a graph ->  id list
val r_succ: id-> 'a graph ->  id list
val r_pred_flot: id-> (string*string) graph ->  id list
val r_succ_flot: id-> (string*string) graph ->  id list

val predecesseur: (string*string) graph -> id -> id list -> id


    (* Itérateur sur une liste contenant les Succésseurs/Prédecesseurs pour Verifier chaque Node y si non marqué + flot ok *)
val verif: id list -> id list -> id list -> id list * id list

    (* Itérateur sur les noeuds de la file  *)
val iter_file: id list -> id list -> (string*string) graph -> id -> id list

val reconstitution: id -> id list -> (string*string) graph -> id list -> id list

(*Normalement : *)
    val chemin: (string * string) graph -> id -> id -> id list -> id list

 (*val chemin :
           (string * (string * (string * string)) list) list ->
           string -> string -> string list -> string list
*)

(*list.iter => Afficher sans write*)
(*
val flot_init_aux : string->(string*(string*string)) list -> (string*(string*string)) list
val flot_init : string->string->(string*string) graph -> (string*string) graph

val recup_flot_succ_aux : string->(string*(string*string)) list -> string
val recup_flot_succ : string->string->(string*string) graph -> string

val recup_flot_pred_aux : string->(string*(string*string)) list -> string
val recup_flot_pred : string->string->(string*string) graph -> string

val liste_aug_flots : (string*string) graph -> string list-> string list

val min : string->string->string
val min_flot : string list -> string

val aug_flot_succ_aux : string->string->(string*(string*string)) list -> (string*(string*string)) list
val aug_flot_succ : string->string->string->(string*string) graph -> (string*string) graph

val dim_flot_succ_aux : string->string->(string*(string*string)) list -> (string*(string*string)) list
val dim_flot_succ : string->string->string->(string*string) graph -> (string*string) graph

val mise_a_jour_gr : (string*string) graph -> string list -> (string*string) graph
*)
