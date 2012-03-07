% Does nonlinear curve fitting to 
% determine the finesse and FSR of the OMC
function FSRfinessefig()

    % first load data
    load FSRfinessemeas.mat % important data are freq and trans

    

    fig = figure('visible','on');

    plot(freq,trans,'b.')

end

% Subfunctions

% this function gives theoretical transmission given some parameters
function theoreticalTrans(f,FSR,finesse,Tscale,Toffset)
    

end