function [out]=band_extraction_kaiser(preprocessed_sig,Fs)

%% DELTA
N    = 10;       % Order
Fc1  = 0.5;      % First Cutoff Frequency
Fc2  = 4;        % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 0.5;      % Window Parameter
% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd_delta = dfilt.dffir(b);
out.Delta=filter(Hd_delta,preprocessed_sig);
%% THETA
Fc1  = 4;      % First Cutoff Frequency
Fc2  = 8;        % Second Cutoff Frequency
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd_theta = dfilt.dffir(b);
out.Theta=filter(Hd_theta,preprocessed_sig);
%% Alpha
Fc1  = 8;      % First Cutoff Frequency
Fc2  = 12;        % Second Cutoff Frequency
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd_alpha = dfilt.dffir(b);
out.Alpha=filter(Hd_alpha,preprocessed_sig);
%% BETA
Fc1  = 16;      % First Cutoff Frequency
Fc2  = 40;        % Second Cutoff Frequency
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd_beta = dfilt.dffir(b);
out.Beta=filter(Hd_beta,preprocessed_sig);
%% SIGMA
Fc1  = 12;      % First Cutoff Frequency
Fc2  = 16;        % Second Cutoff Frequency
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd_sigma = dfilt.dffir(b);
out.Sigma=filter(Hd_sigma,preprocessed_sig);
end



