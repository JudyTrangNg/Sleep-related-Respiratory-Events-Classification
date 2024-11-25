clear;
clc;
%% Load & Plot signals
addpath("function\")
p = pwd;
filepath = [p '\EDF\'];
EDFfile = dir(fullfile(filepath, '*.edf'));
save_C3M2 = [p '\Data_EEG\C3M2'];
save_C4M1 = [p '\Data_EEG\C4M1'];

% Load Annotation files
file = 'D:\sleep_research\UMP-sleep research\Data_EEG\C4M1\';
EEGfile = dir(fullfile(file,'*.mat')); EEGfile = natsortfiles(EEGfile);
file1 = 'D:\sleep_research\UMP-sleep research\Annotation\57case\REM\Oa\';
annOa = dir(fullfile(file1,'*.mat')); annOa = natsortfiles(annOa);
file2 = 'D:\sleep_research\UMP-sleep research\Annotation\57case\REM\Hy\';
annHy = dir(fullfile(file2,'*.mat')); annHy = natsortfiles(annHy);
file3 = 'D:\sleep_research\UMP-sleep research\Annotation\57case\REM\Ca\';
annCa = dir(fullfile(file3,'*.mat')); annCa = natsortfiles(annCa);
save_ap = [p '\EEG_segment\C4M1\REM\apnea'];
save_hy = [p '\EEG_segment\C4M1\REM\hypopnea'];
save_ca = [p '\EEG_segment\C4M1\REM\central'];

%% Process whole dataset
fs = 200;
Fn = fs/2;

for i = 1: length(EDFfile)

    psgFileName = EDFfile(i).name;
    display(psgFileName)
    [informationPSG,originrecord]=edfread([filepath psgFileName]);
    loc_C3M2 = find(strcmp(informationPSG.label, 'C3M2'));
    loc_C4M1 = find(strcmp(informationPSG.label, 'C4M1'));
    record_C3M2 = originrecord(loc_C3M2,:);
    record_C4M1 = originrecord(loc_C4M1,:);
    signal = [record_C3M2; record_C4M1];
    signal = signal';
    preprocessed_signal = preprocessing_signal_v2(signal,fs);
    y1 = preprocessed_signal(:,1);
    y2 = preprocessed_signal(:,2);

    save([save_C3M2 '\' name  '.mat'], 'y1');
    save([save_C4M1 '\' name  '.mat'], 'y2');
%% Load annotation file and conducting signal segmentation
    n = floor(length(y2)/6000);

    load([file1 annOa(i).name]);

    load([file2 annHy(i).name]);

    load([file3 annCa(i).name]);

    data = [];
    for j = 1:1:n
        d=y2((j-1)*6000+1:(j)*6000);
        data = [data, d];
    end
    data = data';

    [val,pos] = intersect(ap2,hy2,'stable');
    ap2(pos,:) = [];
    
    ap = data(ap2,:);
    hy = data(hy2,:);
    ca = data(ca2,:);
   
    save([save_ap '\' name  '.mat'], 'ap');
    save([save_hy '\' name  '.mat'], 'hy');
    save([save_ca '\' name  '.mat'], 'ca');


end