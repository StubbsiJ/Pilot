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

i = 1; %This section does the plotting
j = 1;
hold on
while j<= numberRwys
    rwyWidth = rwyDims(i+1)/10; %Sets visual width in plot
    plot(rwyLocs(i:i+1,2),rwyLocs(i:i+1,1),'k','LineWidth',rwyWidth)
    i = i + 2; %Two entries per runway
    j = j + 1; %Counter 
end

windX(1) = averageLon;
windY(1) = averageLat;
windX(2) = windX(1) + cosd(windDirection)*windSpeed; % end X component of wind
windY(2) = windY(1) + sind(windDirection)*windSpeed; % end Y component of wind

plot(windX(1:2),windY(1:2))


hold off


end


% DOES NOT WORK!!

