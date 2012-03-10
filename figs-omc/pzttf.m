function pzttf()

load pzttf.mat % data is time, trans, and ramp

save = 1;

f_ = figure();
set(f_,'Units','Pixels','Position',[0 0 650 700],'Color','white');
if save
    set(f_,'Visible','Off')
end
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1],'LineWidth',2);
set(ax_,'Box','on');
grid on
axes(ax_); hold on;


hold on
SRSbode(pzt004)

if save
    set(f_,'Visible','Off')
end
axis tight

if save
    export_fig('pzttf.pdf','-painters')
end
end