% takes jeff's fig, makes some modifications, and saves the result to pdf

function hamtransmission()

save = 1;

open 100324_1720UTC_L1HAM6ISI_GroundTransmission_Meas-upto100Hz_vs_Model-upto800Hz_Z.fig

if save
    set(gcf,'Visible','Off')
end

f_ = gcf;

set(f_,'Units','Pixels','Position',[0 0 600 600])

set(f_,'Color','White')

set(gca,'MinorGridLineStyle','none') %remove minor grid lines
set(gca,'LineWidth',2)

ymin = 1e-10;
xmax = 1e3;

xlim([5e-3 xmax])
ylim([ymin 1e2])

hh = get(gca,'Children');
set(hh(1),'Position',[xmax ymin 0]);

fontSize = 12;

set(gca,'FontSize',fontSize)
set(get(gca,'XLabel'),'FontSize',fontSize)
set(get(gca,'YLabel'),'FontSize',fontSize)

title('')

legend('Measurement Coherence','Measured HAM ISI Transmission',...
    'Modeled HAM ISI Transmission',...
    'Modeled Passive HAM Stack Transmission','Location','SW')

orient portrait

if save
    set(gcf,'Visible','Off')
    export_fig('hamtransmission.pdf','-painters')
end

end