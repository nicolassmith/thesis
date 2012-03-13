
MATLAB = matlab -nodesktop -nosplash
matlabplots =
inkscapeplots = QPD.pdf omcmodal.pdf

all : matlab $(inkscapeplots)

matlab : $(matlabplots)

QPD.pdf : QPD.svg
	inkscape --export-area-page --export-pdf=$@ $<

omcmodal.pdf : omcmodal.svg
	inkscape --export-area-page --export-pdf=$@ $<

#pzttf.pdf : pzttf.m
#	-$(MATLAB) -r "try; $(basename $<); catch; end; quit;"

.PHONY : all matlab clean matlab-clean reallyclean
.SECONDARY : 

clean :
	-rm -rf *~
	-rm -rf $(inkscapeplots)

matlab-clean :
	-rm -rf rf $(matlabplots)

reallyclean : clean matlab-clean