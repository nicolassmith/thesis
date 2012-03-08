function FSRfitFig()
%CREATEFIT    Create plot of datasets and fits
%   CREATEFIT(FREQ,TRANS)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  2
load FSRfinessemeas.mat

% Data from dataset "trans vs. freq":
%    X = freq:
%    Y = trans:
%    Unweighted
%
% This function was automatically generated on 08-Mar-2012 15:12:32

% Set up figure to receive datasets and fits
f_ = figure('visible','on');
set(f_,'Units','Pixels','Position',[622 272 674 479]);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_); hold on;


% --- Plot data originally in dataset "trans vs. freq"
freq = freq(:);
trans = trans(:);
h_ = line(freq,trans,'Parent',ax_,'Color',[0.333333 0 0.666667],...
    'LineStyle','none', 'LineWidth',1,...
    'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(freq));
xlim_(2) = max(xlim_(2),max(freq));
legh_(end+1) = h_;
legt_{end+1} = 'Measured Data';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
    xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
    set(ax_,'XLim',xlim_)
else
    set(ax_, 'XLim',[136.75779999999997472, 141.06219999999999004]);
end


% --- Create fit "fit 5"
fo_ = fitoptions('method','NonlinearLeastSquares','Robust','Bisquare','Algorithm','Levenberg-Marquardt','MaxFunEvals',10000,'MaxIter',10000,'TolFun',1.0000000000000000209e-08,'TolX',1.0000000000000000209e-08);
ok_ = isfinite(freq) & isfinite(trans);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
st_ = [0.02 0.05 2.5 139.0];
set(fo_,'Startpoint',st_);
ft_ = fittype('b+a/(1+(2*q)^2*(x-x0)^2)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a', 'b', 'q', 'x0'});

% Fit this model using new data
disp('fitting curve...')
cf_ = fit(freq(ok_),trans(ok_),ft_,fo_);
disp('done')
disp(cf_)

% Plot this fit
h_ = plot(cf_,'fit',0.95);
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
xlabel(ax_,'');               % remove x label
ylabel(ax_,'');               % remove y label
