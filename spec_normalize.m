function n_img = spec_normalize(spectrogram)
    n_img = (spectrogram - min(min(spectrogram))) ./ (max(max(spectrogram)) - min(min(spectrogram)));
end