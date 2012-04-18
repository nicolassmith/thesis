% make a plot of fabry perot shot noise
function fpmishotnoise()

exportplot = 1;

f = logspace(-5,-2,100);

Finesse = [1000 500 200 100];

for jj = 1:length(Finesse)
    for kk = 1:length(f)
        shotnoise(jj,kk) = pi/(2*Finesse(jj)) * sqrt(1+(4*Finesse(jj)*f(kk))^2);
    end
end

convertcolor = @(color) hex2dec(reshape(color,2,3)')'/255;
brightcolor = 'c861d3';

colorlist = kron(convertcolor(brightcolor),((1:length(Finesse)).'/length(Finesse))/2+.5);


figure(1)

if exportplot
    set(gcf,'Visible','Off')
end

hold on
set(gca,'ColorOrder',colorlist)
h = loglog(f,shotnoise,'LineWidth',3);
set(gca,'XScale','log')
set(gca,'YScale','log')

ylabel('Shoit Noise ASD compared to Michelson')
xlabel('f/FSR')

set(gca,'FontSize',12)
set(gcf,'color','white')


set(gcf,'Units','Pixels','Position',[0 0 600 300])

legstring = '';
legh = legend(h(length(h):-1:1),cellfun(@(s) strcat(s,legstring),split(' ',num2str(Finesse(length(Finesse):-1:1))), ...
               'UniformOutput',0),'Location','Best');
v = get(legh,'title');
set(v,'string','Finesse');


if exportplot
    set(gcf,'Visible','Off')
    export_fig('fpmishotnoise.pdf','-painters')
end

end
