p = pwd;
filepath = [p '\Data_EEG\C4M1\'];
EEGfile = dir(fullfile(filepath, '*.mat'));
cd(filepath)
load('69.mat')
%% Plot 30s-EEG epoch according to apnea, hypopnea, and central
record_c4 = y2(6001:6048000,:);
% apnea epoch
ap_c4 = record_c4(5559352:5565351,:);
mean_ap_c4 = mean(ap_c4);
std_ap_c4 = std(ap_c4);
standardized_ap_c4= (ap_c4 - mean_ap_c4) ./ std_ap_c4;
%hypopnea epoch
hy_c4 = record_c4(5580553:5586552,:);
mean_hy_c4 = mean(hy_c4);
std_hy_c4 = std(hy_c4);
standardized_hy_c4 = (hy_c4 - mean_hy_c4) ./ std_hy_c4;
%central epoch
ca_c4 = record_c4(5571352:5577351,:);
mean_ca_c4 = mean(ca_c4);
std_ca_c4 = std(ca_c4);
standardized_ca_c4= (ca_c4 - mean_ca_c4) ./ std_ca_c4;

h1 = figure(1)
subplot(3,1,1)
plot(1/fs:1/fs:30,standardized_ap_c4, 'LineWidth',0.5)
ylabel('Amplitude'); title('EEG epoch of OSA', 'LineWidth',1)
subplot(3,1,2)
plot(1/fs:1/fs:30,standardized_ca_c4, 'LineWidth',0.5)
xlabel('Time(s)'); ylabel('Amplitude'); title('EEG epoch of CSA', 'LineWidth',1)
subplot(3,1,3)
plot(1/fs:1/fs:30,standardized_hy_c4, 'LineWidth',0.5)
xlabel('Time(s)'); ylabel('Amplitude'); title('EEG epoch of Hypopnea', 'LineWidth',1)

%% plot sub-band
wavelet = 'db8'
levels = 5; 

% Perform DWT
[c,l] = wavedec(standardized_ca_c4, levels, wavelet);
% Extract detail coefficients for each frequency band
D1 = wrcoef('d', c, l, wavelet, 1);
D2 = wrcoef('d', c, l, wavelet, 2);  % Gamma band (32-64 Hz)
D3 = wrcoef('d', c, l, wavelet, 3);  % Beta band (16-32 Hz)
D4 = wrcoef('d', c, l, wavelet, 4);  % Alpha band (8-16 Hz)
D5 = wrcoef('d', c, l, wavelet, 5);  % Theta band (4-8 Hz)
A5 = wrcoef('a', c, l, wavelet, 5);  % Delta band (0-4 Hz)

h2 = figure(2)
subplot(3,2,1)
plot(1/fs:1/fs:30,standardized_ca_c4, 'LineWidth',0.5)
ylabel('Amplitude'); title('EEG epoch', 'LineWidth',1)
subplot(3,2,2)
plot(1/fs:1/fs:30,A5, 'LineWidth',0.5)
title('A5 (0-4 Hz)', 'LineWidth',1)
subplot(3,2,3)
plot(1/fs:1/fs:30,D5, 'LineWidth',0.5)
ylabel('Amplitude'); title('D5 (4-8 Hz)', 'LineWidth',1)
subplot(3,2,4)
plot(1/fs:1/fs:30,D4, 'LineWidth',0.5)
title('D4 (8-16 Hz)', 'LineWidth',1)
subplot(3,2,5)
plot(1/fs:1/fs:30,D3, 'LineWidth',0.5)
ylabel('Amplitude'); xlabel('Time(s)'); title('D3 (16-32 Hz)', 'LineWidth',1)
subplot(3,2,6)
plot(1/fs:1/fs:30,D2, 'LineWidth',0.5)
title('D2 (32-64 Hz)', 'LineWidth', 1); xlabel('Time(s)')
