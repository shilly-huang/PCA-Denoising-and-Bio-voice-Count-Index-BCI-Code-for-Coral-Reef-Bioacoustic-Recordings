function [rebuild_spectrogram] = spectrogram_pca(spectrogram, count)
warning off;

[coeff, score, ~, ~, explained] = pca(spectrogram');
rebuild_score = zeros(size(score));             

rebuild_score(:, 1:count) = score(:, 1:count);
rebuild_spectrogram = (rebuild_score * coeff')';

end
