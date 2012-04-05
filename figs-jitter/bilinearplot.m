%function bilinearplot()
exportplot = 0;
grabdata = 0;
mDV; % load mdv path

duration = 300; %s
tgrab = 928061805;

% grab data sadness
statechannels = {'H1:DMT-SNSM_RANGE_1MINAVG','H1:LSC-LA_PTRX_NORM','H1:LSC-LA_PTRY_NORM','H1:LSC-LA_SPOB_NORM'};

readoutchannels = {'H1:LSC-DARM_ERR','H1:OMC-PD_SUM_OUT_DAQ',...
    'H1:OMC-PD_TRANS1_OUT_DAQ','H1:OMC-PD_TRANS2_OUT_DAQ'};

omcalignchannels = {'H1:OMC-QPD3_P_OUT_DAQ','H1:OMC-QPD3_Y_OUT_DAQ','H1:OMC-QPD3_SUM_IN1_DAQ',...
    'H1:OMC-QPD4_P_OUT_DAQ','H1:OMC-QPD4_Y_OUT_DAQ','H1:OMC-QPD4_SUM_IN1_DAQ',...
    'H1:OMC-QPD1_P_OUT_DAQ','H1:OMC-QPD1_Y_OUT_DAQ','H1:OMC-QPD1_SUM_IN1_DAQ',...
    'H1:OMC-QPD2_P_OUT_DAQ','H1:OMC-QPD2_Y_OUT_DAQ','H1:OMC-QPD2_SUM_IN1_DAQ'};
                    

allchannels = [statechannels,readoutchannels,omcalignchannels];

if grabdata
    lockeddata = get_data(allchannels,'raw',tgrab,duration);
    save('bilinearplotdata.mat','lockeddata');
else 
    load bilinearplotdata.mat
end

log2bins = 20;
asdtime = duration; %seconds



transData = lockeddata(7);
qpdData = lockeddata(9);

rate = transData.rate;
samples = rate*asdtime;

binres = transData.rate/(2^log2bins);

transASD = asd(transData.data(1:samples),transData.rate,binres);
QPDASD = asd(qpdData.data,qpdData.rate,binres);

figure(1)
semilogy(transASD.f,transASD.x)
xlim([140 155])
ylim([1e-7 0.3e-5])
grid on

figure(2)
semilogy(QPDASD.f,QPDASD.x)

if exportplot
    set(gcf,'Visible','Off')
    export_fig('bilinearplot.pdf','-painters')
end

%end