clc, clear, close

% This code is written to run on Deepthought
%% Load narrow band power spectrum density (psd) and calcualte octave band

% initialise arrays and parameters
Fs = 8192;
pref = 20e-6; %AcousticsConstants.p_ref; % Pa, reference sound pressure
fn = 0:0.1:Fs/2; % spectrum resolution
num_spec = 1000; % full is 56364
Narrow_Ch4 = zeros(num_spec,40961); %(56364, 4096)

% source file folder
filedir = append('R:\CMPH-Windfarm Field Study\Duc Phuc Nguyen\',...
                        '3. Spectrum quantification\Hallett_spectrum_mat');

                   
parfor i=1:num_spec
    %try 
    PSD = load([filedir '\spec-' num2str(i) '.mat']);
    ch4 = PSD.psd(:,4);
    spl = 20*log10(sqrt(ch4)/pref);
    Narrow_Ch4(i,:) = spl;
    %catch
        i
    %end
    
end


%% Save to R-drive for visualisation using R
savedir = 'R:\CMPH-Windfarm Field Study\Duc Phuc Nguyen\3. Spectrum quantification\R_in_out';
save([savedir '\allCh4_spec.mat'],'Narrow_Ch4')




