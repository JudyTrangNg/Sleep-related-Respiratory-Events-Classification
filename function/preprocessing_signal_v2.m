function out = preprocessing_signal_v2(sig,Fs)
%% butterworth bandstop filter
    N   = 10;   % Order
    Fc1 = 0.5;  % First Cutoff Frequency
    Fc2 = 64;   % Second Cutoff Frequency

    % Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
    filter1 = design(h, 'butter');
    butter_filtered=filter(filter1,sig);


%% Notch Filter
notch = designfilt('bandstopiir','FilterOrder',2, ...
    'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
    'DesignMethod','butter','SampleRate',Fs);

notch_filtered=filter(notch,butter_filtered);

out=notch_filtered;
fs = Fs;
fprintf('\n Preprocessing is finished ... \n');
toc
fprintf('...................................................................\n');

end

