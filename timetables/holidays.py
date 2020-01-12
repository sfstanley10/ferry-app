#Python code to create an array of string dates of the Dutch National Holidays in 2020
import json
monthsDict = {"Januari": "01", "Febuari": "02", "Maart": "03", "April": "04", "Mei": "05", "Juni": "06", "Juli": "07", "Augustus": "08", "September": "09", "Oktober": "10", "November": "11", "December": "12"}

holidays2020=[]
with open("Dutch Holidays 2020.txt","r") as f:
    f = f.readlines()
    for line in f:
        data = line.split()
        if len(data) < 3:
            continue
        year = data[-1]
        month = data[-2]
        day = data[-3]
        monthDigits = monthsDict[month]
        if len(day) < 2:
            day = "0"+day 
        date = year + "-" + monthDigits + "-" + day
        holidays2020+=[date]
print (holidays2020)



with open ("holidays2020.json", "w") as f:
    json.dump(holidays2020, f)



  
