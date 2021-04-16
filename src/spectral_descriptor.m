% extract spectrum shape from input autio
% window of 1 seconds
% barkSpectrum input

function [Ffeature] = spectral_descriptor(audioIn, Fs)
    aFE = audioFeatureExtractor('SpectralDescriptorInput','barkSpectrum');
    aFE.Window = hamming(round(Fs*1),"periodic");
    aFE.SampleRate = Fs;


    aFE.spectralCentroid = true;        % 1
    aFE.spectralSpread = true;          % 2
    aFE.spectralSkewness = true;        % 3
    aFE.spectralKurtosis = true;        % 4
    aFE.spectralEntropy = true;         % 5
    aFE.spectralFlatness = true;        % 6
    aFE.spectralCrest = true;           % 7
    aFE.spectralFlux = true;            % 8
    aFE.spectralSlope = true;           % 9
    aFE.spectralDecrease = true;        % 10
    aFE.spectralRolloffPoint = true;    % 11
    %aFE.pitch = true;                   % 12
    %aFE.harmonicRatio = true;           % 13


    features = extract(aFE,audioIn);
    idx = info(aFE);


    spectralCentroid = mean(features(:,idx.spectralCentroid));
    spectralSpread = mean(features(:,idx.spectralSpread));
    spectralSkewness = mean(features(:,idx.spectralSkewness));
    spectralKurtosis = mean(features(:,idx.spectralKurtosis));
    spectralEntropy = mean(features(:,idx.spectralEntropy));
    spectralFlatness = mean(features(:,idx.spectralFlatness));
    spectralCrest = mean(features(:,idx.spectralCrest));
    spectralFlux = mean(features(:,idx.spectralFlux));
    spectralSlope = mean(features(:,idx.spectralSlope));
    spectralDecrease = mean(features(:,idx.spectralDecrease));
    spectralRolloffPoint = mean(features(:,idx.spectralRolloffPoint));
    %pitch = mean(features(:,idx.pitch));
    %harmonicRatio = mean(features(:,idx.harmonicRatio));

    % save 13 spectrum shape features
    Ffeature = [spectralCentroid, spectralSpread, spectralSkewness, spectralKurtosis,...
        spectralEntropy, spectralFlatness, spectralCrest, spectralFlux, ...
        spectralSlope, spectralDecrease, spectralRolloffPoint];

end


