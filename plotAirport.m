%% Script to plot starting environment
%  Takes input from Piloting.m

% INPUTS:
% Runway Lengths
% Runway Widths
% Runway Locations

% OUTPUTS:
% Plot


%% DO STUFF
function plotAirport(windSpeed,windDirection,temperature,dewPoint,visability,rwyHeads,rwyDims,rwyLocs)

numberRwys = length(rwyHeads)/2;

averageLat = mean(rwyLocs(:,1));
averageLon = mean(rwyLocs(:,2));

lat2ft = vdist(averageLat+0.5,averageLon,averageLat-0.5,averageLon)*3.2808399; %1 degree lat to feet
lon2ft = vdist(averageLat,averageLon+0.5,averageLat,averageLon-0.5)*3.2808399; %1 degree lon to feet

i = 1;
j = 1;
while i<= numberRwys
    lat(j) = rwyLocs(i,1);
    lon(j) = rwyLocs(i,2);
    for j=2:100
        lat(j) = lat(j-1)+lat(j-1)*sind(rwyHeads((2*i)-1));
        lon(j) = lon(j-1)+lon(j-1)*cosd(rwyHeads((2*i)-1));
    end
    scatter(lat,lon)
    i = i + 1;
end

% DOES NOT WORK!!

