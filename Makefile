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

$(main).dvi : $(maindeps) $(maininclude)
	latex $<
	-bibtex $(main)
	latex $<
	latex $<

%.pdf : %.dvi
	dvipdf $<

# temp is needed because latex goes into some .aux infinite loop without it
ch-%.dvi : ch-%.tex $(maindeps)
	-rm -f *.aux
	latex --jobname=ch-$*-temp "\includeonly{ch-$*}\input{$(main)}"
	-bibtex ch-$*-temp
	latex --jobname=ch-$*-temp "\includeonly{ch-$*}\input{$(main)}"
	latex --jobname=ch-$*-temp "\includeonly{ch-$*}\input{$(main)}"
	mv ch-$*-temp.dvi ch-$*.dvi

.PHONY : view clean pdf
.SECONDARY : 

view : $(main).pdf
	$(viewer) $< 2> /dev/null &

view-% : ch-%.pdf
	$(viewer) $< 2> /dev/null &

clean : 
	-rm -f *.log *.orig *.rej *.aux *.dvi *.pdf *~ *.blg *.lof *.lot *.bbl *.toc .*~
	-rm -rf _region_.*
	-rm -rf auto
