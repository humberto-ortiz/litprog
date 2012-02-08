# Makefile for noweb.
# Humberto Ortiz Zuazaga 1995/03/01.

# Variables
NOWEAVE = noweave
NOTANGLE = notangle
CC = gcc
LATEX = pdflatex

# Rules
.SUFFIXES: .c .nw .tex .pdf

.nw.c:
	$(NOTANGLE) -L $*.nw > $*.c
.nw.tex:
	$(NOWEAVE) -delay $*.nw > $*.tex
.tex.pdf:
	$(LATEX) '\scrollmode \input '"$*.tex"
	while grep -s 'Rerun to get cross-references right' $*.log; do \
	      $(LATEX) '\scrollmode \input '"$*.tex" ; \
	done

# What to build
all: regex regex.pdf
