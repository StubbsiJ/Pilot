%% Script to plot starting environment
%  Takes input from Piloting.m

% INPUTS:
% Wind Speed
% Wind Direction
% Wind Gust
% Air Temperature
% Air Dew Point
% Visability
% Runway Headings vector
% Runway Dimensions vector
% Runway Locations vector


% OUTPUTS:
% Plot


%% DO STUFF
function plotAirport(windSpeed,windDirection,gust,temperature,dewPoint,visability,rwyHeads,rwyDims,rwyLocs)

numberRwys = length(rwyHeads)/2;

averageLat = mean(rwyLocs(:,1));
averageLon = mean(rwyLocs(:,2));

lat2ft = vdist(averageLat+0.5,averageLon,averageLat-0.5,averageLon)*3.2808399; %1 degree lat to feet
lon2ft = vdist(averageLat,averageLon+0.5,averageLat,averageLon-0.5)*3.2808399; %1 degree lon to feet

i = 1; %This section does the plotting
j = 1;
subplot(1,2,1)
title('Airport Diagram')
xlabel('Longitude')
ylabel('Latitude')
hold on
while j<= numberRwys
    rwyWidth = rwyDims(i+1)/10; %Sets visual width in plot
    plot(rwyLocs(i:i+1,2),rwyLocs(i:i+1,1),'k','LineWidth',rwyWidth) %Set axes equal??? <------------
    i = i + 2; %Two entries per runway
    j = j + 1; %Counter 
end

subplot(2,2,2)


windX(1) = cosd(windDirection)*windSpeed; % X component of wind
windY(1) = sind(windDirection)*windSpeed; % Y component of wind
windX(2) = cosd(windDirection)*gust; % X component of gust
windY(2) = sind(windDirection)*gust; % Y component of gust

compass(windX,windY) % ROTATE axes <------------------------------------
title('Wind')
xlabel('Direction (broken)')
hold off


end


