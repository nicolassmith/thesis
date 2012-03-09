
MATLAB = matlab -nodesktop -nosplash
matlabplots = FSRfit.pdf

all : matlab

matlab : $(matlabplots)

FSRfit.pdf : FSRfitFig.m
	$(MATLAB) -r "FSRfitFig; quit;"

.PHONY : all matlab clean matlab-clean reallyclean
.SECONDARY : 

clean :
	-rm -rf *~

matlab-clean :
	-rm -rf rf $(matlabplots)

reallyclean : clean matlab-clean