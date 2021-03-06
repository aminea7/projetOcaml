type id = string

type 'a out_arcs = (id * 'a) list


(* A graph is just a list of pairs: a node & its outgoing arcs. *)
type 'a graph = (id * 'a out_arcs) list

exception Graph_error of string

let empty_graph = []

(******************************************************************************************************************************************)
(*******              Fonctions de base de traitements de graphes (itérations, ajout d'arcs, etc.)                               **********)
(******************************************************************************************************************************************)

let node_exists gr id = List.mem_assoc id gr

let out_arcs gr id =
  try List.assoc id gr
  with Not_found -> []

let find_arc gr id1 id2 =
  let out = if (out_arcs gr id1)!=[] then (out_arcs gr id1) else [] in
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

(******************************************************************************************************************************************)
(*******                     Fonctions Getteurs et Manipulations de liste                                                            ******)
(******************************************************************************************************************************************)

        (*  Avoir accès à l'option d'un arc, suite au renvoi de la fonction find_arc qui renvoit des 'a option (ou bien None)  *)
let get_option arc = match arc with
    |Some x -> x
    |_ -> ("err","get_option")

       (*   2 Getteurs pour récupérer les 2 résultats de la ft predecesseur_marque qui renvoie à la fois le predecesseur et la nouvelle liste de noeuds marqués *)
let get_nvlist res = match res with
  |(next_elmt,nv_list) -> nv_list
  |_-> failwith "Error get_nvlist"
let get_predecesseur res = match res with
  |(next_elmt,nv_list) -> next_elmt
  |_-> failwith "Error get_pred"

        (*   2 Getteurs pour récupérer les 2 résultats de la ft prédecesseur qui renvoie à la fois la nouvelle file de noeuds traités ainsi que la nouvelle liste de noeuds marqués *)
let getFileZ res = match res with
    |(fileZ,marqueZ) -> fileZ
    |_-> failwith "Error getFileZ"
let getMarqueZ res = match res with
    |(fileZ,marqueZ) -> marqueZ
    |_ -> failwith "Error getMarqueZ"

        (* Enlever un elm d'une liste *)
let rec remove_elm x = function
    |elm::rest -> if elm=x then rest else elm::(remove_elm x rest)
    |[]->[]

        (* Ajouter un elm à la fin d'une liste : Utile pour ajouter des éléments en fin de file car l'algorithme d'exploration en largeur utilise une file en FIFO *)
let add_elm lst a = lst @ [a]

        (* Verif si Node existe dans une liste <==> 1 des 2 Condition d'arret de la recherche de chemins *)
let rec exists_elm list x = match list with
    |h::rest -> if h=x then true else exists_elm rest x
    |[] -> false

        (* Recuperer 1er elm d'une liste *)
let first_elm list = match list with
    |h::rest -> h
    |[]-> failwith "File vide"

    (* Recuperer elm suivant (file) *)
let rec next_elm list x = match list with
    |h1::rest -> if h1=x then first_elm rest else (next_elm rest x)
    |h1::[]-> "Fin de la liste [next_elm]"
    |[] -> failwith "Error next_elm";;

    (* Verif si Node y si non marqué, donc non présent dans une liste M *)
let rec not_appartient_list list y = match list with
    |h::rest -> if h=y then false else not_appartient_list rest y
    |[] -> true


(******************************************************************************************************************************************)
(******                                  Fonctions de Manipulations d'arc et de flots                                                 *****)
(******************************************************************************************************************************************)

        (* Recupérer le flot ou la capacité d'un arc  *)
let get_flot s = match s with
    |(f,c)->f
    |_->failwith "Error get_flot"
let get_capa s = match s with
    |(f,c)->c
    |_->failwith "Error get_capa"

        (* Verifier le flot d'un arc : Si flot<capa *)
let verif_flot y = match y with
    |(flot,capa)-> if (flot!="err") then (if (int_of_string flot)<(int_of_string capa) then true else false) else false (*Le if sert d'abord à test si l'arc existe bien*)
    |_ -> failwith "Error verif_flot"

        (* Verifier le flot d'un arc : Si flot>0 *)
let verif_flot_pos y = match y with
    |(flot,capa)-> if (flot !="err") then (if (int_of_string flot)>0 then true else false) else false
    |_ -> failwith "Error verif_flot_pos"


    (******************************************************************************************************************************************)
    (*******      Fonctions de Recherches de Succésseurs et de Prédecesseurs, sans prendre en compte le flot, puis avec               *********)
    (******************************************************************************************************************************************)

        (*Recherche Prédecesseurs sans prendre en compte le flot *)
let rec rpa x idp = function
  |(ids,outs)::rest -> if ids=x then  idp  else  (rpa x idp rest)
  |[]->""
let r_pred x gr = List.map (fun (idp,out) -> rpa x idp out) gr

        (*Recherche Prédecesseurs en vérifiant le flot pour chaque noeud*)
(*let rec r_pred_flot x gr acu = match gr with
    |(idp,out)::rest -> (r_pred_flot x rest (rpaf x idp acu out))
    |_ -> acu *)

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
    (*|[]->failwith"Error r_succ_flot : node non existant"*)
    |[]->[]


(*********************************************************************************************************************************)
(****                                    Algo de Recherche d'une chaine améliorante                                          *****)
(*********************************************************************************************************************************)

        (***********   Etape5: Vérification si un noeud y peut etre un predecesseur d'un noeud x
                       Il faut que y ne soit pas déja dans le chemin en construction , qu'il existe un arc de y à x et que le flot soit acceptable  ***************)

               (*Vérification si un node est un prédecesseur de l'autre*)
let node_pred_marque gr x chemin_en_cours y = if (not_appartient_list chemin_en_cours y) && ((find_arc gr y x) != None)
                                                then (if (verif_flot (get_option (find_arc gr y x))) then true else false)
                                                    else false

             (*Vérification si un node est un Succésseur de l'autre. On n'utilise pas cette fonction dans notre algo*)
let node_succ_marque gr x chemin_en_cours y = if (not_appartient_list chemin_en_cours y) && ((find_arc gr x y) != None)
                                             then (if (verif_flot_pos (get_option (find_arc gr x y))) then true else false)
                                                else false

      (***********   Etape4: Recherche d'un predecesseur  d'un noeud dans la liste des noeuds marqués pour reconstituer une chaine
                     Retourne un noeud et la nouvelle liste des elements marqués qui ne contiennent que des elements qui peuvent potentiellement faire partie de la chaine  ***************)

let rec predecesseur_marque gr x chemin_en_cours =  function
  |y::rest -> if  (node_pred_marque gr x chemin_en_cours y) then (y,rest) else (predecesseur_marque gr x chemin_en_cours rest)
  |[] -> failwith "Pas de predecesseur_marque"  (*Normalement si on fait appel à cette fonction, c'est que l'on peut retrouver un chemin jusqu'à la source,
                                                  donc en théorie tout élement de la liste marqueZ a un predecesseur présent aussi dans la liste *)

        (************   Etape3: Reconstitution d'un chemin à partir d'une liste de Node marqués, en partant de la destination jusqu'à arriver à la source
                        Tant que l'on a pas atteint la source, on cherche le prédecesseur du dernier elm ajouté à la chaine en cours de construction
                        Renvoie un chemin qui est une liste des noeuds dont on doit augmenter le flot    ************)

let rec reconstitution_rev source sink acu gr marqueZ =
        if (first_elm acu)=source then acu
            else (reconstitution_rev source sink ((get_predecesseur (predecesseur_marque gr (first_elm acu) acu (List.rev(remove_elm sink marqueZ))))::acu)
                              gr marqueZ )

let rec reconstitution source sink acu gr marqueZ =
        if (first_elm acu)=source then acu
            else (reconstitution source sink ((get_predecesseur (predecesseur_marque gr (first_elm acu) acu ((remove_elm sink marqueZ))))::acu)
                              gr marqueZ )



       (************ Etape 2: Itérateur sur une liste contenant dees Succésseurs pour vérifier chaque noeud
                     si on peut l'ajouter à la file et à la liste des noeuds marqués, Il faut que ces noeuds soient non marqués
                     Renvoie nvelle file et nvelle liste des noeuds marqués  ************)

let rec verif_list_succ fileZ marqueZ = function
   |x::rest -> if (not_appartient_list marqueZ x) then (verif_list_succ (add_elm fileZ x) (x::marqueZ) rest) else (verif_list_succ fileZ marqueZ rest)
   |[] -> (fileZ,marqueZ)       (* On a besoin de ces 2 elements pour la suite de l'algo, il faut donc des getteurs pour ces 2 listes *)


       (**********  Etape 1: Iterations sur la fileZ : on retire le 1er elm (à l'aide de la récursion et on traite ses Succésseurs avec un appel à la ft verif_list_succ
                    A la fin retourne une liste avec tout les noeuds marqués (marqueZ)   *************)

let rec iter_file fileZ marqueZ gr sink = match fileZ with
|x::_ -> if (exists_elm marqueZ sink) then marqueZ
                                        else (iter_file (getFileZ   (verif_list_succ (remove_elm x fileZ)  marqueZ (r_succ_flot x gr)))
                                                        (getMarqueZ (verif_list_succ (remove_elm x fileZ)  marqueZ (r_succ_flot x gr)))
                                                         gr sink)
|[]-> [] (* Si la fonction renvoie une liste vide, on saura qu'il n'y a pas de chaine améliorante *)

        (*********************  Algo: Recherche d'un chemin     ***********************)

let chemin gr source sink fileZ marqueZ =   (*OKKK*)
    let list_mark = iter_file [source] [source] gr sink in  (* Recoit la liste de tout les noeuds marqués entre la destination et la source*)
        if list_mark!=[] then (reconstitution source sink [sink] gr (remove_elm sink list_mark)) (* Si list_mark est vide alors on ne peut pas faire de reconstitution comme il n'y a pas de chemin*)
                            else []   (* Si le ft renvoie chemin, l'algo principal peut tester si chemin (...)!=[] comme condition d'arret*) (*On aurait pu utiliser des exceptions aussi*)

let chemin_rev gr source sink fileZ marqueZ =   (*OKKK*)
    let list_mark = iter_file [source] [source] gr sink in  (* Recoit la liste de tout les noeuds marqués entre la destination et la source*)
        if list_mark!=[] then (reconstitution_rev source sink [sink] gr (remove_elm sink list_mark)) (* Si list_mark est vide alors on ne peut pas faire de reconstitution comme il n'y a pas de chemin*)
                            else []   (* Si le ft renvoie chemin, l'algo principal peut tester si chemin (...)!=[] comme condition d'arret*) (*On aurait pu utiliser des exceptions aussi*)

(****************************************************************************************************)
(***                   Diminution d'un flot à partir d'une chaine                             *******)
(****************************************************************************************************)

(* recuperer le flot d'un arc (id1,id2) avec id2 succ de id1 *)

let rec recup_flot_succ_aux id2 = function
  |[]->""
  |(ids,(f,c))::rest -> if (ids=id2) then string_of_int(int_of_string c-int_of_string f) else recup_flot_succ_aux id2 rest

let rec recup_flot_succ id1 id2 = function
  |[] -> ""
  |(idp,out)::rest -> if (idp=id1) then recup_flot_succ_aux id2 out else recup_flot_succ id1 id2 rest

(* recuperer le flot d'un arc (id1,id2) avec id2 pred de id1 *)

let rec recup_flot_pred_aux id2 = function
  |[]->""
  |(ids,(f,c))::rest -> if (ids=id2) then f else recup_flot_pred_aux id2 rest

let rec recup_flot_pred id1 id2 = function
  |[] -> ""
  |(idp,out)::rest -> if (idp=id1) then recup_flot_pred_aux id2 out else recup_flot_pred id1 id2 rest

(* liste des augmentations de flot possibles : parcourir la chaine ameliorante et regarder chaque element par rapport à celui d'après s'il est son succ ou son pred*)

let liste_aug_flots gr gr_initial chaine =
  let rec loop gr acu = function
    |[]->[]
    |id::[]-> acu
    |id::rest -> if exists_elm (r_succ id gr_initial) (next_elm chaine id)
                    then loop gr ((recup_flot_succ id (next_elm chaine id) gr)::acu) rest
                        else loop gr ((recup_flot_pred (next_elm chaine id) id gr)::acu) rest
  in
  loop gr [] chaine

(* calcul de flot min , min_flot prend la liste des augmentations possibles *)
let min x y = if (int_of_string x) < (int_of_string y) then x else y

let min_flot = function
|x::rest -> List.fold_left min x rest
|[]-> failwith "liste vide"

(*----- mettre à jour le graphe -----*)

        (* augmentation flot pour les arcs (id1,id2) avec id2 succ de id1 *)

let rec aug_flot_succ_aux id2 min = function
  |[]->[]
  |(ids,(f,c))::rest -> if (ids=id2) then (ids,(string_of_int(int_of_string f + int_of_string min),c))::rest
                            else (ids,(f,c))::aug_flot_succ_aux id2 min rest

let rec aug_flot_succ id1 id2 min = function
  |[] -> []
  |(idp,out)::rest -> if (idp=id1) then (idp,aug_flot_succ_aux id2 min out)::rest
                      else (idp,out)::aug_flot_succ id1 id2 min rest

        (* diminution flot pour les arcs (id1,id2) avec id2 pred de id1 *)

let rec dim_flot_pred_aux id2 min = function
  |[]->[]
  |(ids,(f,c))::rest -> if (ids=id2) then (ids,(string_of_int(int_of_string f - int_of_string min),c))::rest
                        else (ids,(f,c))::dim_flot_pred_aux id2 min rest

let rec dim_flot_pred id1 id2 min = function
  |[] -> []
  |(idp,out)::rest -> if (idp=id1) then (idp,dim_flot_pred_aux id2 min out)::rest
                    else (idp,out)::dim_flot_pred id1 id2 min rest


(*****************)

let maj_inverse_aug id1 id2 min gr gr_initial =
    if ((find_arc gr_initial id2 id1) = None)    (* L'arc de id1 à 2 n'a pas d'arc retour dans le graf inital  *)
(*if (true)*)
        then (if ((find_arc gr id2 id1) = None)
                  then (add_arc gr id2 id1 ((string_of_int(int_of_string (get_capa (get_option (find_arc gr id1 id2))) - int_of_string (get_flot (get_option (find_arc gr id1 id2))))),(get_capa (get_option (find_arc gr id1 id2)))))
                   else (dim_flot_pred id2 id1 min gr))
          (*else (dim_flot_pred id2 id1 min gr)*)
          else gr


let maj_inverse_dim id1 id2 min gr gr_initial =
(*if(true) *)
    if(((find_arc gr_initial id2 id1) = None))       (* L'arc de id1 à 2 n'a pas d'arc retour dans le graf inital  *)
            then (if ((find_arc gr id2 id1) = None)
                      then (add_arc gr id2 id1 ((string_of_int(int_of_string (get_capa (get_option (find_arc gr id1 id2))) -
                                                               int_of_string (get_flot (get_option (find_arc gr id1 id2))))),
                                                (get_capa (get_option (find_arc gr id1 id2)))))
                       else (aug_flot_succ id2 id1 min gr))
            (*  else (aug_flot_succ id2 id1 min gr) *)
            else gr

(*****************)

        (* mettre à jour le graphe : parcourir la chaine ameliorante, rechercher les arcs dans le graph et modifier le flot avec les fcts aug_flot_succ et dim_flot_pred *)
(*
let rec maj_gr gr gr_initial chaine min = match chaine with
  |[]->gr
  |id::[]->gr
  |id::rest -> if exists_elm (r_succ id gr_initial) (next_elm chaine id)
                    then  (maj_gr (aug_flot_succ id (next_elm chaine id) min gr) gr_initial rest min)
                    else  (maj_gr (dim_flot_pred (next_elm chaine id) id min gr) gr_initial rest min)
*)
(* Version 2 : en créant/modifiant des arcs inverses à chaque modification du flot d'un arc donné *)

let rec maj_gr gr gr_initial chaine min = match chaine with
  |[]->gr
  |id::[]->gr
  |id::rest -> if exists_elm (r_succ id gr_initial) (next_elm chaine id)
                    then  (maj_gr (maj_inverse_aug id (next_elm chaine id) min (aug_flot_succ id (next_elm chaine id) min gr) gr_initial) gr_initial rest min)
                    else  (maj_gr (maj_inverse_dim (next_elm chaine id) id min (dim_flot_pred (next_elm chaine id) id min gr) gr_initial) gr_initial rest min)


(* l'algorithme final : tant qu'il y a une chaine ameliorante on calcule le min (min_flot) et on met à jour le graphe (maj_gr)*)

let rec algo gr gr_initial source sink  =
  let chaine = chemin_rev gr source sink [source] [source] in
   if chaine = [] then gr else
     let min = min_flot(liste_aug_flots gr gr_initial chaine) in
     algo (maj_gr gr gr_initial chaine min) gr_initial source sink



let rec maj_remove_aux id gr = function
  |(x,y)::rest -> (x,get_option(find_arc gr id x))::(maj_remove_aux id gr rest)
  |[]->[]

let rec maj_remove gr gr_initial  = List.map (fun (id,out) -> (id, maj_remove_aux id gr out)) gr_initial




(* Vérifier l'usage des arcs inverses *)
let rec algo2 gr gr_initial source sink  =
  let chaine = chemin_rev gr source sink [source] [source] in
     let min = min_flot(liste_aug_flots gr gr_initial chaine) in
        maj_gr gr gr_initial chaine min


let rec algo1 gr gr_initial source sink  =
  let chaine = chemin gr source sink [source] [source] in
     let min = min_flot(liste_aug_flots gr gr_initial chaine) in
       maj_gr gr gr_initial chaine min



(*------------*)
