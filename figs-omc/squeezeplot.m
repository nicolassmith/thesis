% make a plot showing losses vs SNR for various squeezings
function squeezeplot()

exportplot = 1;

L = 0:.01:.2;

db2fac = @(db) 10^(-db/10);

dbs = [0,3,6,9,12];
S = arrayfun(db2fac,dbs);

clear SNR
for jj = 1:length(S)
    for kk = 1:length(L)
        SNR(jj,kk) = sqrt(1 ./ ( S(jj) + L(kk) ./ ( 1 - L(kk) ) ));
    end
end

plot(L,SNR,'LineWidth',3)
if exportplot
    set(gcf,'Visible','Off')
end

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

legstring = ' db';
legend(cellfun(@(s) strcat(s,legstring),split(' ',num2str(dbs)),'UniformOutput',0))

if exportplot
    set(gcf,'Visible','Off')
    export_fig('squeezeplot.pdf','-painters')
end

end