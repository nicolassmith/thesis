function FSRfitFig()
% Function to make OMC FSR plot for my thesis
% nicolas smith

% get the data ready
load FSRfinessemeas.mat
fReal = 2*freq;

% This function was automatically generated on 08-Mar-2012 15:12:32
% and subsequently modified.

% Set up figure to receive datasets and fits
f_ = figure();
set(f_,'Units','Pixels','Position',[0 0 650 400],'Visible','Off','Color','white');
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1],'LineWidth',2);
set(ax_,'Box','on');
grid on
set(ax_,'Ytick',[]);
axes(ax_); hold on;


% --- Plot data 
h_ = line(fReal,trans,'Parent',ax_,'Color',[0.333333 0 0.666667],...
    'LineStyle','none', 'LineWidth',1,...
    'Marker','.', 'MarkerSize',7);
xlim_(1) = min(xlim_(1),min(fReal));
xlim_(2) = max(xlim_(2),max(fReal));
legh_(end+1) = h_;
legt_{end+1} = 'Measured Data';

% Nudge axis limits beyond data limits
xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
set(ax_,'XLim',xlim_)

% --- Create fit 
fo_ = fitoptions('method','NonlinearLeastSquares','Robust','Bisquare','Algorithm','Levenberg-Marquardt','MaxFunEvals',10000,'MaxIter',10000,'TolFun',1.0000000000000000209e-08,'TolX',1.0000000000000000209e-08);
ok_ = isfinite(fReal) & isfinite(trans);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
st_ = [0.02 0.05 370.0 278.0]; % fit starting point
set(fo_,'Startpoint',st_);
ft_ = fittype('offset+gain/(1+4/pi^2*F^2*sin(f/FSR*pi)^2)',...
    'dependent',{'y'},'independent',{'f'},...
    'coefficients',{'gain', 'offset', 'F', 'FSR'});

% Fit this model using new data
disp('fitting curve...')
cf_ = fit(fReal(ok_),trans(ok_),ft_,fo_);
disp('done')
disp(cf_)
cf_.FSR
confint(cf_)

% Plot this fit
h_ = plot(cf_,'fit',0.95);
set(f_,'Visible','Off');
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'Curve Fit';

% Done plotting data and fits.  Now finish up loose ends.
hold off;
leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'};
h_ = legend(ax_,legh_,legt_,leginfo_{:});  % create legend
set(h_,'Interpreter','none');
xlabel(ax_,'Frequency Offset (MHz)');               
ylabel(ax_,'Transmission');

export_fig('FSRfit.pdf','-painters')
