thesis : main.tex
	latex main.tex


clean : 
	-rm -f *.log *.orig *.rej *.aux *.dvi *.pdf *~ *.blg *.lof *.lot *.bbl *.toc
	-rm -rf _region_.*
	-rm -rf auto
