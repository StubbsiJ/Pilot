%% Joshua Stubbs, Feb 2016 (Started)
%  Piloting assist program
%  Test program, real program should be done in Python or other 'real' prgm
clc
clear all
close all

debug = 1;  % To debug program (USES KMSN DATA FROM 24/2 - 2016)

% SO FAR ONLY FIXING FOR USA

startField = 'a'; %INIT
endField = 'a';
gustFlag = 0;

disp('Welcome to the Stubbs Preplanning Procedure')
disp(' ')
disp(' ')
disp(' ')
disp(' ')

if debug == 0
    while length(startField) ~= 4
        startField = input('Where are you taking off from? [4 letter ICAO] >>> ','s');
    end
else
    startField = 'KTST'; % FOR DEBUG 
end

if debug == 0
    while length(endField) ~= 4
        endField = input('Where are you landing? [4 letter ICAO] >>> ','s');
    end
else
    endField = 'KEXP'; % FOR DEBUG 
end
    


if startField(1) == 'K'
    startCountry = 'USA';
else
    startCountry = 'INT';
end


% GET METAR
if debug == 0
    url = strcat('https://aviationweather.gov/adds/metars?station_ids=',...
    startField,...
    '&std_trans=standard&chk_metars=on&hoursStr=most+recent+only&submitmet=Submit');

    metarRAW = urlread(url);
    metarRAWStart = strfind(metarRAW,startField);
    metarRAWEnd = strfind(metarRAW,'</FONT>');
    metar = metarRAW(metarRAWStart:metarRAWEnd-1);
else
    fid = fopen('metar.txt','r');
    tmp4 = fread(fid);
    metar = char(tmp4)';
    fclose(fid);
    clear fid;
    clear tmp4;
end

if startCountry == 'USA'
    tmp1 = strfind(metar,'/'); % multiple instances
    tmp2 = strfind(metar,'SM'); % multiple instances
    
    startWind = metar(strfind(metar,'KT')-8:strfind(metar,'KT')-1);
    startWindDir = str2num(startWind(1:3));
    gustFlag = strfind(startWind,'G');
    startWindSpeed = str2num(startWind(4:5));
    if gustFlag ~= 0
        startWindGust = str2num(startWind(7:8));
    else
        startWindGust = 0;
    end
    
    startVis = metar(tmp2(1)-2:tmp2(1)-1); % multiple instances
    startVis = str2num(startVis);
    
    startTempDP = metar(tmp1(1)-3:tmp1(1)+3); %slash indicates temp
    
    if startTempDP(1) == ' '
        startTemp = str2num(startTempDP(2:3));
    else
        startTemp = -str2num(startTempDP(2:3)); %NEGATIVE TEMP
    end
    
    if startTempDP(5) == 'M'
        tmp3 = 1;
        startDP = -str2num(startTempDP(6:7)); %NEGATIVE DP
    else
        tmp3 = 0;
        startDP = str2num(startTempDP(5:6));
    end
    
    
    startClouds = metar(tmp2(1)+5-2:tmp1(1)-4); %NO NUMBER CONV SO FAR
    
    if tmp3 == 1
        startAltimeter = metar(tmp1(1)+6:tmp1(1)+9);
    else
        startAltimeter = metar(tmp1(1)+5:tmp1(1)+8);
        
    end
    
    startAltimeter = str2num(startAltimeter)/100;    
end

if startCountry == 'INT'
    tmp1 = 0; %HOLDING
end


disp(' ')
disp(' ')
disp(' ')
disp('-----------------METAR-----------------')
fprintf('Wind Direction: %i [degrees magnetic] \n',startWindDir)
fprintf('Wind Speed    : %i [KTS] \n',startWindSpeed)
fprintf('Wind Gust     : %i [KTS] \n',startWindGust)
fprintf('Visability    : %i [SM] \n',startVis)
fprintf('Temperature   : %i [C] \n',startTemp)
fprintf('Dew Point     : %i [C] \n',startDP)
fprintf('Clouds        : %s \n',startClouds)
fprintf('Altimeter     : %2.2f [in. Hg] \n',startAltimeter)


clear tmp1;
clear tmp2;
clear tmp3;
%% STARTING AIRPORT INFORMATION
% Info stored like:

% startRunwayHeading: Contains the magnetic headings of runways at starting
% airport in format [rwy1 rwy1(reci.) rwy2 rwy2(reci.)...]

% startRunwayDimensions: Contains the info about dimensions (feet) of runways at
% starting airport in format [rwy1_length rwy1_width rwy2_length...]

