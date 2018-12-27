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


let append l1 l2 =
  let rec loop acc l1 l2 =
    match l1, l2 with
    | [], [] -> List.rev acc
    | [], h :: t -> loop (h :: acc) [] t
    | h :: t, l -> loop (h :: acc) t l
    in
    loop [] l1 l2


        (* Ajouter un elm à la fin de la file *)
let add_elm lst a = lst @ [a]

        (* Verif flot d'un arc : Si flot<capa *)

let verif_flot y = match y with
|(flot,capa)-> if (int_of_string flot)<(int_of_string capa) then true else false

        (* Verif flot d'un arc : Si flot>0 *)

let verif_flot_pos y = match y with
|(flot,capa)-> if (int_of_string flot)>0 then true else false

        (* Verif si Node y si non marqué, donc non présent dans une liste M *)

let rec verif_list list y = match list with
|h::rest -> if h=y then false else verif_list rest y
|[] -> true


        (*Recherche Prédecesseurs sans prendre en compte le flot *)

let rec rpa x idp = function
  |(ids,outs)::rest -> if ids=x then  idp  else  (rpa x idp rest)
  |[]->""

let r_pred x gr = List.map (fun (idp,out) -> rpa x  idp out) gr

        (*Recherche Prédecesseurs en vérifiant le flot*)

let rec rpaf x idp = function
|(ids,outs)::rest -> if (ids=x)&&(verif_flot_pos outs) then idp  else (rpaf x idp rest)
|[]->""

let r_pred_flot x gr = List.map (fun (idp,out) -> rpaf x idp out) gr


        (*Recherche Succésseurs sans prendre en compte le flot*)

let rec rsa acu = function
  |(ids,outs)::rest -> rsa (ids::acu) rest
  |[]-> acu

let rec r_succ x = function
  |(idp,out)::rest -> if (idp=x) then rsa [] out else r_succ x rest
  |[]->[]

        (*Recherche Succésseurs en vérifiant le flot *)

let rec rsaf acu = function
    |(ids,outs)::rest -> if (verif_flot outs) then (rsaf (ids::acu) rest) else (rsaf acu rest)
    |[]-> acu

let rec r_succ_flot x = function
    |(idp,out)::rest -> if (idp=x) then rsaf [] out else r_succ_flot x rest
    |[]->[]

        (* Itérateurs sur une liste contenant les Succésseurs/Prédecesseurs pour Verifier chaque Node y si non marqué + flot ok *)

let verif listeSucPred fileZ marqueZ x = List.map  (fun x fileZ marqueZ -> if (verif_list marqueZ x) then (add_elm marqueZ x ; add_elm fileZ x) else failwith "zbi") listeSucPred

        (* Recherche de Successeurs et Predesseurs non marqué et avec un flot modifiable *)

        (* Iterations sur la fileZ *)

let iterZ fileZ marqueZ gr= List.map (fun listeSucPred fileZ marqueZ x -> verif ((append (r_succ_flot x gr) )(r_pred_flot x gr)) fileZ marqueZ x) fileZ

        (* Algo: Recherche chemin *)

let chemin gr source sink = let rec rech gr source sink fileZ marqueZ =
add_elm fileZ source ;
add_elm marqueZ source ;
iterZ fileZ marqueZ gr ;
in rech gr source sink [] []
