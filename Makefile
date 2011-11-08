chapters = gw modalmodel
main = main
auxiliary = cover contents biblio
viewer = evince
ch-temp = ch-temp

pdf : clean $(main).pdf

$(main).dvi : $(main).tex $(addsuffix .tex,$(auxiliary)) $(addsuffix .tex,$(addprefix ch-,$(chapters))) 
	latex $<
	-bibtex $(main)
	latex $<
	latex $<

%.pdf : %.dvi
	dvipdf $<

ch-%.dvi: ch-%.tex clean-ch clean
	latex --jobname=$(ch-temp) "\includeonly{ch-$*}\input{$(main)}"
	latex --jobname=$(ch-temp) "\includeonly{ch-$*}\input{$(main)}"
	mv $(ch-temp).dvi ch-$*.dvi

.PHONY: view clean pdf clean-ch
.SECONDARY: 

view : $(main).pdf
	$(viewer) $< &

view-% : ch-%.pdf
	$(viewer) $< &

clean : 
	-rm -f *.log *.orig *.rej *.aux *.dvi *.pdf *~ *.blg *.lof *.lot *.bbl *.toc .*~
	-rm -rf _region_.*
	-rm -rf auto

clean-ch :
	-rm ch-*.aux $(ch-temp).aux $(ch-temp).log
