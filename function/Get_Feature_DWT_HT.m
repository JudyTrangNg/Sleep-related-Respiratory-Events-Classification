function f = Get_Feature_DWT_HT(X)
f = [];
men = mean(X);
sd = std(X);
ske = skewness(X);
kur = kurtosis(X); 
me = median(X);
f = [f, men, sd, ske, kur, me];
end