function [FFTecg,d] = PlotFFT(record_ECG)
fs = 200; fn = fs/2;
fc = 1;
[B,A] = butter(2, 2*fc/fs,'high');
d = filtfilt(B,A,record_ECG);
L = numel(d);
N = 2^nextpow2(L);
FTs = fft(d,N)/L;
Fv = linspace(0, 1, N/2+1)*fn;
Iv = 1:numel(Fv);
FFTecg = figure(2);
plot(Fv, abs(FTs(Iv))*2)
grid on
title('Frequency Spectrum of Raw Signal');
xlabel('f(Hz)'); ylabel('Amplitude');
    
end