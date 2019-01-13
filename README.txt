Auteurs du projet : Amine Lakhal 4IR B1 - Khalil Jamai 4IR B2


    Composition de notre projet ?

Le dossier build contient les fichiers .ml et .mli nécessaire à l'execution de l'algorithme.
Nous avons gardé les memes fichiers car cette disposition nous paraissait très claire et efficace :
    - ftest.ml qui fait appel au à l'algorithme puis affiche le résultat dans un fichier
    - graph.ml contenant l'algorithme
    - gfile.ml contenant les fonctions nécessaires pour afficher le résultat

    Comment ca marche ?

Compilation :
    - rm -f *.cmi *.cmo ftest ;
    - ocamlbuild ftest.byte ;

Il faut exécuter le fichier ftest en entrant les 3 paramètres nécessaires : le fichier que l'on va traiter, la Source et la Destination.
Il faut aussi ajouter un nom pour le fichier qui va etre généré en sortie
Exp : ./ftest.byte graph1 0 5  test0908 ;


    Notre algo ?

    Pour la recherche d'une chaine améliorante nous avons décidé de faire une exploration de graph en largeur.
Nous itérons donc une file, que l'on avait nommé fileZ et à chaque itération, on retire le 1er élement de cette file pour le traiter. Cela a donc été possible à l'aide d'une récursion.
Comme nous retirons des élements de la fileZ suite au itération, il nous fallait une autre liste afin de connaitre tout les noeuds qui ont été visités, la liste "marqueZ"
Une fois que l'on a atteint la destination à l'aide du parcours en largeur, nous faisons appel à une fonction "reconstitution" afin de trouver une chemin de la destination à la source.
C'est aussi à cela que sert notre 2e liste de noeuds "marqueZ" car les noeuds visités en dernier sont ajoutés en tete de liste et donc forcément le 1er élément est la destination et le dernier est la source.
On créer une chaine contenant au depart seulement la destination, et tant que cette liste n'a pas atteint la souce, on cherche le prédecesseur du 1er élément en tete de liste de cette chaine, parmi les noeuds dans la liste marqueZ
