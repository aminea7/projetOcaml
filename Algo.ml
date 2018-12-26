//Enlever un elm à la file
let rec remove_elm x = function
    |elm::rest -> if elm=x then rest else elm::(remove_elm x rest)
    |[]->[]
----------------------------------------------------------
____________Fonctions___________________

        //Recuperer 1er elm
let first_elm list = match list with
    |h::rest -> h
    |[]-> failwith "File vide" ;;

        //Recuperer elm suivant (file) + Condition de file vide
let rec next_elm list x = match list with
    |h1::rest -> if h1=x then first_elm rest else (next_elm rest x)
    |[]-> "File vide" ;;

        //Enlever le 1er elm maj de la file
let remove_first list = match list with
    |h::rest -> rest
    |[]-> failwith "File vide" ;;

        //Ajouter un elm à la fin de la file
let add_elm lst a = lst @ [a] ;;

        //Verifier si un noeud appartient à la liste
let rec exists_elm list x = match list with
    |h::rest -> if h=x then true else exists_elm rest x
    |[] -> false

        //condition d'arret : Sink dans la file, ou la file est remplie
let rec stop_recherche graf source sink liste =
    if ((exists_elm file sink) || ((next_elm file (first_elm liste))="File vide")) then true else false

//Pour savoir que Z est vide : length(file2) - length(fileZ) =0
        //Algo
let recherche graf source sink =  let rec rech graf source sink file = function
        //Initialisation
        add_elm file source in
        x = add_elm in
        //Tant que
        if condition
        iter_succ (pred liste ....)
        iter_pred
        in loop ...
        //Fin
        si chaine
        sinon

    in rech graf source sink [] ;;

let iter_succ x  = ....List.iterator (succ x) (si c bon (flot ok et non marqué) alors ajouter à la liste)
let iter_pred x


    function
|A::rest -> function(rest::recherche_succ_possibles A))
