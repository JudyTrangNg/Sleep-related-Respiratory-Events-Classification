function [y, y_fft] = Preprocess(x)
fs = 200;
[B,A] = butter(2, [1 49]/(fs/2),'bandpass');
fil_data = filtfilt(B,A,x);
window = 5;
h = ones(window,1)/window;
z = filter(h, 1, fil_data);
y = (z-mean(z))/std(z);
y_fft = Cal_FTy(y);
end
function y_fft = Cal_FTy(y)
fn = 100;
L = numel(y);
N = 2^nextpow2(L);
FTs = fft(y,N)/L;
Fv = linspace(0, 1, N/2+1)*fn;
Iv = 1:numel(Fv);
y_fft = figure(3);
plot(Fv, abs(FTs(Iv))*2)
grid on
title('Frequency Spectrum of Filtered Signal');
xlabel('f(Hz)'); ylabel('Amplitude');
end