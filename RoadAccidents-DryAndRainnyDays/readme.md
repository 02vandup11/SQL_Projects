
# 🚦 Road Accident Analysis SQL Project
A full end-to-end SQL project analyzing real-world road accident trends using MySQL.
This project uncovers accident patterns based on city, weather, road type, vehicle faults,
time, and victim demographics.

## 📌 Project Summary
This project analyzes road accident data stored in a relational SQL database using MySQL.
It includes accident data, vehicle data, location details, weather conditions, and victim demographics.

## 🗂️ Dataset Overview
**Database Name:** `road_accidents`  

**ER Daigram**
<img width="1028" height="619" alt="image" src="https://github.com/user-attachments/assets/9803869e-10f7-4845-a18c-d709a40b0882" />


### Tables Included
- **Locations**
- **Weather**
- **Accidents**
- **Vehicles**
- **Victims**

## 🛠️ Tech Stack
- MySQL Workbench  

## 📊 Key Business Questions Answered
- Accident trends by city  
- Weather-based accident patterns  
- Vehicle involvement and fault analysis  
- Time-based accident trends  
- Victim demographics and injury severity  

## 📝 Sample SQL Query
```sql
SELECT City, COUNT(*) AS total_accidents
FROM Accidents a
JOIN Locations l ON a.LocationID = l.LocationID
GROUP BY City
ORDER BY total_accidents DESC;
```


## 🏁 Conclusion
This project demonstrates SQL skills including joins, group by, window functions,
views, and stored procedures for real-world accident analysis.
