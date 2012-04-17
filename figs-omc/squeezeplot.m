% make a plot showing losses vs SNR for various squeezings
function squeezeplot()

exportplot = 1;

L = 0:.01:.3;

db2fac = @(db) 10^(-db/10);

dbs = [12,9,6,3,0];
S = arrayfun(db2fac,dbs);

clear SNR
for jj = 1:length(S)
    for kk = 1:length(L)
        SNR(jj,kk) = sqrt(1 ./ ( S(jj) + L(kk) ./ ( 1 - L(kk) ) ));
    end
end

convertcolor = @(color) hex2dec(reshape(color,2,3)')'/255;
brightcolor = 'ffd073';

colorlist = kron(convertcolor(brightcolor),((length(S):-1:1).'/length(S))/2+.5);

figure(1)
set(gca,'ColorOrder',colorlist)
hold on
plot(L,SNR,'LineWidth',3)
if exportplot
    set(gcf,'Visible','Off')
end

xlim([min(L) max(L)])
ylim([0 round(max(max(SNR)))])

set(gca,'FontSize',14)
%set(gca,'FontWeight','bold')
%set( gca                       , ...
%    'FontName'   , 'Helvetica' );
set(gcf,'color','white')
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      )
%title('SNR compared to no squeezing vs losses')
ylabel('Scaled SNR')
xlabel('Loss Fraction')
grid on
set(gca,'LineWidth',2)

legstring = ' dB';
h = legend(cellfun(@(s) strcat(s,legstring),split(' ',num2str(dbs)), ...
               'UniformOutput',0));
v = get(h,'title');
set(v,'string','Squeezing Level');


set(gcf,'Units','Pixels','Position',[0 0 600 400])

if exportplot
    set(gcf,'Visible','Off')
    export_fig('squeezeplot.pdf','-painters')
end

end