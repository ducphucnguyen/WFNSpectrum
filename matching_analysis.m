clc, clear, close
% This code match acoutical measured datetime to power and weather datetime
% The output of this code is a table with three columns each corresponding
% with the row number of acoustical, power and weather data.
% written by PN 10 April 2021
%--------------------------------

% dependency: power and weather data in R-drive!


% add all utility functions and constants in /src folder
addpath([pwd '/src']) 

%% load data
load([pwd '/output/filelist.mat']); % datetime of spectrum

% read power and weather info form R-drive
load('R:\CMPH-Windfarm Field Study\Hallett\Hallett_weather_matched.mat')
load('R:\CMPH-Windfarm Field Study\power data_2018to2019\all_power_data_V6.mat')

%% matching wind farm power ouput, weather

% datime of spectrum, power, weather
spectrumdate(:,1) = datetime([filelist.datenum],'ConvertFrom','datenum');
powerdate = all_Power_V6.DATE_adelaide; % datetime of power data
weatherdate = data10_mached.Ade_date; % datetime of weather data


% find matching index of power and weather data
[index_power, ~] = datematching(spectrumdate, powerdate, minutes(10));
[index_weather, ~] = datematching(spectrumdate, weatherdate, minutes(10));
index_spectrum(:,1) = 1:length(spectrumdate);

matching_index = table(index_spectrum, index_power, index_weather);
%save([pwd '/output/matching_index'], 'matching_index')

%% Plot check matching outcome

% figure()
% scatter(spectrumdate, powerdate(index_power)); grid on
% xlabel('spectrum date');
% ylabel('power date');
% 
% 
% figure()
% [row, ~] = find(~isnan(index_weather));
% scatter(spectrumdate(row), weatherdate(index_weather(row))); grid on
% xlabel('spectrum date');
% ylabel('weather date');














