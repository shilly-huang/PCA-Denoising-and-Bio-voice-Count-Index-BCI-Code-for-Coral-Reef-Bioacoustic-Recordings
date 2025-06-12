function BCI = Bio_voice(y,fs, freq_weight,PCA_num)
%%
% function:
%     Bio_voice
% 
% inputs:
%     x             : Audio signals to be processed.
%
%     fs            : Sampling frequency.
%
%     freq_weights  : Target sample feature extraction weights vector at frequency domin.
%                     
%     PCA_num       : Number of principal components to be taken after PCA treatment.
%
% outputs:
%     BCI           : Number of bio-voice.
% 
% example:
%     inputs:
%        y=load('data.mat');
%        fs=128000;
%        freq_weight = [zeros(20,3498); ones(80,3498)];
%        PCA_num=5;
%     outputs:
%        Number of bio-voice is 13.

p=pspectrum(y,fs,'spectrogram','FrequencyResolution',90,'OverlapPercent',90,'MinTHreshold',-150);
p=p(1:100,:);
[rebuild_spectrogram] = spectrogram_pca(p,PCA_num);
power_per_frame = sum(spec_normalize(rebuild_spectrogram).* freq_weight);
mov_power_per_frame=movmean(power_per_frame,10);

T1=mean(mov_power_per_frame);
T2=T1*1.1;
[voiceseg,BCI,~,~]=voicenum(mov_power_per_frame,T1,T2);
fprintf('Number of bio-voice is %d.\n',BCI);
end
