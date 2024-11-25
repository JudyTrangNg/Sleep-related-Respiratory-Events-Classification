%% Extract ECG features using Wavlet Packet Analysis (WPA) - db4 - 5 levels
clear;clc
addpath("function\");
p = pwd;
file = 'D:\sleep_research\UMP-sleep research\ECG_segment\REM\apnea\';
EEGfile = dir(fullfile(file,'*.mat')); EEGfile = natsortfiles(EEGfile);
Apnea = [];
%%%%
    for i = 1:length(EEGfile)
        name = EEGfile(i).name(1:end-4);
        disp(name)
        load([file EEGfile(i).name]);       
        Feature = [];           
        if ~isempty(ap)
            
            for j = 1:size(ap,1)
                Feature = [];
                x = ap(j,:);
                wpt = wpdec(x,5,'db4');
                %plot(wpt)
                origin = get(wpt, 'allNI');
                for k = 1:length(origin)-1
               
                    de = wpcoef(wpt,k);
                    en = origin(k+1,4);
                    r = iqr(de);
                    V = var(de);
                    SD = std(de);
                    MAD = mean(abs(de - mean(de)));
                    %D = [D;en;r;V;SD;MAD];
                    Feature = [Feature;en;r;V;SD;MAD];
                    Fe = Feature';
                    
                end
                Apnea = [Apnea; Fe];
            end
            end
    end

%% Balance dataset using SMOTE technique

addpath("smote_functions\");
label0 = repmat("apnea",size(Apnea,1),1);
label1 = repmat("central",size(Apnea,1),1);

dataset = array2table([Apnea;Apnea]);
dataset = addvars(dataset, [label0;label1],...
    'NewVariableNames','label');
labels = dataset(:,end);
t = tabulate(dataset.label)
uniqueLabels = string(t(:,1));
labelCounts = cell2mat(t(:,2));

num2Add = [0,25000];
k = 10;
newdata = table;
visdataset = cell(length(uniqueLabels),1);
for ii=1:length(uniqueLabels)
    
            [tmp,visdata] = mySMOTE(dataset,uniqueLabels(ii),num2Add(ii),...
                "NumNeighbors",k, "Standardize", true);
      
    newdata = [newdata; tmp];
    visdataset{ii} = visdata;
end


new_ca = table2array(newdata(:,1:75));
Central_syn = [Apnea;new_ca];
allData = [ecgData, eegData];
%% Feature Selection using NCA
%allData = [Apnea; Hypopnea_syn];
c3m2 = [c3m2_ap; c3m2_hy];
c4m1 = [c4m1_ap; c4m1_hy];
allData = [c3m2, c4m1];
Xtrain = allData;
label0 = repmat("apnea",length(c3m2_ap),1);
label1 = repmat("hypopnea",length(c3m2_hy),1);
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