% startRunwayLocation: Contains location of runways at starting airport in
% format Nx2 matrix, where n is number of rwys:
%        [rwy1_lat rwy1_lon
%         rwy1(rec.)_lat rwy1(rec.)_lon
%         rwy2_lat rwy2_lon
%         ................... ]

if debug == 0
    url = strcat('https://www.airnav.com/airport/',startField);
    startInfoRAW = urlread(url);
else
    fid = fopen('startInfoRAW.txt','r');
    tmp4 = fread(fid);
    startInfoRAW = char(tmp4)';
    fclose(fid);
    clear fid;
    clear tmp4;
end

tmp1 = strfind(startInfoRAW,'<H4>Runway ');
tmp1(end+1) = tmp1(end)+4000; %tmp1 now contains all locations of rwys (and to read last)
startRunwayHeading = [];
j = 1;
for i=1:length(tmp1)-1   % FIND HEADINGS OF RUNWAYS
    currentRunwayInfo = startInfoRAW(tmp1(i):tmp1(i+1));
    tmp2 = strfind(currentRunwayInfo,'magnetic');
    startRunwayHeading(j) = str2num(currentRunwayInfo(tmp2(1)-4:tmp2(1)-2));
    j = j + 1;
    startRunwayHeading(j) = str2num(currentRunwayInfo(tmp2(2)-4:tmp2(2)-2));
    j = j + 1;
end


j = 1;
for i=1:length(tmp1)-1   % FIND DIMENSIONS OF RUNWAYS
    currentRunwayInfo = startInfoRAW(tmp1(i):tmp1(i+1));
    tmp2 = strfind(currentRunwayInfo,'Dimensions:');
    dimensions = currentRunwayInfo(tmp2(1)+47:tmp2(1)+56);
    tmp3 = strfind(dimensions,'x');
    startRunwayDimensions(j) = str2num(dimensions(1:tmp3-1));
    j = j + 1;
    startRunwayDimensions(j) = str2num(dimensions(tmp3+1:end));
    j = j + 1;
end

j = 1;
for i=1:length(tmp1)-1   % FIND LATITUDES OF RUNWAYS. ASSUMES USA
    currentRunwayInfo = startInfoRAW(tmp1(i):tmp1(i+1));
    tmp2 = strfind(currentRunwayInfo,'Latitude:');
    latitudes = currentRunwayInfo(tmp2(1)+24:tmp2(1)+67);
    tmp3 = strfind(latitudes,'-');
    tmp4 = latitudes(tmp3(1)-2:tmp3(1)-1);
    tmp4 = str2num(tmp4);
    tmp5 = strcat(latitudes(tmp3(1)+1:tmp3(1)+2),'.',latitudes(tmp3(1)+4:tmp3(1)+9));
    tmp5 = str2num(tmp5)/60;
    startRunwayLocation(j,1) = tmp4+tmp5;
    j = j + 1;
    tmp4 = latitudes(tmp3(1)-2:tmp3(1)-1);
    tmp4 = str2num(tmp4);
    tmp5 = strcat(latitudes(tmp3(2)+1:tmp3(2)+2),'.',latitudes(tmp3(2)+4:tmp3(2)+9));
    tmp5 = str2num(tmp5)/60;
    startRunwayLocation(j,1) = tmp4+tmp5;
    j = j + 1;
end

j = 1;
for i=1:length(tmp1)-1   % FIND LONGITUTES OF RUNWAYS. ASSUMES USA
    currentRunwayInfo = startInfoRAW(tmp1(i):tmp1(i+1));
    tmp2 = strfind(currentRunwayInfo,'Longitude:');
    longitudes = currentRunwayInfo(tmp2(1)+24:tmp2(1)+70);
    tmp3 = strfind(longitudes,'-');
    tmp4 = longitudes(tmp3(1)-2:tmp3(1)-1);
    tmp4 = str2num(tmp4);
    tmp5 = strcat(longitudes(tmp3(1)+1:tmp3(1)+2),'.',longitudes(tmp3(1)+4:tmp3(1)+9));
    tmp5 = str2num(tmp5)/60;
    startRunwayLocation(j,2) = tmp4+tmp5;
    j = j + 1;
    tmp4 = longitudes(tmp3(1)-2:tmp3(1)-1);
    tmp4 = str2num(tmp4);
    tmp5 = strcat(longitudes(tmp3(2)+1:tmp3(2)+2),'.',longitudes(tmp3(2)+4:tmp3(2)+9));
    tmp5 = str2num(tmp5)/60;
    startRunwayLocation(j,2) = tmp4+tmp5;
    j = j + 1;
end

%% Plot starting airport
plotAirport(startWindSpeed,startWindDir,startTemp,startDP,startVis,startRunwayHeading,startRunwayDimensions,startRunwayLocation)