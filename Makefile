chapters = gw modalmodel
main = main
auxiliary = cover contents biblio

pdf : $(main).pdf

$(main).dvi : $(main).tex $(addsuffix .tex,$(auxiliary)) 
	latex $<
	-bibtex $(main)
	latex $<
	latex $<

%.pdf : %.dvi
	dvipdf $<

ch-%.dvi: ch-%.tex
	latex --jobname=temp "\includeonly{ch-$*}\input{$(main)}"
	mv temp.dvi ch-$*.dvi

.PHONY: view clean pdf

view : $(main).pdf
	okular $<

view-% : ch-%.pdf
	okular $<

clean : 
	-rm -f *.log *.orig *.rej *.aux *.dvi *.pdf *~ *.blg *.lof *.lot *.bbl *.toc .*~
	-rm -rf _region_.*
	-rm -rf auto
