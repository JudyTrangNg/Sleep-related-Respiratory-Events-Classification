load('selidx.mat');
allData = [Apnea; Hypopnea];
Data = allData(:,selidx);
label0 = repmat("apnea",length(Apnea),1);
label1 = repmat("hypopnea",length(Hypopnea),1);
Label = categorical([label0;label1]);
%
kFolds = 5;     % specify number of folds
bestSVM = struct('SVMModel', NaN, ...     % this is to store the best SVM
    'C', NaN, 'FeaturesIdx', NaN, 'Score', Inf);
kIdx = crossvalind('Kfold', length(Label), kFolds);
accuracy_fold=[];
totalYPreds=[];
totalYTest=[];
for k = 1:kFolds
    trainData = Data(kIdx~=k, :);
    trainTarg = Label(kIdx~=k);
    testData = Data(kIdx==k, :);
    testTarg = Label(kIdx==k);

    % this is the grid search for the BoxConstraint
    bestCScore = inf;
    bestC = NaN;
    gridC = 2.^(-5:2:15);
    for C = gridC
        % cross validation for parameter C
        kIdxC = crossvalind('Kfold', length(trainTarg), kFolds);
        L = zeros(1, kFolds);
        for kC = 1:kFolds
            trainDataC = trainData(kIdxC~=kC, :);
            trainTargC = trainTarg(kIdxC~=kC);
            testDataC = trainData(kIdxC==kC, :);
            testTargC = trainTarg(kIdxC==kC);
            anSVMModel = fitcsvm(trainDataC, trainTargC, ...
                    'KernelFunction', 'polynomial', ...
                    'PolynomialOrder', 2, ... 
                    'KernelScale', 'auto', ...
                    'BoxConstraint', C, ...
                    'Standardize', true, ...
                    'ClassNames', categorical({'apnea'; 'central'}));
            L(kC) = loss(anSVMModel,testDataC, testTargC);
        end
        L = mean(L);
        if L < bestCScore
            bestCScore = L;
            bestC = C;
        end
    end
    % we need to retrain here and save the SVM for the best C
    bestCSVM = fitcsvm(trainData, trainTarg, ...
            'KernelFunction', 'polynomial', ...
            'PolynomialOrder', 2, ... 
            'KernelScale', 'auto', ...
            'BoxConstraint', bestC, ...
            'Standardize', true, ...
            'ClassNames', categorical({'apnea'; 'central'}));
   [predictedLabels,scores] =  predict(bestCSVM, testData);
        bestCScore = loss(bestCSVM,testData,testTarg);
        acc = mean(predictedLabels == testTarg);
        accuracy_fold = [accuracy_fold; acc];
        totalYPreds = [totalYPreds; predictedLabels];
        totalYTest = [totalYTest; testTarg];
  
    % saving the best SVM over all folds
    if bestCScore < bestSVM.Score
       bestSVM.Score = bestCScore;
        bestSVM.SVMModel = bestCSVM;
        bestSVM.C = bestC;
        bestSVM.Accuracy = acc;
    end
end