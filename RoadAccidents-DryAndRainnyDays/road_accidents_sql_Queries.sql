use road_accidents;

-- Basic Checks (Sanity Queries)
USE road_accidents;

-- View Tables
SHOW TABLES;

-- Count rows
SELECT COUNT(*) AS total_locations FROM Locations;
SELECT COUNT(*) AS total_weather   FROM Weather;
SELECT COUNT(*) AS total_accidents FROM Accidents;
SELECT COUNT(*) AS total_vehicles  FROM Vehicles;
SELECT COUNT(*) AS total_victims   FROM Victims;

-- Peek at some data
SELECT * FROM Accidents LIMIT 10;
SELECT * FROM Locations LIMIT 10;
SELECT * FROM Weather LIMIT 10;

-- Total Accidents by City
SELECT 
    l.City,
    COUNT(a.AccidentID) AS total_accidents
FROM Accidents a
JOIN Locations l ON a.LocationID = l.LocationID
GROUP BY l.City
ORDER BY total_accidents DESC;

-- Accident Count by Road Type
SELECT 
    l.RoadType,
    COUNT(a.AccidentID) AS total_accidents
FROM Accidents a
JOIN Locations l ON a.LocationID = l.LocationID
GROUP BY l.RoadType
ORDER BY total_accidents DESC;

-- Severity Distribution
SELECT 
    Severity,
    COUNT(*) AS total_cases,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Accidents), 2) AS percentage_share
FROM Accidents
GROUP BY Severity
ORDER BY total_cases DESC;

-- Weather Impact: Dry vs Rainy
SELECT 
    w.ConditionType,
    COUNT(a.AccidentID) AS total_accidents
FROM Accidents a
JOIN Weather w ON a.WeatherID = w.WeatherID
GROUP BY w.ConditionType;

-- severity under each condition
SELECT 
    w.ConditionType,
    a.Severity,
    COUNT(*) AS total_cases
FROM Accidents a
JOIN Weather w ON a.WeatherID = w.WeatherID
GROUP BY w.ConditionType, a.Severity
ORDER BY w.ConditionType, total_cases DESC;

-- Peak Accident Time
SELECT 
    HOUR(Time_) AS hour_of_day,
    COUNT(*) AS total_accidents
FROM Accidents
GROUP BY HOUR(Time_)
ORDER BY total_accidents DESC;

-- Vehicles: Type vs Damage
SELECT 
    Type_ AS vehicle_type,
    DamageLevel,
    COUNT(*) AS total_vehicles
FROM Vehicles
GROUP BY Type_, DamageLevel
ORDER BY vehicle_type, total_vehicles DESC;

-- faulty vehicles in fatal accidents
SELECT 
    v.Type_ AS vehicle_type,
    COUNT(*) AS faulty_vehicles_in_fatal
FROM Vehicles v
JOIN Accidents a ON v.AccidentID = a.AccidentID
WHERE v.IsFaulty = TRUE
  AND a.Severity = 'Fatal'
GROUP BY v.Type_
ORDER BY faulty_vehicles_in_fatal DESC;

-- Victim Demographics: Role & Injury
SELECT 
    Role,
    InjurySeverity,
    COUNT(*) AS total_victims
FROM Victims
GROUP BY Role, InjurySeverity
ORDER BY Role, total_victims DESC;

-- Average age by severity
SELECT 
    a.Severity,
    ROUND(AVG(v.Age), 1) AS avg_age
FROM Victims v
JOIN Accidents a ON v.AccidentID = a.AccidentID
GROUP BY a.Severity
ORDER BY a.Severity;

-- Accidents by Day of Week
SELECT 
    DAYNAME(Date_) AS day_name,
    COUNT(*) AS total_accidents
FROM Accidents
GROUP BY DAYNAME(Date_)
ORDER BY total_accidents DESC;

-- Weekend vs Weekday Accidents
SELECT 
    CASE 
        WHEN DAYOFWEEK(Date_) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_accidents
FROM Accidents
GROUP BY day_type;

-- Temperature vs Severity
SELECT 
    CASE 
        WHEN w.Temperature < 15 THEN 'Cold'
        WHEN w.Temperature BETWEEN 15 AND 30 THEN 'Moderate'
        ELSE 'Hot'
    END AS temp_category,
    a.Severity,
    COUNT(*) AS total_cases
FROM Accidents a
JOIN Weather w ON a.WeatherID = w.WeatherID
GROUP BY temp_category, a.Severity
ORDER BY temp_category, total_cases DESC;

-- Faulty vs Non-Faulty Vehicles by Type
SELECT 
    Type_ AS vehicle_type,
    SUM(CASE WHEN IsFaulty = TRUE THEN 1 ELSE 0 END) AS faulty_count,
    SUM(CASE WHEN IsFaulty = FALSE THEN 1 ELSE 0 END) AS non_faulty_count,
    COUNT(*) AS total_vehicles
FROM Vehicles
GROUP BY Type_
ORDER BY faulty_count DESC;

-- Gender vs Injury Severity
SELECT 
    Gender,
    InjurySeverity,
    COUNT(*) AS total_victims
FROM Victims
GROUP BY Gender, InjurySeverity
ORDER BY Gender, total_victims DESC;

-- View 1: City-wise summary
CREATE VIEW vw_city_accident_summary AS
SELECT 
    l.City,
    COUNT(a.AccidentID) AS total_accidents,
    SUM(CASE WHEN a.Severity = 'Fatal' THEN 1 ELSE 0 END) AS fatal_accidents,
    SUM(CASE WHEN a.Severity = 'Major' THEN 1 ELSE 0 END) AS major_accidents,
    SUM(CASE WHEN a.Severity = 'Minor' THEN 1 ELSE 0 END) AS minor_accidents
FROM Accidents a
JOIN Locations l ON a.LocationID = l.LocationID
GROUP BY l.City;

SELECT * FROM vw_city_accident_summary ORDER BY fatal_accidents DESC;



