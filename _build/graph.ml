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



let get_option arc = match arc with
|Some x -> x
|_ -> failwith "Error get_option" ;;

       (*2 Get pour récupérer les 2 résultats de la ft prédecesseur *)
let get_nvlist res = match res with
  |(next_elmt,nv_list) -> nv_list
  |_-> failwith "Error get_nvlist"
let get_pred res = match res with
  |(next_elmt,nv_list) -> next_elmt
  |_-> failwith "Error get_pred"

let append l1 l2 =
  let rec loop acc l1 l2 =
    match l1, l2 with
    | [], [] -> List.rev acc
    | [], h :: t -> loop (h :: acc) [] t
    | h :: t, l -> loop (h :: acc) t l
    in
    loop [] l1 l2

        (* Enlever un elm à la file *)
let rec remove_elm x = function
    |elm::rest -> if elm=x then rest else elm::(remove_elm x rest)
    |[]->[]

        (* Ajouter un elm à la fin de la file *)
let add_elm lst a = lst @ [a]

        (* Récupérer la 1ère liste ou la 2e liste renvoyée par la ft iter_file : fileZ et marqueZ*)
let getFileZ res = match res with
    |(fileZ,marqueZ) -> fileZ
    |_-> failwith "Error getFileZ"
let getMarqueZ res = match res with
    |(fileZ,marqueZ) -> marqueZ
    |_ -> failwith "Error getMarqueZ"



        (* Verif flot d'un arc : Si flot<capa *)

let verif_flot y = match y with
|(flot,capa)-> if (int_of_string flot)<(int_of_string capa) then true else false

        (* Verif flot d'un arc : Si flot>0 *)

let verif_flot_pos y = match y with
|(flot,capa)-> if (int_of_string flot)>0 then true else false

        (* Verif si Node y si non marqué, donc non présent dans une liste M *)

let rec not_appartient_list list y = match list with
|h::rest -> if h=y then false else not_appartient_list rest y
|[] -> true

        (* Verif si Node existe dans une liste <==> 1 des 2 Condition d'arret de la recherche de chemins *)

let rec exists_elm list x = match list with
    |h::rest -> if h=x then true else exists_elm rest x
    |[] -> false

        (* Recuperer 1er elm *)
let first_elm list = match list with
    |h::rest -> h
    |[]-> failwith "File vide"

    (* Recuperer elm suivant (file) *)
let rec next_elm list x = match list with
|h1::rest -> if h1=x then first_elm rest else (next_elm rest x)
|h1::[]-> "Fin de la liste [next_elm]"
|[] -> failwith "Error next_elm";;

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
    |[]->failwith "Pas de Succésseurs"





      (***********  Etape4: Recherche d'un predecesseur d'un node dans la liste des noeuds marqués pour reconstituer une chaine
          Retourne un noeud et la nouvelle liste des elements marqués   ***************)

let rec predecesseur gr x chemin_en_cours =  function   (*OKK*)
  (*|y::rest -> if  ((find_arc gr y x) != None) && (not_appartient_list chemin_en_cours y) then y else ((if  (find_arc gr x y) != None then y else predecesseur gr x rest)) *)
  |y::rest -> if  ((find_arc gr y x) != None) && (not_appartient_list chemin_en_cours y)
                      then (y,rest)
                       else (predecesseur gr x chemin_en_cours rest)
  |[] -> failwith "Pas de predecesseur"



        (************   Etape3 : Reconstitution du chemin à partir d'une liste de Node marqués
        Renvoie une liste des noeuds dont on doit augmenter le flot    ************)

let rec reconstitution source acu gr marqueZ = (*OK*)
        if (first_elm acu)=source then acu
         else (reconstitution source ((get_pred (predecesseur gr (first_elm acu) acu marqueZ))::acu)
                              gr marqueZ )


       (************ Etape 2: Itérateurs sur une liste contenant les Succésseurs/Prédecesseurs pour Verifier chaque Node x si non marqué
           puis renvoie nvelle file et nvelle liste des noeuds marqués  ************)

let rec verif_succ fileZ marqueZ = function  (*OK*)
   |x::rest -> if (not_appartient_list marqueZ x) then (verif_succ (add_elm fileZ x) (x::marqueZ) rest) else (verif_succ fileZ marqueZ rest)
   |[] -> (fileZ,marqueZ)


       (********** Etape 1: Iterations sur la fileZ : on retire le 1er elm et on traite ses Succésseurs et predecesseurs avec un appel à la ft verif pr chacun
           A la fin retourne une liste avec tt les noeuds marqués *************)

let rec iter_file fileZ marqueZ gr sink = match fileZ with (*ok*)
|[x]-> if (exists_elm marqueZ sink) then marqueZ
                                       else (iter_file (getFileZ   (verif_succ (remove_elm x fileZ) marqueZ (r_succ_flot x gr)))
                                                       (getMarqueZ (verif_succ (remove_elm x fileZ) marqueZ (r_succ_flot x gr)))
                                                       gr sink)

|x::_ -> if (exists_elm marqueZ sink) then marqueZ
(*                                     else (iter_file (getFileZ (verif (remove_elm x fileZ) marqueZ (append (r_succ_flot x gr)(r_pred_flot x gr))))
                                                       (getMarqueZ (verif (remove_elm x fileZ) marqueZ (append (r_succ_flot x gr)(r_pred_flot x gr))))
                                                       gr sink)
*)
                                       else (iter_file (getFileZ   (verif_succ (remove_elm x fileZ) marqueZ (r_succ_flot x gr)))
                                                       (getMarqueZ (verif_succ (remove_elm x fileZ) marqueZ (r_succ_flot x gr)))
                                                       gr sink)

|[]-> failwith "Pas de chemin trouvé [Error iter_file]"

        (********************* Algo: Recherche d'un chemin ***********************)

let chemin gr source sink fileZ marqueZ =   (*OKKK*)
    (*list_marque= iter_file [source] [source] gr sink ; *)
    reconstitution source [sink] gr (iter_file [source] [source] gr sink)



(****************************************************************************************************)
(****************************************************************************************************)





(* initialiser le flot à 0 pour tous les arcs *)
(*
let rec flot_init_aux = function
  |[]-> failwith "sink !"
  |(ids,(f,c))::rest -> (ids,("0",c)) :: flot_init_aux rest

let rec flot_init = function
  |[]-> []
  |(idp,out)::rest -> (idp,flot_init_aux out) :: flot_init rest
*)
(* recuperer flot succ *)

let rec recup_flot_succ_aux id2 = function
  |[]->""
  |(ids,(f,c))::rest -> if (ids=id2) then string_of_int(int_of_string c-int_of_string f) else recup_flot_succ_aux id2 rest

let rec recup_flot_succ id1 id2 = function
  |[] -> ""
  |(idp,out)::rest -> if (idp=id1) then recup_flot_succ_aux id2 out else recup_flot_succ id1 id2 rest

(* recuperer flot pred *)

let rec recup_flot_pred_aux id2 = function
  |[]->""
  |(ids,(f,c))::rest -> if (ids=id2) then f else recup_flot_pred_aux id2 rest

let rec recup_flot_pred id1 id2 = function
  |[] -> ""
  |(idp,out)::rest -> if (idp=id1) then recup_flot_pred_aux id2 out else recup_flot_pred id1 id2 rest

(* liste des augmentations possibles *)

let liste_aug_flots gr chaine =
  let rec loop gr acu = function
    |[]->[]
    |id::[]-> acu
    |id::rest -> if exists_elm (r_succ id gr) (next_elm chaine id) then loop gr ((recup_flot_succ id (next_elm chaine id) gr)::acu) rest else loop gr ((recup_flot_pred (next_elm chaine id) id gr)::acu) rest
  in
  loop gr [] chaine

(* calcul de flot min *)
let min x y = if (int_of_string x) < (int_of_string y) then x else y

let min_flot = function
|x::rest -> List.fold_left min x rest
|[]-> failwith "liste vide"

(*----- mettre à jour le graphe -----*)
(* augmentation flot succ *)

let rec aug_flot_succ_aux id2 min = function
  |[]->[]
  |(ids,(f,c))::rest -> if (ids=id2) then (ids,(string_of_int(int_of_string f + int_of_string min),c))::rest else (ids,(f,c))::aug_flot_succ_aux id2 min rest

let rec aug_flot_succ id1 id2 min = function
  |[] -> []
  |(idp,out)::rest -> if (idp=id1) then (idp,aug_flot_succ_aux id2 min out)::rest else (idp,out)::aug_flot_succ id1 id2 min rest

(* diminution flot pred *)

let rec dim_flot_pred_aux id2 min = function
  |[]->[]
  |(ids,(f,c))::rest -> if (ids=id2) then (ids,(string_of_int(int_of_string f - int_of_string min),c))::rest else (ids,(f,c))::dim_flot_pred_aux id2 min rest

let rec dim_flot_pred id1 id2 min = function
  |[] -> []
  |(idp,out)::rest -> if (idp=id1) then (idp,dim_flot_pred_aux id2 min out)::rest else (idp,out)::dim_flot_pred id1 id2 min rest

(******)

let rec maj_gr gr chaine min = match chaine with
  |[]->gr
  |id::[]->gr
  |id::rest -> if exists_elm (r_succ id gr) (next_elm chaine id) then (maj_gr (aug_flot_succ id (next_elm chaine id) min gr) rest min) else (maj_gr (dim_flot_pred (next_elm chaine id) id min gr) rest min)

(*------------*)

let rec algo gr source sink  = 
  let chaine = chemin gr source sink [source] [source] in
   if chaine = [] then gr else 
     let min = min_flot(liste_aug_flots gr chaine) in 
     algo (maj_gr gr chaine min) source sink




(*------------*)



(*Reconstitution du chemin à partir d'une liste de Node marqués *)
(*ATTENTION : Il faut inverser la list acu l.167*)
(*let rec reconstitution source acu list gr marqueZ = match list with
|[x] -> reconstitution source ((predecesseur gr x rest)::acu) gr (predecesseur gr x rest)
|x::rest -> reconstitution source ((predecesseur gr x rest)::acu) gr rest
|[] -> if (first_elm acu)=source then acu else failwith "Error reconstitution"
*)
