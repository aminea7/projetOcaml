Auteurs du projet : Amine Lakhal 4IR B1 - Khalil Jamai 4IR B2


    Composition de notre projet ?

Le dossier build contient les fichiers .ml et .mli nécessaire à l'execution de l'algorithme.
Nous avons gardé les memes fichiers car cette disposition nous paraissait très claire et efficace :
    - FordFulkerson.ml qui fait appel à l'algorithme puis affiche le résultat dans un fichier
    - graph.ml contenant l'algorithme
    - gfile.ml contenant les fonctions nécessaires pour afficher le résultat
Notre répertoire est composée de 3 dossiers, le 1er dossier "algo" contient les fichiers cités plus haut, un dossier "grafs" contenant des grafs à tester et un dossier "tests" afin d'y stocker les fichiers crées par l'algo

    Comment ca marche ?

Compilation :
    - rm -f *.cmi *.cmo algo/FordFulkerson ;
    - ocamlbuild algo/FordFulkerson.native ;   Depuis le dossier Ocamlprojet

Il faut exécuter le fichier FordFulkerson en entrant les 3 paramètres nécessaires : le fichier que l'on va traiter, la Source et la Destination.
Il faut aussi ajouter un nom pour le fichier qui va etre généré en sortie
Exp : compilation depuis le dossier Ocamlprojet : ./FordFulkerson.native grafs/graph1 0 5 results/test ;

Convertir en png : dot -Tpng results/test > results/test


    Notre algo ?

    Pour la recherche d'une chaine améliorante nous avons décidé de faire une exploration de graph en largeur.
Nous itérons donc une file, que l'on avait nommé fileZ et à chaque itération, on retire le 1er élement de cette file pour le traiter. Cela a donc été possible à l'aide d'une récursion.
Comme nous retirons des élements de la fileZ suite au itération, il nous fallait une autre liste afin de connaitre tout les noeuds qui ont été visités, la liste "marqueZ"
Une fois que l'on a atteint la destination à l'aide du parcours en largeur, nous faisons appel à une fonction "reconstitution" afin de trouver une chemin de la destination à la source.
C'est aussi à cela que sert notre 2e liste de noeuds "marqueZ" car les noeuds visités en dernier sont ajoutés en tete de liste et donc forcément le 1er élément est la destination et le dernier est la source.
On crée une chaine contenant au depart seulement la destination, et tant que cette liste n'a pas atteint la souce, on cherche le prédecesseur du 1er élément en tete de liste de cette chaine, parmi les noeuds dans la liste marqueZ.

    Ensuite, on prend la chaine améliorante et on itière sur cette liste en récupérant le flot qu'on peut augmenter ou diminuer sur chaque arc et on stocke ces valeurs dans une liste pour pouvoir récupérer le minimum.
Une fois que l'on a cette valeur, on crée des fonctions qui permettent d'itérer sur le graphe et de modifier les flots et on les utilise dans une fonction qui permet de mettre le graph à jour.
Cette dernière fonction itère sur la chaine améliorante en regardant pour chaque element si l'element suivant est son successeur ou son prédecesseur d'après le graph initial.
Ainsi on sait si on doit augmenter le flot (pour les successeurs) ou diminuer le flot (pour les prédecesseurs).
La condition d'arret est l'obtention d'un chemin vide de la part de la fonction iter_file, car elle n'aurait pas atteint la destination, ou bien s'il n'y a pas de chemin avec des flots exploitables.

    Par ailleurs, afin de pouvoir gérer les arcs inverses (ou graphe d'écart), à chaque fois que l'on modifie un arc, on regarde si on lui a déja crée un arc inverse, si ce n'est pas on le crée.
Ensuite, après avoir mis un arc donné, on met aussi à jour son arc inverse. Si on augmente le flot d'un arc, on diminue son arc inverse et vice versa.
Ceci s'applique pour tout les arcs qui n'ont pas déja un arc dans l'autre sens, dans ce cas là on ne modifie pas son arc inverse.

    Ainsi, pendant l'algo nous avons besoin du graph actuel que nous modifions et du graph inital, car quand nous faison des modifications de flots, nous avons besoin de voir qui est successeur et qui est prédecesseur selon le graph d'origine,
et non pas selon le graph actuel car c'est une recherche de succésseurs seulement pour atteindre la destination, et une recherche seulement de prédecesseurs pour reconstituer le chemin jusqu'à la source.

   Enfin, on crée une fonction finale "algo" qui prend en paramètre le graph, la source et la destination et qui fait une recherche d'une chaine améliorante à chaque boucle
 puis met à jour le graphe et elle s'arrête quand il n'y a plus de chaine améliorante.

 Après avoir atteint ce graph avec les flots finals, il nous faut enlever tout les arcs que l'on a crée nous memes car ils nous en seulement permit de diminuer des flots d'arcs par moment.
 Pour cela, nous faisons appel à la fonction maj_remove qui va itérer le graph initial et remplacer chacun de ses arcs par le meme arc présent dans le graph final pour récupérer le bon flot.
 C'est une fonction derivée de map.

    Le résultat ?

L'algorithme marche bien et s'arrete au moment où il ne trouve plus de chaine améliorante. Il utilise aussi la diminution d'arcs à travers l'usage d'arcs inverses.

    Les tests ?

    Pour tester notre algorithme nous avons utilisé le graph proposé au début des séances de projet.
Nous avons donc utiliser la fonction write_file (du fichier gfile) dans le fichier FordFulkerson ensuite nous avons affiché graphiquement le graph final grâce à la fonction export qui permet de générer un fichier en dot format.
Nous avons aussi crée des graphs similaires de meme taille quasiment.
Et enfin, nous avons crée une 2e version pour gérer pour addapter notre algorithme à des cas où l'on a plusieurs sources et plusieurs destinations.
Cette version n'est pas encore optimale mais le raisonnement  a l'air bon. C'est le fichier algo/FordFulkersonMulti qu'il faut exécuter. (graf4 est un graf avec 4 sources et 4 destinations).

Nous nous excusons de ce léger retard.
Bonne lecture.
