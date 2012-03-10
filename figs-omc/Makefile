
MATLAB = matlab -nodesktop -nosplash
matlabplots = FSRfit.pdf pztdccal.pdf pzttf.pdf

all : matlab

matlab : $(matlabplots)

FSRfit.pdf : FSRfitFig.m
	-$(MATLAB) -r "try; $(basename $<); catch; end; quit;"

pztdccal.pdf : pztdccal.m
	-$(MATLAB) -r "try; $(basename $<); catch; end; quit;"

pzttf.pdf : pzttf.m
	-$(MATLAB) -r "try; $(basename $<); catch; end; quit;"

.PHONY : all matlab clean matlab-clean reallyclean
.SECONDARY : 

clean :
	-rm -rf *~

matlab-clean :
	-rm -rf rf $(matlabplots)

reallyclean : clean matlab-clean