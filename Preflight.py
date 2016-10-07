# Joshua Stubbs
# Python 3.3.4
# September 2015 - October 2016
# Pre-flight Script



import time
import datetime
import urllib
import urllib.request



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

url = 'https://aviationweather.gov/adds/metars?station_ids='+startLocation+'&std_trans=standard&chk_metars=on&hoursStr=most+recent+only&submitmet=Submit'
f = urllib.request.urlopen(url)
html = f.read()
f.close()
metarStr = html.decode("utf-8")

url = 'http://weather.gladstonefamily.net/site/'+startLocation
f = urllib.request.urlopen(url)
html = f.read(9000)
f.close()
addInfo = html.decode("utf-8")

if metarStr.find('Sorry, either there are no data available') > 1:
    internationalFlag = -1


airportNameLoc = addInfo.find('Weather Station')
airportName = addInfo[airportNameLoc+24:addInfo.find('"/',airportNameLoc)]

startAltitude = addInfo[addInfo.find('Elevation:')+11:addInfo.find('Elevation')+15]
i = 3 #length of alt. reading
while i>0:
    if startAltitude[i] == ' ':
        startAltitude = startAltitude[0:i]
        break
    i = i - 1

fieldElevation = float(startAltitude)*3.2808399

metarStart = metarStr.find(startLocation) #finds beginning of metar message
metarEnd = metarStr.find('<',metarStart) #finds end of metar message
metarText = metarStr[metarStart:metarEnd] #extraxts metar message

if internationalFlag == 0: #Yankee airports
    metarWind = metarText[metarText.find('KT')-8:metarText.find('KT')]
    metarVis = metarText[metarText.find('SM')-2:metarText.find('SM')]
    metarTemp = metarText[metarText.find('/')-3:metarText.find('/')]
    metarDP = metarText[metarText.find('/')+1:metarText.find('/')+4]
    metarClouds = metarText[metarText.find('SM')+3:metarText.find('/')-3]
    metarAlt = metarText[metarText.find('A',20)+1:metarText.find('A',20)+5]

    
if internationalFlag == 1: #International airports
    metarTemp = metarText[metarText.find('/')-3:metarText.find('/')]
    metarDP = metarText[metarText.find('/')+1:metarText.find('/')+4]
    metarWind = metarText[13:21]
    if metarText.find('CAVOK') == -1:
        metarClouds = metarText[metarText.find('KT')+8:metarText.find('/')-3]
    else:
        metarClouds = 'CAVOK'
    metarAlt = metarText[metarText.find('Q',20)+1:metarText.find('Q',20)+5]
    if metarText.find('9999') != -1:
        metarVis = 'Unlimited'
    else:
        metarVis = 'Unknown'
if internationalFlag == -1:
    print('No airport data available')

gustingFlag = metarWind.find('G')

if gustingFlag != -1:
    metarWindSpeed = metarWind[3:8]
    metarWindDir = metarWind[0:3]
else:
    if internationalFlag == 0:
        metarWindSpeed = metarWind[6:8]
        metarWindDir = metarWind[3:6]
    else:
        metarWindDir = metarWind[0:3]
        metarWindSpeed = metarWind[3:5]


if metarTemp[0] == 'M': #If negative temp
    metarTemp = metarTemp[1:3]
    metarTemp = -float(metarTemp)
else:
    metarTemp = float(metarTemp)


if metarDP[0] == 'M': #If negative dewpoint
    metarDP = metarDP[1:3]
    metarDP = -float(metarDP)
else:
    metarDP = float(metarDP)

print(' ')
print(' ')
print(' ')
print('Departure:')
print(airportName)
print(' ')
print('---------METAR----------')
print('Temperature:',metarTemp,'C')
print('Dew Point:',metarDP,'C')
if internationalFlag == 0:
    print('Visibiliy:',metarVis,'SM')
else:
    print('Visibility:',metarVis)
print('Clouds:',metarClouds)
print('Wind Direction:',metarWindDir,'Magnetic')
print('Wind Speed:',metarWindSpeed,'KTS')
if internationalFlag == 0:
    print('Altimiter:',metarAlt,'inHg')
else:
    print('Altimiter:',metarAlt,'hPa')
print('-------------------------')




#Density Altitude
pressureISA = 29.92126 #inHg
pressureISAhPa = 1013.25 #hPa
tempTrue = float(metarTemp)+273.15 #K
tempTrueC = tempTrue-273.15 #C
tempTrueF = tempTrue*(9/5)-459.67 #F
pressureTrue = float(metarAlt)/100
pressureTruehPa = 33.8639*(pressureTrue/10)*10
tempISA = 288.15 #K
tempISAC = 15 #C
tempLapse = 0.0065 #K/m
R = 8.32432 #J/molK
g = 9.80665 #m/ss
airMolar = 0.0289644 #kg/mol

if internationalFlag == 1:
    pressureTrue = pressureTrue*0.0295333727*100

pressureAltitude = int((pressureISA-pressureTrue)*1000 + fieldElevation)
densityAltitude = pressureAltitude+(120*(tempTrueC-tempISAC))

print('Density Altitude:',densityAltitude,'feet')
print('Difference from field elevation:',int(densityAltitude-fieldElevation),'feet')

######################################################################################

# Maps/Charts/etc.

### Sectional



### PLANNED FEATURE

#TAXI DIAGRAM:

# TO GET TAXI DIAGRAM
url = 'http://flightaware.com/resources/airport/',startLocation[1:4],'/APD/AIRPORT+DIAGRAM/pdf'

#CANNOT DOWNLOAD TAXI DIAGRAM


# Does not work for when an international station is reporting "AUTO" before wind
# contd. Wind readings break down


# Tried to fix for when an airport is not found. Untested

