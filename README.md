# Obstructive Sleep Apnea Classification by EEG and Single-Lead ECG Signals
This project to classify different sleep-related respiratory events including Obstructive Apnea, Central Apnea, and Hypopnea using Time-frequency transformation technique and AI algorithms.
#### -by Hoang Trang
* University of Medicine and Pharmacy in Ho Chi Minh City, Vietnam
* M.D: preventive medicine, MSc: biomedical engineering
## Task Summary
1. Input: Single-Lead ECG and EEG signals (C3M2 and C4M1 channels)
2. Output: two classification strategy: Apnea vs Central, Apnea vs Hypopnea
3. Datasets: 201 PSG recordings from University Medical Center (UMC)
4. Preprocessing: artifact removal, signal normalization, band-pass filtering
5. Feature extraction: Wavelet decomposition (DWT and WDA), Continuous Wavelet Transform
6. Classification models: Nested-SVM, ResNet50
## Raw ECG signal and ECG-Spectrogram
![raw_ecg](https://github.com/user-attachments/assets/d2d769ee-c59f-4744-9ef3-be8c5fe83201)
![ecg_spectrogram](https://github.com/user-attachments/assets/3b904fc0-676e-4711-981b-e5e271613c06)
## EEG signals
![raw_EEG](https://github.com/user-attachments/assets/f671e12c-e931-42bd-91b2-9952cb71819e)
![subband_EEG_ap](https://github.com/user-attachments/assets/58419eb6-4a18-44a9-8c10-d82bd43ccc36)
