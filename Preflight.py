# Joshua Stubbs
# Python 3.3.4
# September 2015 - October 2016
# Pre-flight Script

# Dependencies: 


import time
import datetime
#import urllib
#import urllib.request
import webbrowser
import airportInfo


i = 0

startUTC = (datetime.datetime.utcnow().hour, datetime.datetime.utcnow().minute)
startLocation = 'a' 

print('Welcome Mr.Pilot')
time.sleep(1)
print('Current time (UTC)',startUTC[0],':',startUTC[1])
print("Let's get started!")
print(' ')


while len(startLocation) != 4:
    startLocation = input('Where are you taking off from? [ICAO] >>> ')
    if len(startLocation) != 4:
        print('Please enter 4-character airport code')

if startLocation[0] != 'K': #K marks USA
    internationalFlag = 1
else:
    internationalFlag = 0

print(' ')
print('Stand by')
print(' ')

### START LOCATION ###
airportInfo.extract(startLocation, internationalFlag)
### --- --- --- ###

######################################################################################

# Maps/Charts/etc.

### Sectional


url = 'http://flightaware.com/resources/airport/'+startLocation[1:4]+'/sectional'
webbrowser.open(url)


### PLANNED FEATURE

#TAXI DIAGRAM:

# TO GET TAXI DIAGRAM
url = 'http://flightaware.com/resources/airport/',startLocation[1:4],'/APD/AIRPORT+DIAGRAM/pdf'

#CANNOT DOWNLOAD TAXI DIAGRAM


# Does not work for when an international station is reporting "AUTO" before wind
# contd. Wind readings break down


# Tried to fix for when an airport is not found. Untested

