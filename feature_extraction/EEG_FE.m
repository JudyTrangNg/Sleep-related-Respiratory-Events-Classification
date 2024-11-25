%% Extract EEG features using Discreate Wavelet Transform (DWT) - db8 - 5 levels
clear; clc
addpath("function\");
p = pwd;
file = 'D:\sleep_research\UMP-sleep research\ECG_segment\REM\apnea\';
EEGfile = dir(fullfile(file,'*.mat')); EEGfile = natsortfiles(EEGfile);

fs = 200;  % Sampling frequency (Hz)
epoch_duration = 30;  % Epoch duration (seconds)
num_samples = fs * epoch_duration;  % Number of samples per epoch
wavelet = 'db8';  % Daubechies wavelet of order 3
levels = 8;  % Number of decomposition levels

Apnea = [];
for i = 1:length(EEGfile)
    name = EEGfile(i).name(1:end-4);
    disp(name)
    load([file EEGfile(i).name]);       
    Feature = [];
        if ~isempty(ap)
            for k = 1:size(ap,1)
                D = [];
                eeg_epoch = ap(k,:);       
                %mean_eeg_epoch = mean(eeg_epoch);
                %std_eeg_epoch = std(eeg_epoch);
                %eeg_standardized = (eeg_epoch - mean_eeg_epoch) ./ std_eeg_epoch;
                % Perform DWT
                [c,l] = wavedec(eeg_epoch, levels, wavelet);
                
                % Extract detail coefficients for each frequency band
                D1 = wrcoef('d', c, l, wavelet, 1); 
                D2 = wrcoef('d', c, l, wavelet, 2);  % Gamma band (32-64 Hz)
                D3 = wrcoef('d', c, l, wavelet, 3);  % Beta band (16-32 Hz)
                D4 = wrcoef('d', c, l, wavelet, 4);  % Alpha band (8-16 Hz)
                D5 = wrcoef('d', c, l, wavelet, 5);  % Theta band (4-8 Hz)
                D6 = wrcoef('d', c, l, wavelet, 6);  % Theta band (4-8 Hz)
                D7 = wrcoef('d', c, l, wavelet, 7);  % Theta band (4-8 Hz)
                D8 = wrcoef('d', c, l, wavelet, 8);  % Theta band (4-8 Hz)
                A8 = wrcoef('a', c, l, wavelet, 8);  % Delta band (0-4 Hz)
                
                % Calculate IA, IF, WIF for each DWT coefficient
                [IA_D1, IF_D1, WIF_D1] = hilbert_features(D1, fs);  
                [IA_D2, IF_D2, WIF_D2] = hilbert_features(D2, fs);  
                [IA_D3, IF_D3, WIF_D3] = hilbert_features(D3, fs);  
                [IA_D4, IF_D4, WIF_D4] = hilbert_features(D4, fs);  
                [IA_D5, IF_D5, WIF_D5] = hilbert_features(D5, fs);
                [IA_D6, IF_D6, WIF_D6] = hilbert_features(D6, fs);
                [IA_D7, IF_D7, WIF_D7] = hilbert_features(D7, fs);
                [IA_D8, IF_D8, WIF_D8] = hilbert_features(D8, fs);
                [IA_A8, IF_A8, WIF_A8] = hilbert_features(A8, fs); 

                fe_D1 = [];
                    fe_IA_D1 =  Get_Feature(IA_D1);
                    fe_IF_D1 =  Get_Feature(IF_D1);
                    fe_WIF_D1 =  Get_Feature(WIF_D1);
                    fe_D1 = [fe_D1,fe_IA_D1, fe_IF_D1, fe_WIF_D1];
           
                fe_D2 = [];
                    fe_IA_D2 =  Get_Feature(IA_D2);
                    fe_IF_D2 =  Get_Feature(IF_D2);
                    fe_WIF_D2 =  Get_Feature(WIF_D2);
                    fe_D2 = [fe_D2,fe_IA_D2, fe_IF_D2, fe_WIF_D2];

                fe_D3 = [];
                    fe_IA_D3 =  Get_Feature(IA_D3);
                    fe_IF_D3 =  Get_Feature(IF_D3);
                    fe_WIF_D3 =  Get_Feature(WIF_D3);
                    fe_D3 = [fe_D3,fe_IA_D3, fe_IF_D3, fe_WIF_D3];

                fe_D4 = [];
                    fe_IA_D4 =  Get_Feature(IA_D4);
                    fe_IF_D4 =  Get_Feature(IF_D4);
                    fe_WIF_D4 =  Get_Feature(WIF_D4);
                    fe_D4 = [fe_D4,fe_IA_D4, fe_IF_D4, fe_WIF_D4];

                fe_D5 = [];
                    fe_IA_D5 =  Get_Feature(IA_D5);
                    fe_IF_D5 =  Get_Feature(IF_D5);
                    fe_WIF_D5 =  Get_Feature(WIF_D5);
                    fe_D5 = [fe_D5,fe_IA_D5, fe_IF_D5, fe_WIF_D5];

                                    fe_D6 = [];
                    fe_IA_D6 =  Get_Feature(IA_D6);
                    fe_IF_D6 =  Get_Feature(IF_D6);
                    fe_WIF_D6 =  Get_Feature(WIF_D6);
                    fe_D6 = [fe_D6,fe_IA_D6, fe_IF_D6, fe_WIF_D6];

                                    fe_D7 = [];
                    fe_IA_D7 =  Get_Feature(IA_D7);
                    fe_IF_D7 =  Get_Feature(IF_D7);
                    fe_WIF_D7 =  Get_Feature(WIF_D7);
                    fe_D7 = [fe_D7,fe_IA_D7, fe_IF_D7, fe_WIF_D7];

                                    fe_D8 = [];
                    fe_IA_D8 =  Get_Feature(IA_D8);
                    fe_IF_D8 =  Get_Feature(IF_D8);
                    fe_WIF_D8 =  Get_Feature(WIF_D8);
                    fe_D8 = [fe_D8,fe_IA_D8, fe_IF_D8, fe_WIF_D8];

                fe_A8 = [];
                    fe_IA_A8 =  Get_Feature(IA_A8);
                    fe_IF_A8 =  Get_Feature(IF_A8);
                    fe_WIF_A8 =  Get_Feature(WIF_A8);
                    fe_A8 = [fe_A8,fe_IA_A8, fe_IF_A8, fe_WIF_A8];

                D = [D, fe_D1, fe_D2, fe_D3, fe_D4, fe_D5, fe_D6, fe_D7, fe_D8, fe_A8];
                Feature = [Feature; D];
            end
            %Feature = Feature';
            Apnea = [Apnea; Feature];
        end
end
%% feature selection using NCA
%ap = Apnea(:,16:75);
%hy = Apnea(:,16:75);
ap = Apnea;
hy = Hypopnea;
allData = [ap; hy];
Xtrain = allData;
label0 = repmat("apnea",length(Apnea),1);
label1 = repmat("hypopnea",length(Hypopnea),1);
ytrain = categorical([label0;label1]);

kFolds = 5;
kIdx = crossvalind('Kfold', length(ytrain), kFolds);
%numvalidsets = cvp.NumTestSets;
n = length(ytrain);
lambdavals = linspace(0,20,20)/n;
lossvals = zeros(length(lambdavals),kFolds);n = length(ytrain);
for i = 1:length(lambdavals)
    for k = 1:kFolds
        X = Xtrain(kIdx~=k, :);
        y = ytrain(kIdx~=k);
        Xvalid = Xtrain(kIdx==k, :);
        yvalid = ytrain(kIdx==k);

        nca = fscnca(X,y,'FitMethod','exact', ...
             'Solver','sgd','Lambda',lambdavals(i), ...
             'IterationLimit',30,'GradientTolerance',1e-4, ...
             'Standardize',true);
                  
        lossvals(i,k) = loss(nca,Xvalid,yvalid,'LossFunction','classiferror');
    end
end
meanloss = mean(lossvals,2);
[~,idx] = min(meanloss)
bestlambda = lambdavals(idx)
bestloss = meanloss(idx)
nca = fscnca(Xtrain,ytrain,'FitMethod','exact','Solver','sgd',...
    'Lambda',bestlambda,'Standardize',true,'Verbose',1);
tol    = 0.02;
selidx = find(nca.FeatureWeights > tol*max(1,max(nca.FeatureWeights)))

