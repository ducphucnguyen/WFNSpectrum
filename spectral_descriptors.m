clc, clear, close
% Narrow band spectrum analysis is implemented for each 10-minute noise
% samples. Basic parameters for spectrum analysis including:
% res = 0.1 Hz, frequency resolution 
% Hanning window with 50 % overlaping
% pwelch function in Matlab is used that automatically apply windowing
% correction.
% Developted by PN Date 9 April 2021 
%%%---------------------------------



% add all utility functions and constants in /src folder
addpath([pwd '/src'])  


%% get all .*pti in a specified folder and subfolders
%foldername = 'R:\CMPH-Windfarm Field Study\Hallett\';
%file_ext = [foldername '/**/*.pti'];
%filelist=dir(file_ext);
%save([pwd '/output/filelist.mat'], 'filelist')
load([pwd '/output/filelist.mat']); % if available read it from output folder

%% Narrow band spectrum analysis

Fs = 8192; % Hz, sampling frequency

SpecShape = zeros(length(filelist),11);
tic
parfor i = 1:length(filelist)

    try
    filename_i = [filelist(i).folder '\' filelist(i).name];
    [channel,~] = f_ptiread(filename_i);

    signals = [channel.Channel_1_Data,...
                channel.Channel_2_Data,...
                channel.Channel_3_Data,...
                channel.Channel_4_Data];

    
    
    SpecShape(i,:) = spectral_descriptor(signals(:,4), Fs);
    
           
    % save results  to the savedir directory              
    %utils.parsave([savedir '\spec-' num2str(i) '.mat'], psd)
    catch
        i
    end
end

savedir = append('R:\CMPH-Windfarm Field Study\Duc Phuc Nguyen\',...
                    '3. Spectrum quantification\Hallett_spectrum_shape');
save([savedir '\specShape.mat'], 'SpecShape');
toc







