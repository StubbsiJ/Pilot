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


#custom scripts
import airportInfo

i = 0

startUTC = (datetime.datetime.utcnow().hour, datetime.datetime.utcnow().minute)

print('Welcome Mr.Pilot') #Welcome message
time.sleep(1)
print('Current time (UTC)',startUTC[0],':',startUTC[1])
print("Let's get started!")
print(' ')

###########################    MAIN    ###############################################
def main():
    selection = input('1: Enter start location       2: Enter end location \n >>> ')

    if selection == 1:
        startLocation = airportInfo.run()
    elif selection == 2:
        endLocation = airportInfo.run()
    else:
        print('\n \n \n Invalid selection, try again! \n \n \n ')

######################################################################################

while True:
    main()

######################################################################################


### PLANNED FEATURES
# Maps/Charts/etc.

### Sectional


#url = 'http://flightaware.com/resources/airport/'+startLocation[1:4]+'/sectional'
#webbrowser.open(url)




#TAXI DIAGRAM:

# TO GET TAXI DIAGRAM
#url = 'http://flightaware.com/resources/airport/',startLocation[1:4],'/APD/AIRPORT+DIAGRAM/pdf'

#CANNOT DOWNLOAD TAXI DIAGRAM


# Does not work for when an international station is reporting "AUTO" before wind
# contd. Wind readings break down


# Tried to fix for when an airport is not found. Untested

