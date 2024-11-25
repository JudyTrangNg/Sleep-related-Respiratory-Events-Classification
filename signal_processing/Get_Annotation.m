clear; clc;
addpath("function\");
filepath = [pwd '\EDF\'];
xlsfile = dir('./XLS/*.xls');
EDFfile = dir('./EDF/*.edf');
sv_a_nr = [pwd '\Annotation\30s\NREM\Oa'];
sv_h_nr = [pwd '\Annotation\30s\NREM\Hy'];
sv_c_nr = [pwd '\Annotation\30s\NREM\Ca'];
sv_n_nr = [pwd '\Annotation\30s\NREM\No'];
sv_a_r = [pwd '\Annotation\30s\REM\Oa'];
sv_h_r = [pwd '\Annotation\30s\REM\Hy'];
sv_c_r = [pwd '\Annotation\30s\REM\Ca'];
sv_n_r = [pwd '\Annotation\30s\REM\No'];
%%
for i = 1:length(EDFfile)

    filename = xlsfile(i).name;
    information = LoadXls(filename); %
    psgFileName = EDFfile(i).name;
    [informationPSG,originrecord]=edfread([filepath psgFileName]); %
%% calculate start-time into second
    start_duration = [];
    n = string(informationPSG.starttime);
    n = strrep(n, '.', ':');
    for j = 1:length(information)
        x = information(j,2);
        n1 = Duration(n,x); %
        start_duration = [start_duration; n1];
    end
    information(:,2) = string(start_duration);
%% find NREM stage/ 1~nrem
    SleepStage = findNrem(information); %

    loc = find(strcmp(SleepStage,'A. Obstructive'));
    ap1 = findEpoch(loc,SleepStage); %
    loc = find(strcmp(SleepStage,'Hypopnea'));
    hy1 = findEpoch(loc,SleepStage);
    loc = find(strcmp(SleepStage,'A. Central'));
    ca1 = findEpoch(loc,SleepStage);
    a = unique([ap1; hy1; ca1],'stable');

    nrem_epoch = find(strcmp(SleepStage,'NREM'));
    nrem_epoch = SleepStage(nrem_epoch,4);
    nrem_epoch = str2double(nrem_epoch);
    idx = find(~ismember(nrem_epoch, a));
    no1 = nrem_epoch(idx,:);

 %  rename = 125:1:144;
    name = num2str(i);
   %  if i<10
    %    name = ['0' num2str(i)];
    %end
    save([sv_a_nr '\' name '.mat'], 'ap1');
    save([sv_h_nr '\' name '.mat'], 'hy1');
    save([sv_c_nr '\' name '.mat'], 'ca1');
    save([sv_n_nr '\' name '.mat'], 'no1');
%% find REM stage/ 2~rem
    SleepStage = findRem(information); %
   
    loc = find(strcmp(SleepStage,'A. Obstructive'));
    ap2= findEpoch(loc,SleepStage);
    loc = find(strcmp(SleepStage,'Hypopnea'));
    hy2 = findEpoch(loc,SleepStage);
    loc = find(strcmp(SleepStage,'A. Central'));
    ca2 = findEpoch(loc,SleepStage);
    a = unique([ap2; hy2; ca2],'stable');

    rem_epoch = find(strcmp(SleepStage,'REM'));
    rem_epoch = SleepStage(rem_epoch,4);
    rem_epoch = str2double(rem_epoch);
    idx = find(~ismember(rem_epoch, a));
    no2 = rem_epoch(idx,:);
  
    save([sv_a_r '\' name '.mat'], 'ap2');
    save([sv_h_r '\' name '.mat'], 'hy2');
    save([sv_c_r '\' name '.mat'], 'ca2');
    save([sv_n_r '\' name '.mat'], 'no2');
end