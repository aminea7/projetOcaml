Auteurs du projet : Amine Lakhal 4IR B1 - Khalil Jamai 4IR B2


    Composition de notre projet ?

Le dossier build contient les fichiers .ml et .mli nécessaire à l'execution de l'algorithme.
Nous avons gardé les memes fichiers car cette disposition nous paraissait très claire et efficace :
    - ftest.ml qui fait appel au à l'algorithme puis affiche le résultat dans un fichier
    - graph.ml contenant l'algorithme
    - gfile.ml contenant les fonctions nécessaires pour afficher le résultat
Notre répertoire est composée de 3 dossiers, le 1er dossier "algo" contient les fichiers cités plus haut, un dossier "grafs" contenant des grafs à tester et un dossier "tests" afin d'y stocker les fichiers crées par l'algo

    Comment ca marche ?

Compilation :
    - rm -f *.cmi *.cmo ftest ;
    - ocamlbuild ftest.byte ;

Il faut exécuter le fichier ftest en entrant les 3 paramètres nécessaires : le fichier que l'on va traiter, la Source et la Destination.
Il faut aussi ajouter un nom pour le fichier qui va etre généré en sortie
Exp : ./ftest.byte ../grafs/graph1 0 5 ../tests/test0906 ;


    Notre algo ?

    Pour la recherche d'une chaine améliorante nous avons décidé de faire une exploration de graph en largeur.
Nous itérons donc une file, que l'on avait nommé fileZ et à chaque itération, on retire le 1er élement de cette file pour le traiter. Cela a donc été possible à l'aide d'une récursion.
Comme nous retirons des élements de la fileZ suite au itération, il nous fallait une autre liste afin de connaitre tout les noeuds qui ont été visités, la liste "marqueZ"
Une fois que l'on a atteint la destination à l'aide du parcours en largeur, nous faisons appel à une fonction "reconstitution" afin de trouver une chemin de la destination à la source.
C'est aussi à cela que sert notre 2e liste de noeuds "marqueZ" car les noeuds visités en dernier sont ajoutés en tete de liste et donc forcément le 1er élément est la destination et le dernier est la source.
On créer une chaine contenant au depart seulement la destination, et tant que cette liste n'a pas atteint la souce, on cherche le prédecesseur du 1er élément en tete de liste de cette chaine, parmi les noeuds dans la liste marqueZ

    [TA partie ]

    Le résultat ?

    L'algorithme marche bien et s'arrete au moment où il ne trouve plus de chaine améliorante.
Cependant, ce résultat n'est pas optimale, pour l'instant, car nous cherchons un chemin juste en regardant les succésseurs pour chaque noeud.
Nous pouvons donc seulement augmenter le flot mais pas le baisser car nous n'avons toujours pas d'arcs inverses.

    En principe, notre méthode consiste à :
A chaque modification du flot d'un arc, alors, s'il n'a pas d'arc inverse, on lui en crée un et on l'initialise, s'il existe déja, alors on le met à jour.
Donc à chaque moment qu'on augment le flot d'un arc, on baisse celui de son arc inverse, de meme pour l'inverse.

    C'est pour cela que nous avons 2 versions de la fonction maj_gr, car c'est à ce moment-là qu'on met à jour le graph avec la modification de flots.
Un des soucis qui empeche l'algorithme de fonctionner est le cas des noeuds 1 et 2, car ils ont des arcs dans les 2 sens, donc par exemple si on met à jour l'arc (1,2),
alors il faudrait mettre à jour aussi son arc inverse sauf qu'il y a déja un arc dans l'autre sens (2,1) mais ce n'est pas un arc inverse que l'on a crée.

    Nous sommes en train de régler ce problème et nous espérons pouvoir le régler avant notre entretien la semaine prochaine.

    Les tests ?

    {Ta partie]

Nous nous excusons de ce léger retard.
Bonne lecture.
