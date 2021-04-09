clc, clear, close
% Description here:




% add source codes
addpath([pwd '/src'])  


%% get all .*pti in a specified folder and subfolders
%foldername = 'R:\CMPH-Windfarm Field Study\Hallett\';
%file_ext = [foldername '/**/*.pti'];
%filelist=dir(file_ext);
load([pwd '/output/filelist.mat']);

%% Narrow band spectrum analysis

Fs = 8192; % Hz, sampling frequency
res = 0.1; % Hz, frequency resolution
pref = AcousticsConstants.p_ref; % Pa, reference sound pressure
fftn = round(Fs/res); % number of ffft point
overlap = floor(0.5*fftn);

tic
parfor i = 1:length(filelist)
    try
    filename_i = [filelist(i).folder '\' filelist(i).name];
    [channel,~] = f_ptiread(filename_i);

    signals = [channel.Channel_1_Data,...
                channel.Channel_2_Data,...
                channel.Channel_3_Data,...
                channel.Channel_4_Data];

    % estimate power spectrum density
    [psd,fn] = pwelch(signals,hann(fftn),overlap,fftn,Fs,'psd');
    
    % single precision to save storage
    psd = single(psd);
    savedir = append('R:\CMPH-Windfarm Field Study\Duc Phuc Nguyen\',...
                        '3. Spectrum quantification\Hallett_spectrum_mat');
    % save results                
    utils.parsave([savedir '\spec-' num2str(i) '.mat'], psd)
    catch
        i
    end
end
toc







