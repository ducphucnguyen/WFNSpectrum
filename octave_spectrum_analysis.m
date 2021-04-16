clc, clear, close

% Analyse spectrum at 1/3-octave band resolutions
% all spectrum, power, weather are matched and save to big table
% writen by PN 10 April 2021
%-----------------------------


% add all utility functions and constants in /src folder
addpath([pwd '/src']) 

%% Load power and weather data

% read power and weather info form R-drive
load('R:\CMPH-Windfarm Field Study\Hallett\Hallett_weather_matched.mat')
load('R:\CMPH-Windfarm Field Study\power data_2018to2019\all_power_data_V6.mat')
load([pwd '/output/matching_index.mat']); % datetime of spectrum
load([pwd '/output/filelist.mat']); % datetime of spectrum

%% Load narrow band power spectrum density (psd) and calcualte octave band

% initialise arrays and parameters
Fs = 8192;
pref = AcousticsConstants.p_ref; % Pa, reference sound pressure
fn = 0:0.1:Fs/2; % spectrum resolution
Octave_Ch1 = zeros(56364,32);
Octave_Ch2 = zeros(56364,32);
Octave_Ch3 = zeros(56364,32);
Octave_Ch4 = zeros(56364,32);

% source file folder
filedir = append('R:\CMPH-Windfarm Field Study\Duc Phuc Nguyen\',...
                        '3. Spectrum quantification\Hallett_spectrum_mat');

                   
parfor i=1:56364
    try 
    PSD = load([filedir '\spec-' num2str(i) '.mat']);

    [po, fnn] = poctave(PSD.psd,Fs,fn,'BandsPerOctave',3,'FilterOrder',...
                        8,'FrequencyLimits',[3 Fs/2],'psd');

    spl = 20*log10(sqrt(po)/pref);
    Octave_Ch1(i,:) = spl(:,1);
    Octave_Ch2(i,:) = spl(:,2);
    Octave_Ch3(i,:) = spl(:,3);
    Octave_Ch4(i,:) = spl(:,4);
    catch
        i
    end
    
end


%% Combine all data to one table for R analysis

% matched index
index_power = matching_index.index_power;
index_weather = matching_index.index_weather;

% spectrum table
octave_spectrum_tab = array2table(Octave_Ch4);

% power table
power_tab = all_Power_V6(index_power,:);
for ii=1:height(power_tab) % detect duplicated values
    a = power_tab{ii,1};
    if length(a{1}) > 1 % check if have more than 1 sample
        for j=1:9
            aj = power_tab{ii,j};
            power_tab{ii,j} = {aj{1}(1)};
        end 
    end 
end


% weather table
[~, ncol] = size(data10_mached); 
weather_tab = array2table( NaN(length(index_weather), ncol) ); % initialise weather table
weather_tab.Properties.VariableNames = data10_mached.Properties.VariableNames; % copy name
weather_tab.Ade_date = datetime(NaN(length(index_weather),3)); % reassign data type
weather_tab.Date = datetime(NaN(length(index_weather),3)); % reassign data type

[row_valid, ~] = find(~isnan(index_weather)); % find row is not NaN
weather_tab(row_valid,:) = data10_mached(index_weather(row_valid),:); % create weather table


%%% Combine spectrum, power, weather to a big table
Octave_table = [octave_spectrum_tab, power_tab, weather_tab];

%% Save to R-drive for visualisation using R
savedir = 'R:\CMPH-Windfarm Field Study\Duc Phuc Nguyen\3. Spectrum quantification\R_in_out';
writetable(Octave_table,[savedir '\Octave_table.csv'])




