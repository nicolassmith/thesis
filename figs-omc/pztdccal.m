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

peakcolor = ['b0'; '00'; '47'];
rampcolor = ['58'; '5b'; '72'];

hold on
plot(time,ramp,'LineWidth',2,'Color',hex2dec(rampcolor)'/255)
plot(time,trans*tscale+toff,'LineWidth',1,'Color',hex2dec(peakcolor)'/255)
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