function pztdccal()

load pztdccal.mat % data is time, trans, and ramp

save = 1;

f_ = figure();
set(f_,'Units','Pixels','Position',[0 0 650 400],'Color','white');
if save
    set(f_,'Visible','Off')
end
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1],'LineWidth',2);
set(ax_,'Box','on');
grid on
axes(ax_); hold on;

tscale = 500;
toff = 50;

hold on
plot(time,ramp,'b','LineWidth',1)
plot(time,trans*tscale+toff,'r','LineWidth',1)
if save
    set(f_,'Visible','Off')
end
axis tight
ylabel('PZT Voltage (V)')
xlabel('Time (s)')
legend('PZT ramp','OMC transmission')

if save
    export_fig('pztdccal.pdf','-painters')
end
end