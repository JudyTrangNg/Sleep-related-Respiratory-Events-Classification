function f=Get_Feature(X)
f = [0];
%m = 2;
%r = 0.2;
men = mean(X);
ske = skewness(X);
kur = kurtosis(X); 
me = median(X);
v = var(X);
%sampleEn = SampEn(X,m,r);
En = wentropy(X,'shannon');
f = [f, men, ske, kur, me, v, En];
end

