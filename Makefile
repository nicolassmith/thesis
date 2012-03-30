main-chapters = gws ifo modalmodel omc beacon modematching jitter
ap-chapters = ap-miscon ap-matrices ap-notes
main = main
auxiliary = cover contents
bib = mainb
viewer = okular

chapters = $(main-chapters) $(ap-chapters)
bibdep = biblio.tex $(bib).bib
maindeps = $(main).tex macros.tex $(bibdep)
texchapters = $(addsuffix .tex,$(addprefix ch-,$(chapters)))
maininclude = $(addsuffix .tex,$(auxiliary)) $(texchapters)

# default rule
pdf : $(main).pdf

# chapter figs section
figs-modalmodel = $(addprefix figs-modalmodel/,QPD.pdf omcmodal.pdf)
ch-modalmodel.pdf : $(figs-modalmodel)

matfigs-omc = $(addprefix figs-omc/,pzttf.pdf finesseFit.pdf pztdccal.pdf)
figs-omc = $(addprefix figs-omc/,construction.pdf interrogator.pdf)
ch-omc.pdf : $(matfigs-omc) $(figs-omc)

figs-beacon = $(addprefix figs-beacon/,blockdiagtight.pdf ditherarrows.pdf shotSNRtightedited.pdf)
ch-beacon.pdf : $(figs-beacon)

figs-ifo = $(addprefix figs-ifo/,resonantcav.pdf michelson.pdf prfpmi.pdf)
ch-ifo.pdf : $(figs-ifo)

figs = $(figs-modalmodel) $(figs-beacon) $(figs-omc) $(figs-ifo)
matfigs = $(matfigs-omc)

# fig rules
%.pdf : %.svg
	inkscape --export-area-page --export-pdf=$@ $<
#	convert -density 10000 $< -resize 10000% $@

MATLAB = matlab -nodesktop -nosplash

%.pdf : %.m
	$(MATLAB) -r "run $<; quit;"

%.pdf : %.eps
	convert $< $@

# main rules
$(main).pdf : $(maindeps) $(maininclude) $(figs) $(matfigs)
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

.PHONY : view clean pdf reallyclean
.SECONDARY : 

view : $(main).pdf
	$(viewer) $< 2> /dev/null &

view-% : ch-%.pdf
	$(viewer) $< 2> /dev/null &

clean : 
	-rm -f *.log *.orig *.rej *.aux *.dvi *.pdf *~ *.blg *.lof *.lot *.bbl *.toc .*~ *.out
	-rm -rf _region_.*
	-rm -rf auto
	-rm -rf $(figs)

reallyclean : clean
	-rm -rf $(matfigs)
