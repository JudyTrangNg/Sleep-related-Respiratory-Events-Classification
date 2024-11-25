function [IA, IF, WIF] = hilbert_features(signal, fs)

    analytic_signal = hilbert(signal);  % Hilbert transform to get analytic signal
    IA = abs(analytic_signal);  % Instantaneous Amplitude (IA)
    phase = unwrap(angle(analytic_signal));  % Instantaneous phase
    IF = [diff(phase) * fs / (2 * pi), 0];  % Instantaneous Frequency (IF)
    WIF = IA .* IF;  % Amplitude-weighted Frequency (WIF)

end