% % calculate something about radiation antidamping (p61 in nic's 2010 nb)
function raddamping()

exportplot = 1;


del = -5:0.001:5;
dPdd = -2.*del./(1+del.^2).^2;

naturalGamma = 0.4384;
tauScale =1/0.03284;

tau = 1 ./ (-dPdd-naturalGamma)/tauScale;

%figure(1)
%plot(del,dPdd)


% cut off

restricted = (tau<2.5) & (tau>0);


convertcolor = @(color) hex2dec(reshape(color,2,3)')'/255;
linecolor = 'aabbff';
dotcolor = 'bb00aa';

% data

delData = [ 0.25 0.35 0.45 0.5 0.55 0.65 0.75 0.85 0.95 1   1.1];

tauData = [ 1    .27  .17  .16 .16  .16  .19  .25  .39  .53 1.95];

figure(2)
set(gcf,'Color','white')
set(gcf,'Units','Pixels','Position',[0 0 600 600])

if exportplot
    set(gcf,'Visible','Off')
end
clf
hold on

plot(del(restricted),tau(restricted),'Color',convertcolor(linecolor),'Linewidth',2)
plot(delData,tauData,'LineStyle','none','Marker','.','MarkerSize',15,'MarkerEdgeColor',convertcolor(dotcolor))

set(gca,'LineWidth',1)
set(gca,'FontSize',12)
%title('Ringup time of OMC instability vs. OMC detuning')
ylabel('Ring-up half life: \tau_1_/_2 (s)')
xlabel('Detuning: \Deltaf/\gamma')
legend('Two Parameter Fit','Measured Data','Location','Best')

if exportplot
    set(gcf,'Visible','Off')
    export_fig('raddamping.pdf','-painters')
end

end

%subplot(2,1,1)
%plot(del(restricted),tau(restricted))

%subplot(2,1,2)
%plot(delData,tauData)
% 
% figure(3)
% plot(del,tau)
% ylim([-10 10])
% xlim([0 1.2])