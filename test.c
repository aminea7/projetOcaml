
rm -f *.cmi *.cmo ftest ;
ocamlbuild ftest.native ;
./ftest.native graph1 1 2 name ;
