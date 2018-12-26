type id = string

type 'a out_arcs = (id * 'a) list

(* A graph is just a list of pairs: a node & its outgoing arcs. *)
type 'a graph = (id * 'a out_arcs) list

exception Graph_error of string

let empty_graph = []

let node_exists gr id = List.mem_assoc id gr

let out_arcs gr id =
  try List.assoc id gr
  with Not_found -> raise (Graph_error ("Node " ^ id ^ " does not exist in this graph."))

let find_arc gr id1 id2 =
  let out = out_arcs gr id1 in
  try Some (List.assoc id2 out)
  with Not_found -> None

let add_node gr id =
  if node_exists gr id then raise (Graph_error ("Node " ^ id ^ " already exists in the graph."))
  else (id, []) :: gr

let add_arc gr id1 id2 lbl =

  (* Existing out-arcs *)
  let outa = out_arcs gr id1 in

  (* Update out-arcs.
   * remove_assoc does not fail if id2 is not bound.  *)
  let outb = (id2, lbl) :: List.remove_assoc id2 outa in

  (* Replace out-arcs in the graph. *)
  let gr2 = List.remove_assoc id1 gr in
  (id1, outb) :: gr2

let v_iter gr f = List.iter (fun (id, out) -> f id out) gr
let v_iter2 gr f = List.iter (fun (id, out) -> f out) gr


let v_fold gr f acu = List.fold_left (fun acu (id, out) -> f acu id out) acu gr

let rec map_aux f = function
  |(x,y)::rest -> (x, f y)::(map_aux  f rest)
  |[]->[]

let rec map gr f   = List.map (fun (id,out) -> (id, map_aux f out)) gr

    (* Ajouter un elm à la fin de la file *)
let add_elm lst a = lst @ [a]


    (*Recherche Prédecesseurs *)

let rec rpa x idp = function
  |(ids,outs)::rest -> if ids=x then  idp  else  (rpa x idp rest)
  |[]->""

let r_pred x gr = List.map (fun (idp,out) -> rpa x  idp out) gr

    (*Recherche Succésseurs *)

let rec rsa acu = function
  |(ids,outs)::rest -> rsa (ids::acu) rest
  |[]-> acu

let rec r_succ x = function
  |(idp,out)::rest -> if (idp=x) then rsa [] out else r_succ x rest
  |[]->[]


    (* Verif flot d'un node : Si flot<capa *)

let verif_flot y = match y with
  |(flot,capa)-> if flot<capa then true else false
  |(_,_)->false

    (* Verif si Node y si non marqué, donc non présent dans une liste M *)

let rec verif_list list y = match list with
    |h::rest -> if h=y then true else verif_list rest y
    |[] -> false

    (* Verif si Node y si non marqué + flot ok *)
let rec verif list y =  if (verif_list list y)&&(verif_flot y) then true else false


    (* Recherche de Successeurs et Predesseurs non marqué et avec un flot modifiable *)



    (* iterations *)
let rec iterZ fileZ marqueZ gr= match fileZ with
  |x::rest -> List.map (fun marqueZ x -> (if (verif marqueZ x) then (add_elm fileZ x ;add_elm marqueZ x) else failwith "zbi" );iterZ rest) (r_succ x gr)
  |[]->[]

let chemin gr source sink = let rec rech gr source sink fileZ marqueZ =
add_elm fileZ source ;
add_elm marqueZ source ;
iterZ fileZ marqueZ gr ;
in rech gr source sink [] []
