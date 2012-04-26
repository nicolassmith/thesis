main-chapters = gws ifo modalmodel omc beacon modematching jitter conclusion
ap-chapters = ap-miscon ap-matrices ap-notes ap-gloss
main = main
auxiliary = cover contents
bib = mainb
viewer = okular
pdfname = nicolas-thesis-draft.pdf
server = nsmith@ligo.mit.edu:~/public_html/$(pdfname)

chapters = $(main-chapters) $(ap-chapters)
bibdep = biblio.tex $(bib).bib
maindeps = $(main).tex macros.tex $(bibdep) massring.touch
texchapters = $(addsuffix .tex,$(addprefix ch-,$(chapters)))
maininclude = $(addsuffix .tex,$(auxiliary)) $(texchapters) abstract.tex

# default rule
$(pdfname) : $(main).pdf
	cp $< $@

# chapter figs section
figs-modalmodel = $(addprefix figs-modalmodel/,QPD.pdf omcmodal.pdf)
ch-modalmodel.pdf : $(figs-modalmodel)

matfigs-omc = $(addprefix figs-omc/,pzttf.pdf finesseFit.pdf pztdccal.pdf raddamping.pdf squeezeplot.pdf)
figs-omc = $(addprefix figs-omc/,construction.pdf interrogator.pdf omcphoto.pdf inputcouplerphoto.pdf ttphoto.pdf susphoto.pdf omclocation.pdf)
ch-omc.pdf : $(matfigs-omc) $(figs-omc)

figs-beacon = $(addprefix figs-beacon/,blockdiagtight.pdf ditherarrows.pdf shotSNRtightedited.pdf)
ch-beacon.pdf : $(figs-beacon)

figs-ifo = $(addprefix figs-ifo/,resonantcav.pdf michelson.pdf prfpmi.pdf)
ch-ifo.pdf : $(figs-ifo)

matfigs-jitter = $(addprefix figs-jitter/,hamtransmission.pdf bilinearplot.pdf magffperformance.pdf sensimprovement.pdf)
figs-jitter = $(addprefix figs-jitter/,ham6layout.pdf ttdiag.pdf magffblockdiag.pdf TTbounceTF.pdf TT0photos.pdf)
ch-jitter.pdf : $(matfigs-jitter) $(figs-jitter)

figs-modematching = $(addprefix figs-modematching/,blockdiag.pdf)
ch-modematching.pdf : $(figs-modematching)

matfigs-ap-miscon = $(addprefix figs-ap-miscon/,fpmishotnoise.pdf)
ch-ap-miscon.pdf : $(matfigs-ap-miscon)

figs-ap-notes =  $(addprefix figs-ap-notes/,mrfig1.pdf mrfig2.pdf)
ch-ap-notes.pdf : $(figs-ap-notes)

figs = $(figs-modalmodel) $(figs-beacon) $(figs-omc) $(figs-ifo) $(figs-jitter) $(figs-modematching) $(figs-ap-notes)
matfigs = $(matfigs-omc) $(matfigs-jitter) $(matfigs-ap-miscon)

# fig rules
%.pdf : %.svg
	inkscape --export-area-page --export-dpi=300 --export-pdf=$@ $<
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
	makeindex $(main).nlo -s nomencl.ist -o $(main).nls
	pdflatex $<
	makeindex $(main).nlo -s nomencl.ist -o $(main).nls
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

# mass rings rules
massring.touch : massring/makerings.py
	cd massring; rm -f *.pdf; ./makerings.py
	touch massring.touch


.PHONY : view clean pdf reallyclean upload
.SECONDARY : 

upload : $(main).pdf
	scp $< $(server)

view : $(main).pdf
	$(viewer) $< 2> /dev/null &

view-% : ch-%.pdf
	$(viewer) $< 2> /dev/null &

clean : 
	-rm -f *.log *.orig *.rej *.aux *.dvi *.pdf *~ *.blg *.lof *.lot *.bbl *.toc .*~ *.out *.nlo *.nls *.ilg
	-rm -rf _region_.*
	-rm -rf auto
	-rm -rf $(figs)
	-rm -f massring/*.pdf
	-rm -f massring.touch

reallyclean : clean
	-rm -rf $(matfigs)
