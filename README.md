# PCA Denoising and Bio-voice Count Index (BCI) Code for Coral Reef Bioacoustic Recordings

## Abstract

This dataset contains low-pass filtered (0–1 kHz) audio excerpts recorded on July 16, 2023, from coral reef ecosystems near Sanya, China, using a LoPAS-L low-power self-capacitating acoustic recorder (sensitivity: -194 dB re 1 V/μPa; sampling rate: 128 kHz). Each 1-minute audio clip focuses on fish vocalizations. Along with the audio data, we provide MATLAB code for principal component analysis (PCA) denoising, spectrogram normalization, and Bio-voice Count Index (BCI) calculation.

## Description of the data and file structure

This dataset contains low-pass filtered (0–1 kHz) audio excerpts recorded on July 16, 2023, from coral reef ecosystems near Sanya, China, using a LoPAS-L low-power self-capacitating acoustic recorder (sensitivity: -194 dB re 1 V/μPa; sampling rate: 128 kHz).

### Files and variables

#### File: data.mat

**Description:** 

The `data.mat` file contains a **10-second coral reef acoustic recording** sampled at **128 kHz**, preprocessed for bioacoustic analysis. Key components include:

1\. **time series**:

\- A single-channel waveform vector (length: 1,280,000 samples).

2\. **fs**:

\- Sampling frequency (128,000 Hz) stored as a scalar double.

3\. **metadata**:

\- Struct with anonymized recording context:

Location: South China Sea coral reef

depth: 3m

temperature: 28.5℃

**Usage Example (MATLAB):**

```
y = load('data.mat');
fs = 128000;
pspectrum(y,fs,'spectrogram','FrequencyResolution',90,'OverlapPercent',90,'MinTHreshold',-150); %Draw a time-frequency diagram of this audio
```

#### File: Audio.rar

**Description:** This compressed archive contains **135 one-minute audio recordings** sampled from **Site 10** (a coral reef  in Sanya, China) on **16 July 2023**, between **09:50 and 14:14 local time**. The recordings capture continuous acoustic activity in 5-minute intervals every 10 minutes, segmented into 1-minute files for granular analysis.

**Technical Specifications**:

* **Sampling Rate**: 128 kHz (16-bit depth, WAV format)
* **Frequency Range**: Low-pass filtered to 0–1 kHz to isolate biological sounds (e.g., fish vocalizations) and suppress high-frequency anthropogenic noise.

**Temporal Coverage**:

* **Start Time**: 09:50 (file: `2307160950.wav`)
* **End Time**: 14:14 (file: `2307161414.wav`)
* **Recording Schedule**:
  * 5-minute continuous sampling every 10 minutes (e.g., 09:50–09:55, 10:00–10:05, etc.).
  * Each 5-minute block is split into five 1-minute files.

**File Naming Convention**:

* Filename format: `yymmddhhmm.wav`
  * `yy`: Year (23 for 2023)
  * `mm`: Month (07 for July)
  * `dd`: Day (16)
  * `hh`: Hour (09–14 in 24-hour format)
  * `mm`: Minute (e.g., 50, 00, 10, etc.)
* Example: `2307161130.wav` = 11:30 AM on 16 July 2023.

## Code/software

### **Software Requirements & Workflow Description**

#### **1. Core Software Platform**

* **MATLAB**:
  * **Version**: R2023a (Minimum required)
  * **Toolboxes**:
    * *Signal Processing Toolbox* (For `spectrogram`, `movmean`, audio I/O)
    * *Statistics and Machine Learning Toolbox* (For PCA decomposition)

#### **2. Workflow for Bio-voice Count Index (BCI) Calculation**

##### **Step 1: Data Import**

```
% Load audio file (e.g., '2307161130.wav') 
[y, fs] = audioread('2307161130.wav');  % fs = 128,000 Hz
```

##### **Step 2: Spectrogram PCA Denoising**

Run `spectrogram_pca.m` to reduce noise via PCA decomposition:

```
p = pspectrum(y,fs,'spectrogram','FrequencyResolution',90,'OverlapPercent',90,'MinTHreshold',-150);  
p = p(1:100,:);
% Apply PCA-based denoising (retain 5 components) 
PCA_num = 5; 
[rebuild_spectrogram] = spectrogram_pca(p,PCA_num);
```

**Function**:

* `spectrogram_pca(spectrogram_matrix, count)`:
  * Input: `spectrogram_matrix` (frequency × time), `count` (number of PCA components to retain).
  * Output: Denoised spectrogram matrix.

##### **Step 3: Energy Curve Calculation**

```
% Normalize spectrogram  
n_img = spec_normalize(rebuild_spectrogram);  
% Define frequency weighting (example: emphasize 200–1000 Hz)  
freq_weight = [zeros(20, 3498); ones(80, 3498)];  % Adjust dimensions to match spectrogram  
% Compute weighted energy curve  
energy = sum(n_img .* freq_weight, 1);  
% Smooth energy curve
smoothed_energy = movmean(energy, 10);  
```

**Function**:

* `spec_normalize(spectrogram)`: Normalizes input spectrogram to [0, 1] range.

##### **Step 4: BCI Computation**

```
% Calculate thresholds  
T1 = mean(smoothed_energy); 
T2 = 1.1 * T1;  % User-adjustable multiplier  
% Detect vocalizations and compute BCI 
[voiceseg, BCI, ~, ~] = voicenum(smoothed_energy, T1, T2); 
```

**Function**:

* `voicenum(energy_curve, T1, T2)`:
  * Input: Smoothed energy curve, lower threshold `T1`, upper threshold `T2`.
  * Output: `voiceseg` (vocalization segments), `BCI` (Bio-voice Count Index).

#### **3. Example Usage with Provided Data**

```
load('data.mat');  % Contains preloaded 'y' and 'fs'  
freq_weight = [zeros(20, 3498); ones(80, 3498)];  
PCA_num = 5;  
BCI = Bio_voice(y, fs, freq_weight, PCA_num);  % Output: BCI = 13  
```

#### **4. Script Descriptions**

* **`spectrogram_pca.m`**:
  * Performs PCA on spectrogram matrix columns.
  * Retains top `count` components for noise reduction.
* **`Bio_voice.m`**:
  * Integrates Steps 2–4 into a single function.
  * Key parameters:
    * `freq_weight`: Frequency weighting matrix (user-defined).
    * `PCA_num`: Number of PCA components to retain.

## Access information

No other publicly accessible locations or alternative channels through which the data can be accessed.

No third-party datasets were used or derived in this work.
