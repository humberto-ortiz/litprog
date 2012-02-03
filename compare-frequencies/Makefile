all: make-hash make-hash.pdf

make-hash.pdf: make-hash.w
	cweave make-hash.w
	pdftex make-hash.tex

make-hash: make-hash.w
	ctangle make-hash.w
	g++ -o $@ make-hash.cpp

clean:
	rm -f make-hash make-hash.pdf

distclean: clean
	rm -f *.cpp *.cxx
	rm -f make-hash.idx make-hash.log make-hash.scn make-hash.tex \
	make-hash.toc
