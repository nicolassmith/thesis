function sensimprovement()

%possibly helpful times: 
% fixed post:919486633
% hang TT0:920085981
% 8W after thin:11/06/2009 09:08:22UTC
% 12.6W after thin:11/06/2009 07:56:43UTC
% keita after blades:19/09/2009 12:25:36UTC


exportplot = 1;
grabdata = 0;

tafterblades = 937398351;
duration = 300;

% data acq
mDV;

channels = {'H1:LSC-DARM_ERR'};

if grabdata
    afterbladedata = get_data(channels,'raw',tafterblades,duration);
    save('sensimprovement.mat','afterbladedata');
else 
    load sensimprovement.mat
end

TT0swapraw = load('beforeafterTT0change.txt');
thinraw = load('20090611specs-8W.txt');

 %calibration from
 %http://blue.ligo-wa.caltech.edu/users/nicolas/afterseptvent.xml
DARMcalraw = load('darmcal-aug2009.txt');

% crunch data here

log2bins = 15;
binres = afterbladedata(1).rate/(2^log2bins);
blades = asd(afterbladedata(1).data,afterbladedata(1).rate,binres);

% interpolate the DARM calibration to the f points of our data
bladeDARMcal = interp1(DARMcalraw(:,1),10.^(DARMcalraw(:,2)/20),blades.f);

fixedpost.f = TT0swapraw(:,1);
fixedpost.x = TT0swapraw(:,2);

TT0hang.f = TT0swapraw(:,1);
TT0hang.x = TT0swapraw(:,3);

thinwires.f = thinraw(:,1);
thinwires.x = thinraw(:,2);

bladescal.f = blades.f;
bladescal.x = bladeDARMcal.*blades.x;

% plot here

fixedpost.color = '34495b';
TT0hang.color = '009999';
thinwires.color = 'ffad00';
bladescal.color = 'a5d327';
% fixedpost.color = '718b0d';
% TT0hang.color = '1a8981';
% thinwires.color = 'dfaa2a';
% bladescal.color = 'b2d628';

fixedpost.legend = 'Fixed Post';
TT0hang.legend = 'Suspended TT0';
thinwires.legend = 'Thin Wires';
bladescal.legend = 'Blade Springs';

linewid = 1;
convertcolor = @(color) hex2dec(reshape(color,2,3)')'/255;

f_ = figure(11);
set(f_,'Color','White')
set(f_,'Units','Pixels','Position',[0 0 600 300])

if exportplot
    set(gcf,'Visible','Off')
end

legcell = {};
for data = [fixedpost TT0hang thinwires bladescal]
        loglog(data.f,data.x,'Color',convertcolor(data.color),'LineWidth',linewid)
        legcell = [legcell,{data.legend}]; %#ok<AGROW>
        hold on
end

[legh,objh] = legend(legcell,'Location','Best');
set(objh,'linewidth',2);

xlim([50 1400]);
ylim([.7e-19 1e-16])

ylabel('Displacement Sensitivity (m/\surdHz)')
xlabel('Frequency (Hz)')

grid on
set(gca,'LineWidth',1)
set(gca,'FontSize',12)

if exportplot
    set(gcf,'Visible','Off')
    export_fig('sensimprovement.pdf','-painters')
end

end
