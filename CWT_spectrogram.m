clear all;close all;clc
%*******************Time-frequency Transformation*****************************
% Continuous Wavelet Transform (CWT)
% Frequency band: 0.5-50 Hz
%**************************************************************************
%% ===========================set-the-path=================================
p=pwd;
loadpath_ap=[p '\ECG_segment\REM\apnea'];
loadpath_hy=[p '\ECG_segment\REM\hypopnea'];
loadpath_ca=[p '\ECG_segment\REM\central'];

savepath_ap=[p '\spectrogram\0.5_50\REM\apnea'];
savepath_hy=[p '\spectrogram\0.5_50\REM\hypopnea'];
savepath_ca=[p '\spectrogram\0.5_50\REM\central'];

%% ========================load-the-path===================================
cd(loadpath_ap)
filelist_ap=what;
filelist_ap=filelist_ap.mat;
cd(loadpath_hy)
filelist_hy=what;
filelist_hy=filelist_hy.mat;
cd(loadpath_ca)
filelist_ca=what;
filelist_ca=filelist_ca.mat;
%% ======================set-the-frequency-band===========================
%CWT1 0.5-50
fstep1=0.1;   % frequency step for wavelet
maxf1=50;
minf1=0.5;
%% ===============apnea
cd(p)
for i=1:1:length(filelist_ap) % stop o i = 145
    load ([loadpath_ap '\' filelist_ap{i}])
    name=filelist_ap{i,1}(1:end-4);
    samplerate=200;
    time=30;
    N=samplerate*time;
    for j = 1:1:size(ap,1)
        d = ap(j,:);
    data=d(1:N);
     %CWT1 2~35
       taxis=[1:N]/samplerate;
       spec = tfa_morlet(data, samplerate, minf1, maxf1, fstep1);
       faxis=[minf1:fstep1:maxf1];
       Mag=abs(spec);     % get spectrum magnitude
       %clear spec 
       h1=figure(1);
       %figure('color',[1 1 1]),
        mesh(taxis,faxis,Mag)   % plot spectrogram as 3D mesh
        axis([taxis(1) taxis(end) faxis(1) faxis(end)])
       % xlabel('time (s)');
       % ylabel('frequency (Hz)')
       view(0,90);           % specify the 3D plot view
        %colorbar
        axis off
        clear Mag
        clear faxis   
            saveas( h1 , [ savepath_ap '\' name '_' num2str(j) '_A .png' ] )
        close all
    end
end

%% ==============hypopnea
cd(p)
for i=1:1:length(filelist_hy)
    load ([loadpath_hy '\' filelist_hy{i}])
    name=filelist_hy{i,1}(1:end-4);
    samplerate=200;
    time=30;
    N=samplerate*time;
    for j = 1:1:size(hy,1)
        d = hy(j,:);
    data=d(1:N);
     %CWT1 2~35
       taxis=[1:N]/samplerate;
       spec = tfa_morlet(data, samplerate, minf1, maxf1, fstep1);
       faxis=[minf1:fstep1:maxf1];
       Mag=abs(spec);     % get spectrum magnitude
       %clear spec 
       h1=figure(1);
       %figure('color',[1 1 1]),
        mesh(taxis,faxis,Mag)   % plot spectrogram as 3D mesh
        axis([taxis(1) taxis(end) faxis(1) faxis(end)])
        view(0,90);           % specify the 3D plot view
        axis off
        clear Mag
        clear faxis   
        saveas( h1 , [ savepath_hy '\' name '_' num2str(j) '_H .png' ] )
        close all
    end
end

%% ================central
cd(p)
for i=1:1:length(filelist_ca)
    load ([loadpath_ca '\' filelist_ca{i}])
    name=filelist_ca{i,1}(1:end-4);
    samplerate=200;
    time=30;
    N=samplerate*time;
    for j = 1:1:size(ca,1)
        d = ca(j,:);
    data=d(1:N);
     %CWT1 2~35
       taxis=[1:N]/samplerate;
       spec = tfa_morlet(data, samplerate, minf1, maxf1, fstep1);
       faxis=[minf1:fstep1:maxf1];
       Mag=abs(spec);     % get spectrum magnitude
       %clear spec 
       h1=figure(1);
       %figure('color',[1 1 1]),
        mesh(taxis,faxis,Mag)   % plot spectrogram as 3D mesh
        axis([taxis(1) taxis(end) faxis(1) faxis(end)])
        view(0,90);           % specify the 3D plot view
        axis off
        clear Mag
        clear faxis   
        saveas( h1 , [ savepath_ca '\' name '_' num2str(j) '_C .png' ] )
        close all
    end
end