import json
import os
import pdftotext
import re

def getFerryName(pdfLines):
    return pdfLines[0].split()[1]

def getDeparturePoint(pdfLines):
    # find the first line that has the 3 digit ferry name
    firstLine = [line for line in pdfLines if bool(re.search(r'9\d\d', line))][0]
    # since we've got a ton of whitespace in this pdf
    # use regex to split the string on >2 spaces so we know
    # if the departure point is two words
    return re.split(r'\s{2,}', firstLine)[2]

def getDepartureTimes(pdfLines, departurePoint):
    departures = filter(lambda x: (x.startswith(departurePoint)), pdfLines)
    
    times = []
    for line in departures:
        timesInLine = line.replace(departurePoint, "").split()
        times.extend(timesInLine)
    return times

def createDeparturesDictionary(times):
    timeDictionaries = []
    for time in times:
        components = time.split(":", 1)
        timeDictionary = { "hour" : components[0], "minute" : components[1] }
        timeDictionaries.append(timeDictionary)
    return timeDictionaries

ferries = []
for file in os.listdir("."):
    if not file.endswith(".pdf"):
        continue
    with open(file, "rb") as f:
        pdf = pdftotext.PDF(f)
    print(file)
    lines = pdf[0].splitlines() #TODO(ss): probably want to go through all pages
    name = getFerryName(lines)
    departurePoint = getDeparturePoint(lines)
    times = getDepartureTimes(lines, departurePoint)

    jsonDictionary = {
      "name": name,
      "departurePoint": { "name": departurePoint, "location": "" },
      "daysOfTheWeek": ["monday", "tuesday", "wednesday", "thursday", "friday"],
      "departureTimes": times
    }
    ferries.append(jsonDictionary)

with open('ferry_timetable.json', 'w') as jsonFile:
    json.dump(ferries, jsonFile, indent=2, sort_keys=False)
