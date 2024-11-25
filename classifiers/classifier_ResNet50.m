clear; close all; clc
%***************************Retnes50-Model*********************************
% Spliting dataset into 80:20 for training and testing
% 5-fold-cross-validation
%**************************************************************************
fol=[pwd, '\spectrogram\0.5_50\REM']
path = fullfile(fol,{'apnea','hypopnea'});
imds = imageDatastore(path, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
[imdsTrain,imdsTest] = splitEachLabel(imds,0.8,'randomize');

total_split=countEachLabel(imdsTrain)
num_images=length(imdsTrain.Labels);
%% Training Stage
num_folds=5;
for fold_idx=1:num_folds
    fprintf('Processing %d among %d folds \n',fold_idx,num_folds);
    % Test Indices for current fold
    val_idx=fold_idx:num_folds:num_images;
    imdsVal = subset(imdsTrain,val_idx);
    countEachLabel(imdsVal)
    % Train indices for current fold
    train_idx=setdiff(1:length(imdsTrain.Files),val_idx);
    imdsSubTrain = subset(imdsTrain,train_idx);
    countEachLabel(imdsSubTrain)
    % ResNet Architecture 
    net=resnet50;
    lgraph = layerGraph(net);
    clear net;
    
    % Number of categories
    numClasses = numel(categories(imdsSubTrain.Labels));
    
    % New Learnable Layer
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
    % Replacing the last layers with new layers
    lgraph = replaceLayer(lgraph,'fc1000',newLearnableLayer);
    newsoftmaxLayer = softmaxLayer('Name','new_softmax');
    lgraph = replaceLayer(lgraph,'fc1000_softmax',newsoftmaxLayer);
    newClassLayer = classificationLayer('Name','new_classoutput');
    lgraph = replaceLayer(lgraph,'ClassificationLayer_fc1000',newClassLayer);
    
    % Training Options, we choose a small mini-batch size due to limited images 
    options = trainingOptions('sgdm',...
        'MaxEpochs',50,'MiniBatchSize',30,...
        'Shuffle','every-epoch', ...
        'InitialLearnRate',1e-4, ...
        'ExecutionEnvironment','gpu', ...
        'Verbose',false, ...
        'Plots','training-progress');
    
    % Data Augumentation
    augmenter = imageDataAugmenter( ...
        'RandRotation',[-5 5],'RandXReflection',1,...
        'RandYReflection',1,'RandXShear',[-0.05 0.05],'RandYShear',[-0.05 0.05]);
    
    % Resizing all training images to [224 224] for ResNet architecture
    auimds = augmentedImageDatastore([224 224],imdsSubTrain,'DataAugmentation',augmenter,...
        'ColorPreprocessing','gray2rgb');
    
    % Training
    netTransfer = trainNetwork(auimds,lgraph,options);
    
    % Resizing all testing images to [224 224] for ResNet architecture   
    augvalimds = augmentedImageDatastore([224 224],imdsVal,'DataAugmentation',augmenter,...
        'ColorPreprocessing','gray2rgb');
   
    % Testing and their corresponding Labels and Posterior for each Case
    [predicted_labels(val_idx),posterior(val_idx,:)] = classify(netTransfer,augvalimds);
    
    % Save the Independent ResNet Architectures obtained for each Fold
    save(sprintf('ResNet50_%d_among_%d_folds',fold_idx,num_folds),'netTransfer','val_idx','train_idx','predicted_labels','imdsVal');
    
    % Clearing unnecessary variables 
    clearvars -except fold_idx num_folds num_images predicted_labels posterior imds netTransfer;
    
end
%% Testing Stage
augtestimds = augmentedImageDatastore([224 224],imdsTest,'DataAugmentation',augmenter,...
        'ColorPreprocessing','gray2rgb');
[YPred,scores] = classify(netTransfer,augtestimds);

%% Calculating performance indices
idx = (ACTUAL()=='central');
p = length(ACTUAL(idx));
n = length(ACTUAL(~idx));
N = p+n;
tp = sum(ACTUAL(idx)==PREDICTED(idx));
tn = sum(ACTUAL(~idx)==PREDICTED(~idx));
fp = n-tn;
fn = p-tp;
tp_rate = tp/p;
tn_rate = tn/n;
accuracy = (tp+tn)/N;
sensitivity = tp_rate;
specificity = tn_rate;
prec = tp./(tp+fp);
f1 = (2.*prec.*sensitivity)/(prec+sensitivity);

