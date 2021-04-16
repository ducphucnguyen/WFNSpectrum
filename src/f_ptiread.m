function [Data,Info] = f_ptiread(filename)
% Read signal from *.pti files
% All channels are read one time and saved to Data
% Info: channel info, datetime and other important info
% Tips: combine with parfor to read multiple *.pti files parallel this will
% reach to speed limit
% This code is addapted and optimised by Phuc D. Nguyen (ducphuc.nguyen@flinders.edu.au)
% from the original code written by Karthik(nkarthikeyan@nal.res.in)
% Version: 0.0.1 (date: 01 March 2021)
% Version: 0.0.2 (date 25 March 2021) - header line number is not
%           consistent with some files (fixed)
%%%---------------------------------->>>>>

fid = fopen(filename);
headerlinecnt=0;
numref = 0;

%% Get all information 
% get header information setup
% first 15 lines are setup info
end_setup = 15;
while (headerlinecnt<end_setup)
     tline=fgetl(fid);
     if strcmp(tline,'[SETUP START]') % find this line
         numref = headerlinecnt + 1;
         end_setup = numref+13;
     end
     
     headerlinecnt=headerlinecnt+1;
     if (headerlinecnt== numref+2)
         k = strfind(tline, '=');
         RECInfoSectionSize = str2double(tline(k+1:end));
     end
     if (headerlinecnt==numref+3)
         k = strfind(tline, '=');
         RECInfoSectionPos = str2double(tline(k+1:end));
     end     
    if (headerlinecnt==numref+4)
         k = strfind(tline, '=');
         SampleFrequency = str2double(tline(k+1:end));
    end 
    if (headerlinecnt==numref+5)
         k = strfind(tline, '=');
         numchannels = str2double(tline(k+1:end));
    end 
    if (headerlinecnt==numref+11)
         k = strfind(tline, '=');
         Sample = str2double(tline(k+1:end));
    end 
    
    if (headerlinecnt==numref+12)
     k = strfind(tline, '=');
     Date = tline(k+1:end);
    end 
    
    if (headerlinecnt==numref+13)
     k = strfind(tline, '=');
     Time = tline(k+1:end);
    end 
    
end


% get channel info
% The most important info is correction factor
channeldetails = struct([]);
for nchann = 1:numchannels
   channeldetails(nchann).tag=fgetl(fid);
   tempstr=fgetl(fid);
   channeldetails(nchann).SignalName=tempstr((strfind(tempstr,'=')+1):end);
    tempstr=fgetl(fid);
   channeldetails(nchann).OrgSignalName=tempstr((strfind(tempstr,'=')+1):end);
    tempstr=fgetl(fid);
   channeldetails(nchann).CorrectionFactor=str2double(tempstr((strfind(tempstr,'=')+1):end));
    tempstr=fgetl(fid);
   channeldetails(nchann).Offset=str2double(tempstr((strfind(tempstr,'=')+1):end));
    tempstr=fgetl(fid);
   channeldetails(nchann).OverloadRatio=str2double(tempstr((strfind(tempstr,'=')+1):end));
    tempstr=fgetl(fid);
   channeldetails(nchann).Unit=tempstr((strfind(tempstr,'=')+1):end);
   tempstr=fgetl(fid);
   channeldetails(nchann).Usecorrection=str2double(tempstr((strfind(tempstr,'=')+1):end));
   tempstr=fgetl(fid);
   channeldetails(nchann).SampleFrequency=str2double(tempstr((strfind(tempstr,'=')+1):end));
   fgetl(fid);
end

Info.channeldetails = channeldetails;
Info.Date = Date;
Info.Time = Time;

%% Read binary data
% Poiter to to main data
% 20 bytes may a subheader which may not important
fseek(fid,(RECInfoSectionPos+RECInfoSectionSize)+20,'bof');

% The size of each segment, it around 250 ms 
% for Fs = 8192 Hz, it is 2048*4 bytes data + 4*4 bytes info (channel id)
dsize=fread(fid,1,'*uint16'); % chunk size (including info) 4 bytes
cols = Sample/(dsize-4)*numchannels;
precision = [num2str(dsize) '*int32'];

% Back to start data
fseek(fid,(RECInfoSectionPos+RECInfoSectionSize)+20,'bof');

% read all data into rawdata and ignore 4 first bytes with info
rawdata = fread(fid,[dsize,cols],precision);
rawdata(1:4,:) = [];

%% Save to actualy 
% Calculate factors for actual Pa, full range is 16 bit system
factor = [channeldetails.CorrectionFactor]/ 2^16;

% Save to Channels
for i=1:numchannels
    Data.(['Channel_' num2str(i) '_Data']) =...
        reshape(rawdata(:,i:numchannels:end),[],1)*factor(i);
end

%toc
fclose(fid);
end

