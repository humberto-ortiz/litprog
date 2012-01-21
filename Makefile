all: cweb-hello.pdf noweb-hello.pdf

cweb-hello.pdf: cweb-hello.tex
	pdftex $<

cweb-hello.tex: cweb-hello.w
	cweave $<

noweb-hello.pdf: noweb-hello.tex
	pdflatex $<

noweb-hello.tex: noweb-hello.nw
	noweave $< > $@
