main-chapters = intro modalmodel omc beacon modematching jitter
ap-chapters = ap-miscon ap-matrices ap-notes
main = main
auxiliary = cover contents
bib = mainb
viewer = evince
figdirs = figs-omc

chapters = $(main-chapters) $(ap-chapters)
bibdep = biblio.tex $(bib).bib
maindeps = $(main).tex macros.tex $(bibdep) chfigs
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
#	pdflatex $(main).tex
	pdflatex --jobname=ch-$*-temp "\includeonly{ch-$*}\input{$(main)}"
	pdflatex --jobname=ch-$*-temp "\includeonly{ch-$*}\input{$(main)}"
	mv ch-$*-temp.pdf ch-$*.pdf

chfigs : 
	for dir in $(figdirs) ; do \
		cd $$dir ; \
		make ; \
		cd .. ; \
	done

.PHONY : view clean pdf chfigs reallyclean thisclean reallyclean-recursive clean-recursive
.SECONDARY : 

view : $(main).pdf
	$(viewer) $< 2> /dev/null &

view-% : ch-%.pdf
	$(viewer) $< 2> /dev/null &

reallyclean : reallyclean-recursive thisclean

clean : clean-recursive thisclean

clean-recursive : 
	for dir in $(figdirs) ; do \
		cd $$dir ; \
		make clean; \
		cd .. ; \
	done

reallyclean-recursive : 
	for dir in $(figdirs) ; do \
		cd $$dir ; \
		make reallyclean; \
		cd .. ; \
	done

thisclean : 
	-rm -f *.log *.orig *.rej *.aux *.dvi *.pdf *~ *.blg *.lof *.lot *.bbl *.toc .*~ *.out
	-rm -rf _region_.*
	-rm -rf auto
