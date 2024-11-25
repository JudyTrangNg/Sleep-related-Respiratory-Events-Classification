addpath("function\")
p = pwd;
filepath = [p '\EDF\'];
EDFfile = dir(fullfile(filepath, '*.edf'));

ECGfilepath = [p '\Data_ECG\'];
ECGfile = dir(fullfile(filepath, '*.mat'));
cd(ECGfilepath)
load('69.mat')

psgFileName = EDFfile(69).name;
display(psgFileName)
[informationPSG,originrecord]=edfread([filepath psgFileName]);
loc_flow = find(strcmp(informationPSG.label, 'Flow') )
record_flow = originrecord(loc_flow,:);
record_flow = record_flow(:,6001:6048000);

loc_thorax = find(strcmp(informationPSG.label, 'Thorax'));
record_thorax = originrecord(loc_thorax,:);
record_thorax = record_thorax(751:756000);


%% plot
fs = 200;
fs1 = 25;
time = 150;

h1=figure(1);
d = record_flow(:,5580553:5586552);
plot(1/fs:1/fs:30,d)
ylim([-1 1])

h2 = figure(2);
d1 = record_thorax(:,694931:698680);
plot(1/fs1:1/fs1:time,d1)

h3 = figure(3);
record_ecg = y(:,6001:6048000);
d2 = record_ecg(:,5559352:5589351);
plot(1/fs:1/fs:time,d2,'LineWidth',0.5)
ylabel('Amplitude'); title('raw ECG')

h4 = figure(4)
subplot(3,1,1)
d = record_flow(:,5559352:5589351);
plot(1/fs:1/fs:time,d, 'LineWidth',0.5)
ylabel('Flow')
subplot(3,1,2)
d1 = record_thorax(:,694931:698680);
plot(1/fs1:1/fs1:time,d1, 'LineWidth',0.5)
ylabel('Thorax')
subplot(3,1,3)
record_ecg = y(:,6001:6048000);
d2 = record_ecg(:,5559352:5589351);
plot(1/fs:1/fs:time,d2, 'LineWidth',0.5)
xlabel('Time(s)'); ylabel('ECG')