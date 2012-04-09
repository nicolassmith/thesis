function bilinearplot()
exportplot = 1;
grabdata = 0;
mDV; % load mdv path

% plot things
highfcenter = 147.25;
xsize = [-10 10];

duration = 300; %s
tgrab = 928061805;

% grab data sadness
statechannels = {'H1:DMT-SNSM_RANGE_1MINAVG','H1:LSC-LA_PTRX_NORM','H1:LSC-LA_PTRY_NORM','H1:LSC-LA_SPOB_NORM'};

%readoutchannels = {'H1:OMC-PD_SUM_OUT_DAQ','H1:OMC-PD_SUM_OUT_DAQ',...
%    'H1:OMC-PD_TRANS1_OUT_DAQ','H1:OMC-PD_SUM_OUT_DAQ'};

readoutchannels = {'H1:OMC-PD_TRANS1_OUT_DAQ'};

omcalignchannels = {'H1:OMC-QPD3_P_OUT_DAQ','H1:OMC-QPD3_Y_OUT_DAQ',...
    'H1:OMC-QPD4_P_OUT_DAQ','H1:OMC-QPD4_Y_OUT_DAQ'};
                    

allchannels = [statechannels,readoutchannels,omcalignchannels];

if grabdata
    lockeddata = get_data(allchannels,'raw',tgrab,duration);
    save('bilinearplotdata.mat','lockeddata');
else 
    load bilinearplotdata.mat
end

log2bins = 20;
asdtime = duration; %seconds



transData = lockeddata(5);

jj = 0;   %   3P 4P 3Y 4Y
for qpdchan = [6 8 7 9];
    jj = jj+1;
    qpdData(jj) = lockeddata(qpdchan); %#ok<AGROW>
end

qpdcalmat = [-175 1417; 2754 -2551];
qpdsamp = length(qpdData(1).data);
qpdDataCal = zeros(4,qpdsamp);

for kk = 1:qpdsamp
    qpdDataCal(1,kk) = qpdcalmat(1,1)*qpdData(1).data(kk)+qpdcalmat(1,2)*qpdData(2).data(kk);
    qpdDataCal(2,kk) = qpdcalmat(2,1)*qpdData(1).data(kk)+qpdcalmat(2,2)*qpdData(2).data(kk);
    qpdDataCal(3,kk) = qpdcalmat(1,1)*qpdData(3).data(kk)+qpdcalmat(1,2)*qpdData(4).data(kk);
    qpdDataCal(4,kk) = qpdcalmat(2,1)*qpdData(3).data(kk)+qpdcalmat(2,2)*qpdData(4).data(kk);
    
end

rate = transData.rate;
samples = rate*asdtime;

binres = transData.rate/(2^log2bins);

transASD = asd(transData.data(1:samples),transData.rate,binres);
jjrange = 1;
for jj = jjrange
    QPDASD(jj) = asd(qpdDataCal(jj,:),qpdData(1).rate,binres);  %#ok<AGROW>
end

f_=figure(1);
if exportplot
    set(gcf,'Visible','Off')
end
set(f_,'Color','White')
set(f_,'Units','Pixels','Position',[0 0 600 750])


convertcolor = @(color) hex2dec(reshape(color,2,3)')'/255;
linecolor = '0772a1';
linewid = 1.5;

subplot(3,1,3)
set(gcf,'Visible','Off')
semilogy(transASD.f,transASD.x/mean(transData.data(1:samples)),'LineWidth',linewid,'Color',convertcolor(linecolor))
xlim(highfcenter+xsize)
ylim([0.9e-7 0.3e-5]/mean(transData.data(1:samples)))
ylabel('Transmitted Power (RIN/\surdHz)')
grid on
set(gca,'LineWidth',2)

%clf
for jj = jjrange;
    %figure(1+jj)
    subplot(3,1,1)
    if exportplot
        set(gcf,'Visible','Off')
    end
    semilogy(QPDASD(jj).f,QPDASD(jj).x,'LineWidth',linewid,'Color',convertcolor(linecolor))
    xlim(xsize)
    ylim([2 600])
    grid on
    set(gca,'LineWidth',2)
    ylabel('Beam Waist Motion (\mum/\surdHz)')
    
    %figure(5+jj)
    subplot(3,1,2)
    if exportplot
        set(gcf,'Visible','Off')
    end
    semilogy(QPDASD(jj).f,QPDASD(jj).x,'LineWidth',linewid,'Color',convertcolor(linecolor))
    xlim(highfcenter+xsize)
    ylim([0.8e-4 2e-3])
    grid on
    set(gca,'LineWidth',2)
    ylabel('Beam Waist Motion (\mum/\surdHz)')
end

subplot(3,1,3)
xlabel('Frequency (Hz)')

if exportplot
    set(gcf,'Visible','Off')
    export_fig('bilinearplot.pdf','-painters')
end

end