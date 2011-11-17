chapters = gw modalmodel
main = main
auxiliary = cover contents
bib = mainb
viewer = evince

bibdep = biblio.tex $(bib).bib
maindeps = $(main).tex macros.tex $(bibdep)
texchapters = $(addsuffix .tex,$(addprefix ch-,$(chapters)))
maininclude = $(addsuffix .tex,$(auxiliary)) $(texchapters)

pdf : $(main).pdf

$(main).pdf : $(maindeps) $(maininclude)
	pdflatex $<
	-bibtex $(main)
	pdflatex $<
	pdflatex $<

# temp is needed because latex goes into some .aux infinite loop without it
ch-%.pdf : ch-%.tex $(maindeps)
	-rm -f *.aux
	pdflatex --jobname=ch-$*-temp "\includeonly{ch-$*}\input{$(main)}"
	-bibtex ch-$*-temp
	pdflatex --jobname=ch-$*-temp "\includeonly{ch-$*}\input{$(main)}"
	pdflatex --jobname=ch-$*-temp "\includeonly{ch-$*}\input{$(main)}"
	mv ch-$*-temp.pdf ch-$*.pdf

.PHONY : view clean pdf
.SECONDARY : 

view : $(main).pdf
	$(viewer) $< 2> /dev/null &

view-% : ch-%.pdf
	$(viewer) $< 2> /dev/null &

clean : 
	-rm -f *.log *.orig *.rej *.aux *.dvi *.pdf *~ *.blg *.lof *.lot *.bbl *.toc .*~ *.out
	-rm -rf _region_.*
	-rm -rf auto
