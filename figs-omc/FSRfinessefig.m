% Does nonlinear curve fitting to 
% determine the finesse and FSR of the OMC
function FSRfinessefig()

    % first load data
    load FSRfinessemeas.mat % important data are freq and trans
    
    fReal = 2*freq; % AOM double pass

    % do curve fitting
    error = @(FSR,finesse,Tscale,Toffset)ferror(trans,fReal,FSR,finesse,Tscale,Toffset);
    
    % start guess
          % FSR finesse Tscale Toffset
    x0 = [ 278 370 .03 .055 ]; 

    x = fminsearch(@(y)error(y(1),y(2),y(3),y(4)),x0);
    
    xx = x;
    fPlot = linspace(274,282,100);
    transFit = theoreticalTrans(fPlot,xx(1),xx(2),xx(3),xx(4));
    
    disp(['finesse ' num2str(x(2))]);
    
    fig = figure('visible','on');

    plot(fReal,trans,'b.',fPlot,transFit,'r')

end

% Subfunctions

% this function gives theoretical transmission given some parameters
function out = theoreticalTrans(f,FSR,finesse,Tscale,Toffset)
    
    base = zeros(size(f));
    
    for j = 1:length(f)
        base(j) = 1 / ( 1 + 4/pi^2 * finesse^2 * sin(f(j)/FSR*pi)^2 );
    end
    
    out = base*Tscale+Toffset;
end

% argument for fminsearch for curve fitting.
function out = ferror(trans,f,FSR,finesse,Tscale,Toffset)

    % make a subset of f for fitting
    %fmin = 277;
    %fmax = 279;

    %ind = find(f>fmin&f<fmax);
    out = sum((trans(ind)-theoreticalTrans(f(ind),FSR,finesse,Tscale,Toffset)).^2);
end