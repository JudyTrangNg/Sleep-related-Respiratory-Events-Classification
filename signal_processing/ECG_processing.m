clear all;
clc;
%% Load & Save Dir
p = pwd;
filepath = [p '\EDF\'];
EDFfile = dir(fullfile(filepath, '*.edf'));
save_data_fil = [p '\DataFil'];
% load annotation files
file = 'D:\sleep_research\UMP-sleep research\Data_ECG\';
ECGfile = dir(fullfile(file,'*.mat')); ECGfile = natsortfiles(ECGfile);
file1 = 'D:\sleep_research\UMP-sleep research\Annotation\30s\REM\Oa\';
annOa = dir(fullfile(file1,'*.mat')); annOa = natsortfiles(annOa);
file2 = 'D:\sleep_research\UMP-sleep research\Annotation\30s\REM\Hy\';
annHy = dir(fullfile(file2,'*.mat')); annHy = natsortfiles(annHy);
file3 = 'D:\sleep_research\UMP-sleep research\Annotation\30s\REM\Ca\';
annCa = dir(fullfile(file3,'*.mat')); annCa = natsortfiles(annCa);
save_ap = [p '\ECG_segment\REM\apnea'];
save_hy = [p '\ECG_segment\REM\hypopnea'];
save_ca = [p '\ECG_segment\REM\central'];

%% Process whole dataset 
fs = 200;
d = [];
for i = 1: length(EDFfile)
    psgFileName = EDFfile(i).name;
    [informationPSG,originrecord]=edfread([filepath psgFileName]);
    loc = find(strcmp(informationPSG.label,'Saturation'));
    record_ECG = originrecord(loc,:);
    n = length(record_ECG);

    time = (0:length(record_ECG)-1)/fs;    
    raw = figure(1);
    plot(time,record_ECG)

    fft_ecg = PlotFFT(record_ECG); % plot to check noise
    [y, fft_fil] = Preprocess(record_ECG); % y = filtered ECG

    filECG = figure(4); plot(time,y)

    name = num2str(i);  
    if i<10
        name = ['0' num2str(i)];
    end
    save([save_data_fil '\' name  '.mat'], 'y');
%% Load annotation file and conducting signal segmentation
    n = floor(length(y)/6000);

    load([file1 annOa(i).name]);

    load([file2 annHy(i).name]);

    load([file3 annCa(i).name]);

    load([file4 annNo(i).name]);
    data = [];
    for j = 1:1:n
        d=y((j-1)*6000+1:(j)*6000);
        data = [data; d];
    end

    [val,pos] = intersect(ap2,hy2,'stable');
    ap2(pos,:) = [];

    ap = data(ap2,:);
    hy = data(hy2,:);
    ca = data(ca2,:);
    no = data(no2,:);
   
    save([save_ap '\' name  '.mat'], 'ap');
    save([save_hy '\' name  '.mat'], 'hy');
    save([save_ca '\' name  '.mat'], 'ca');
    save([save_no '\' name  '.mat'], 'no');
  
end





