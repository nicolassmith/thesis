% matlab
function magffperformance()

exportplot = 1;
grabdata = 0;

duration = 60;

GPSffoff = 931902844.0;
GPSffon = 931901487.041503906;

omctrans = {'H1:OMC-PD_TRANS1_OUT_DAQ'};

omcalignchannels = {'H1:OMC-QPD3_P_OUT_DAQ','H1:OMC-QPD3_Y_OUT_DAQ',...
		    'H1:OMC-QPD4_P_OUT_DAQ','H1:OMC-QPD4_Y_OUT_DAQ'};

allchans = [omctrans omcalignchannels];

if grabdata
    ffondata = get_data(allchannels,'raw',GPSffon,duration);
    ffoffdata = get_data(allchannels,'raw',GPSffoff,duration);
    save('magffdata.mat','lockeddata');
else 
    load magffdata.mat
end

% crunch data and make figure here


if exportplot
    set(gcf,'Visible','Off')
    export_fig('magffperformance.pdf','-painters')
end

end
