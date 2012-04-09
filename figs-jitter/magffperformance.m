% matlab
function magffperformance()

exportplot = 1;
grabdata = 0;

duration = 700;

GPSffoff = 931902844.0;
GPSffon = 931901487.041503906; %these are swapped, but data got saved as such

omctrans = {'H1:OMC-PD_TRANS1_OUT_DAQ'};

omcalignchannels = {'H1:OMC-QPD3_P_OUT_DAQ','H1:OMC-QPD3_Y_OUT_DAQ',...
		    'H1:OMC-QPD4_P_OUT_DAQ','H1:OMC-QPD4_Y_OUT_DAQ'};

allchannels = [omctrans omcalignchannels];

mDV
if grabdata
    ffondata = get_data(allchannels,'raw',GPSffon,duration);
    ffoffdata = get_data(allchannels,'raw',GPSffoff,duration);
    save('magffdata.mat','ffondata','ffoffdata');
else 
    load magffdata.mat
end

%swap back
ffondatatemp = ffoffdata;
ffoffdata = ffondata;
ffondata = ffondatatemp;

% crunch data and make figure here

log2bins = 20;

% trans data
binres = ffondata(1).rate/(2^log2bins);
transOnASD = asd(ffondata(1).data/mean(ffondata(1).data),ffondata(1).rate,binres);
transOffASD = asd(ffoffdata(1).data/mean(ffoffdata(1).data),ffoffdata(1).rate,binres);

jj=0;
for qpdchan = [2 3 4 5];
    jj = jj+1;
    qpdOnData(jj) = ffondata(qpdchan);  %#ok<AGROW>
    qpdOffData(jj) = ffoffdata(qpdchan);  %#ok<AGROW>
end

qpdcalmat = [-175 1417; 2754 -2551];
qpdsamp = min([length(qpdOnData(1).data) length(qpdOffData(1).data)]);
qpdOnDataCal = zeros(4,qpdsamp);
qpdOffDataCal = zeros(4,qpdsamp);

for kk = 1:qpdsamp
    qpdOnDataCal(1,kk) = qpdcalmat(1,1)*qpdOnData(1).data(kk)+qpdcalmat(1,2)*qpdOnData(2).data(kk);
    qpdOnDataCal(2,kk) = qpdcalmat(2,1)*qpdOnData(1).data(kk)+qpdcalmat(2,2)*qpdOnData(2).data(kk);
    qpdOnDataCal(3,kk) = qpdcalmat(1,1)*qpdOnData(3).data(kk)+qpdcalmat(1,2)*qpdOnData(4).data(kk);
    qpdOnDataCal(4,kk) = qpdcalmat(2,1)*qpdOnData(3).data(kk)+qpdcalmat(2,2)*qpdOnData(4).data(kk);
    qpdOffDataCal(1,kk) = qpdcalmat(1,1)*qpdOffData(1).data(kk)+qpdcalmat(1,2)*qpdOffData(2).data(kk);
    qpdOffDataCal(2,kk) = qpdcalmat(2,1)*qpdOffData(1).data(kk)+qpdcalmat(2,2)*qpdOffData(2).data(kk);
    qpdOffDataCal(3,kk) = qpdcalmat(1,1)*qpdOffData(3).data(kk)+qpdcalmat(1,2)*qpdOffData(4).data(kk);
    qpdOffDataCal(4,kk) = qpdcalmat(2,1)*qpdOffData(3).data(kk)+qpdcalmat(2,2)*qpdOffData(4).data(kk);
    
end

for j = 1:4
    qpdOnASD{j}=asd(qpdOnDataCal(j,:),qpdOnData(1).rate,binres);
    qpdOffASD{j}=asd(qpdOffDataCal(j,:),qpdOffData(1).rate,binres);
end

% figures here
figure(1)
set(gcf,'Color','White')
set(gcf,'Units','Pixels','Position',[0 0 600 500])

if exportplot
    set(gcf,'Visible','Off')
end

linewid = 2;
plotfunc = @plot;

oncolor = '4d6993';
offcolor = 'dfb46a';

convertcolor = @(color) hex2dec(reshape(color,2,3)')'/255;
% trans plot
subplot(2,2,3:4)
hold on
plotfunc(transOffASD.f,transOffASD.x,'Color',convertcolor(offcolor),'LineWidth',linewid)
plotfunc(transOnASD.f,transOnASD.x,'Color',convertcolor(oncolor),'LineWidth',linewid)
xlim(60+[-5,5])
%ylim([4e-7 1.5e-4])
ylim([0 2]*1e-7)
set(gca,'Xtick',50:70)
set(gca,'Ytick',[0:2]*1e-7)
set(gca,'FontSize',12)
grid on
set(gca,'LineWidth',2)

ylabel('Transmission (RIN/\surdHz)')
xlabel('Frequency (Hz)')

% beam motion plots

labels = {'Vertical','Horizontal'};

for j = 1:2
    subplot(2,2,j)
    hold on
    plotfunc(qpdOffASD{j}.f,qpdOffASD{j}.x,'Color',convertcolor(offcolor),'LineWidth',linewid)
    plotfunc(qpdOnASD{j}.f,qpdOnASD{j}.x,'Color',convertcolor(oncolor),'LineWidth',linewid)
    set(gca,'FontSize',12)
    grid on
    set(gca,'LineWidth',2)
    xlim(60+[-2,2])
    %ylabel('Waist Motion  (\mum/\surdHz)')
    xlabel('Frequency (Hz)')
    title(labels{j})
    
    set(gca,'Xtick',50:70)
    ylim('auto')
end

subplot(2,2,1)
ylabel('Waist Motion  (\mum/\surdHz)')

subplot(2,2,3:4)
legend('Feedforward Disabled','Feedforward Enabled','Location','NW')

    
if exportplot
    set(gcf,'Visible','Off')
    export_fig('magffperformance.pdf','-painters')
end

end
