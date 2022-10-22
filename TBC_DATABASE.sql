-- creating a database for epidemiological surveillance of tuberculosis
CREATE DATABASE TBC_surveillance;
USE TBC_surveillance;
-- creating tables
CREATE TABLE Employees (
    Employee_ID INT NOT NULL,
    First_Last_Name VARCHAR(50),
    Duties VARCHAR(50),
    Phone_number INT,
    PRIMARY KEY (Employee_ID)
);

CREATE TABLE Diagnoses (
    ICD_10 VARCHAR(10) NOT NULL,
    Diagnosis VARCHAR(250),
    Category VARCHAR(40),
    PRIMARY KEY (ICD_10)
);

CREATE TABLE Population_age (
    Age_gr_id INT NOT NULL,
    Age_group VARCHAR(30),
    y_2012 INT,
    y_2013 INT,
    y_2014 INT,
    y_2015 INT,
    y_2016 INT,
    y_2017 INT,
    y_2018 INT,
    y_2019 INT,
    y_2020 INT,
    y_2021 INT,
    PRIMARY KEY (Age_gr_id)
);

CREATE TABLE Population_municipality (
    Municipality VARCHAR(30) NOT NULL,
    y_2012 INT,
    y_2013 INT,
    y_2014 INT,
    y_2015 INT,
    y_2016 INT,
    y_2017 INT,
    y_2018 INT,
    y_2019 INT,
    y_2020 INT,
    y_2021 INT,
    PRIMARY KEY (Municipality)
);

CREATE TABLE Population_sex (
    Sex_id VARCHAR(5) NOT NULL,
    Sex VARCHAR(10),
    y_2012 INT,
    y_2013 INT,
    y_2014 INT,
    y_2015 INT,
    y_2016 INT,
    y_2017 INT,
    y_2018 INT,
    y_2019 INT,
    y_2020 INT,
    y_2021 INT,
    PRIMARY KEY (Sex_id)
);

CREATE TABLE Cases2019 (
    Report_number VARCHAR(20) NOT NULL,
    Date_of_receipt DATE,
    HC_institution INT,
    Sex VARCHAR(10),
    Age INT NOT NULL,
    Social_group VARCHAR(40),
    Residence VARCHAR(40) NOT NULL,
    Municipality VARCHAR(40),
    Workplace INT,
    Date_of_diagnosis DATE NOT NULL,
    Diagn_code VARCHAR(8) NOT NULL,
    Disease_outcome VARCHAR(30),
    Death_date DATE,
    Cause_of_death VARCHAR(40),
    Case_investigator INT NOT NULL,
    PRIMARY KEY (Report_number)
);

CREATE TABLE Cases2020 (
    Report_number VARCHAR(20) NOT NULL,
    Date_of_receipt DATE,
    HC_institution INT,
    Sex VARCHAR(10),
    Age INT NOT NULL,
    Social_group VARCHAR(40),
    Residence VARCHAR(40) NOT NULL,
    Municipality VARCHAR(40),
    Workplace INT,
    Date_of_diagnosis DATE NOT NULL,
    Diagn_code VARCHAR(8) NOT NULL,
    Disease_outcome VARCHAR(30),
    Death_date DATE,
    Cause_of_death VARCHAR(40),
    Case_investigator INT NOT NULL,
    PRIMARY KEY (Report_number)
);

-- filling tables with data from csv files via Table Data Import Wizard

SET SQL_SAFE_UPDATES = 0;

-- creating a unique ID number for new employees
ALTER TABLE Employees AUTO_INCREMENT=21;

ALTER TABLE Employees MODIFY Employee_ID int NOT NULL AUTO_INCREMENT;

INSERT INTO Employees (First_Last_Name)
Value ('Angelica Smith');

-- Errors are corrected before the connection between tables is specified
-- Cases tables and Population by sex
SELECT
    Sex_id
FROM
    Population_sex;

SELECT DISTINCT
    Sex
FROM
    Cases2019
WHERE
    Sex NOT IN (SELECT DISTINCT
            Sex_id
        FROM
            Population_sex);

UPDATE Cases2019 
SET 
    Sex = 'F'
WHERE
    Sex = 'Female';

UPDATE Cases2019 
SET 
    Sex = 'M'
WHERE
    Sex = 'Male';

ALTER TABLE Cases2019
   ADD CONSTRAINT FK_Cases2019_PopSex FOREIGN KEY (Sex)
      REFERENCES Population_sex (Sex_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE;

SELECT DISTINCT
    Sex
FROM
    Cases2020
WHERE
    Sex NOT IN (SELECT DISTINCT
            Sex_id
        FROM
            Population_sex);

ALTER TABLE Cases2020
   ADD CONSTRAINT FK_Cases2020_PopSex FOREIGN KEY (Sex)
      REFERENCES Population_sex (Sex_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
-- Errors are then checked using the same principle (not shown).
-- Cases tables and population by municipality

UPDATE Population_municipality
SET Municipality='Vilniaus m.'
WHERE Municipality='Vilniaus m..';


ALTER TABLE Cases2019
   ADD CONSTRAINT FK_Cases2019_PopMunicip FOREIGN KEY (Municipality)
      REFERENCES Population_municipality (Municipality)
      ON DELETE CASCADE
      ON UPDATE CASCADE;

ALTER TABLE Cases2020
   ADD CONSTRAINT FK_Cases2020_PopMunicip FOREIGN KEY (Municipality)
      REFERENCES Population_municipality (Municipality)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
-- Cases tables and Emplyees table

ALTER TABLE Cases2019
   ADD CONSTRAINT FK_Cases2019_Employ FOREIGN KEY (Case_investigator)
      REFERENCES Employees (Employee_ID)
      ON DELETE CASCADE
      ON UPDATE CASCADE;

ALTER TABLE Cases2020
   ADD CONSTRAINT FK_Cases2020_Employ FOREIGN KEY (Case_investigator)
      REFERENCES Employees (Employee_ID)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
      
-- Cases tables and Diagnoses table
UPDATE Cases2019 
SET 
    Diagn_code = 'A15.0'
WHERE
    Diagn_code = 'A15';

UPDATE Cases2019 
SET 
    Diagn_code = 'A18.0'
WHERE
    Diagn_code = 'A18';

UPDATE Cases2019 
SET 
    Diagn_code = 'A19.0'
WHERE
    Diagn_code = 'A19';

ALTER TABLE Cases2019
   ADD CONSTRAINT FK_Cases2019_Diagn FOREIGN KEY (Diagn_code)
      REFERENCES  Diagnoses (ICD_10)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
	
UPDATE Cases2020 
SET 
    Diagn_code = 'A18.0'
WHERE
    Diagn_code = 'A18';

DELETE FROM Cases2020 
WHERE
    Diagn_code NOT IN (SELECT DISTINCT
        ICD_10
    FROM
        Diagnoses);

ALTER TABLE Cases2020
   ADD CONSTRAINT FK_Cases2020_Diagn FOREIGN KEY (Diagn_code)
      REFERENCES  Diagnoses (ICD_10)
      ON DELETE CASCADE
      ON UPDATE CASCADE;

-- Cases tables and population by age
ALTER TABLE Cases2019
ADD COLUMN Age_gr_id INT;

UPDATE Cases2019
	SET Age_gr_id = CASE
		WHEN Age <= 17 THEN 1
		WHEN Age BETWEEN 18 AND 24 THEN 2
		WHEN Age BETWEEN 25 AND 34 THEN 3
		WHEN Age BETWEEN 35 AND 44 THEN 4
		WHEN Age BETWEEN 45 AND 54 THEN 5
		WHEN Age BETWEEN 55 AND 64 THEN 6
		WHEN Age BETWEEN 65 AND 74 THEN 7
		WHEN Age BETWEEN 75 AND 84 THEN 8
		WHEN Age >= 85 THEN 9
END;

ALTER TABLE Cases2019
   ADD CONSTRAINT FK_Cases2019_Age FOREIGN KEY (Age_gr_id)
      REFERENCES  Population_age (Age_gr_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE;

ALTER TABLE Cases2020
ADD COLUMN Age_gr_id INT;

UPDATE Cases2020 
SET 
    Age_gr_id = CASE
        WHEN Age <= 17 THEN 1
        WHEN Age BETWEEN 18 AND 24 THEN 2
        WHEN Age BETWEEN 25 AND 34 THEN 3
        WHEN Age BETWEEN 35 AND 44 THEN 4
        WHEN Age BETWEEN 45 AND 54 THEN 5
        WHEN Age BETWEEN 55 AND 64 THEN 6
        WHEN Age BETWEEN 65 AND 74 THEN 7
        WHEN Age BETWEEN 75 AND 84 THEN 8
        WHEN Age >= 85 THEN 9
    END;

ALTER TABLE Cases2020
   ADD CONSTRAINT FK_Cases2020_Age FOREIGN KEY (Age_gr_id)
      REFERENCES  Population_age (Age_gr_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
-- Separation of cases into urban and rural

CREATE TABLE Cities (
    City VARCHAR(50) NOT NULL,
    PRIMARY KEY (City)
);

INSERT INTO Cities (City)
VALUES 
("Elektrėnai"),
("Vievis"),
("Baltoji Vokė"),
("Eišiškės"),
("Šalčininkai"),
("Širvintos"),
("Pabradė"),
("Švenčionėliai"),
("Švenčionys"),
("Lentvaris"),
("Rūdiškės"),
("Trakai"),
("Ukmergė"),
("Nemenčinė"),
("Grigiškės"),
("Vilnius");

ALTER TABLE Cases2019
ADD COLUMN Residence_type VARCHAR(30);

UPDATE Cases2019 
SET 
    Residence_type = CASE
        WHEN
            Residence IN (SELECT 
                    city
                FROM
                    cities)
        THEN
            'Urban'
        ELSE 'Rural'
    END;

ALTER TABLE Cases2020
ADD COLUMN Residence_type VARCHAR(30);

UPDATE Cases2020 
SET 
    Residence_type = CASE
        WHEN
            Residence IN (SELECT 
                    city
                FROM
                    cities)
        THEN
            'Urban'
        ELSE 'Rural'
    END;

-- creating a table and adding data on the population in urban and rural areas
CREATE TABLE Population_Resrd_type (
    Res_Type VARCHAR(50) NOT NULL,
    y_2012 INT,
    y_2013 INT,
    y_2014 INT,
    y_2015 INT,
    y_2016 INT,
    y_2017 INT,
    y_2018 INT,
    y_2019 INT,
    y_2020 INT,
    y_2021 INT,
    PRIMARY KEY (Res_Type)
);

INSERT INTO Population_Resrd_type (Res_Type, y_2012, y_2013, y_2014, y_2015, y_2016, y_2017, y_2018, y_2019, y_2020, y_2021)
VALUES
("Urban", 629869,	632383,	633652,	635732,	635174,	635086,	635886,	639871,	648916,	656121),
("Rural", 176046,	173925,	172454,	171791,	170206,	170087,	169481,	170667,	171595,	173862);

-- finding and correcting logical errors in Cases column "Social group"
SELECT 
    Age, Social_group
FROM
    Cases2019
WHERE
    Social_group = 'Student' AND Age > 25;

UPDATE Cases2019 
SET 
    Social_group = 'needs clarification'
WHERE
    Social_group = 'Student' AND Age > 25;

SELECT 
    Age, Social_group
FROM
    Cases2020
WHERE
    Social_group = 'Student' AND Age > 25;

-- causes of death are unified
SELECT DISTINCT
    Cause_of_death
FROM
    Cases2019;

UPDATE Cases2019 
SET 
    Cause_of_death = 'TBC'
WHERE
    Cause_of_death IN("tub", "A15.0", "tuberculosis", "nuo tbc");
    
UPDATE Cases2019 
SET 
    Cause_of_death = 'NOT TBC'
WHERE
    Cause_of_death IN("not tbc", "other diseases");
    
UPDATE Cases2019 
SET 
    Cause_of_death = 'needs clarification'
WHERE
    Death_date IS NOT NULL
        AND Cause_of_death NOT IN("TBC", "NOT TBC");

SELECT DISTINCT
    Cause_of_death
FROM
    Cases2020;
    
    UPDATE Cases2020
SET 
    Cause_of_death = 'TBC'
WHERE
    Cause_of_death IN("A15.0", "tuberculosis");

UPDATE Cases2020
SET 
    Cause_of_death = 'NOT TBC'
WHERE
    Cause_of_death = 'cancer';

-- converting empty cells to null
UPDATE Cases2019 
SET 
    Disease_outcome = NULL
WHERE NOT
    Disease_outcome = 'died';
    
UPDATE Cases2020
SET 
    Disease_outcome = NULL
WHERE NOT
    Disease_outcome = 'died';
    
UPDATE Cases2020
SET 
    Cause_of_death = NULL
WHERE
    Cause_of_death NOT IN ('TBC', 'NOT TBC');
    
UPDATE Cases2019 
SET 
    Cause_of_death = NULL
WHERE
    Cause_of_death NOT IN ('NOT TBC' , 'needs clarification', 'TBC');
    
-- connecting 2019 and 2020 cases tables
CREATE TEMPORARY TABLE Cases2019_2020 (
SELECT 
    Report_number,
    Age_gr_id,
    Sex,
    Municipality,
    Date_of_diagnosis,
    Diagn_code
FROM
    Cases2019 
UNION 
SELECT 
	Report_number,
    Age_gr_id,
    Sex,
    Municipality,
    Date_of_diagnosis,
    Diagn_code
FROM
    Cases2020);
    
ALTER TABLE Cases2019_2020
ADD Year_diagnosis INT;

UPDATE Cases2019_2020 
SET 
    Year_diagnosis = YEAR(Date_of_diagnosis);

ALTER TABLE Cases2019_2020
ADD Month_diagnosis INT;

UPDATE Cases2019_2020 
SET 
   Month_diagnosis = MONTH(Date_of_diagnosis);
SELECT * FROM Cases2019_2020;

ALTER TABLE Cases2019_2020
   ADD CONSTRAINT FK_Cases1920_tbctype FOREIGN KEY (Diagn_code)
      REFERENCES Diagnoses (ICD_10)
      ON DELETE CASCADE
      ON UPDATE CASCADE;
      
-- creating a table with cases grouped by year of diagnosis, month of diagnosis, TBC type, age group, sex, municipality
CREATE TEMPORARY TABLE Cases19_20_DIAGNTYPE (
SELECT Cases2019_2020.Report_number, Cases2019_2020.Age_gr_id, Cases2019_2020.Sex, Cases2019_2020.Municipality, 
Diagnoses.Category, Cases2019_2020.Year_diagnosis, Cases2019_2020.Month_diagnosis
FROM Cases2019_2020
LEFT JOIN Diagnoses ON Cases2019_2020.Diagn_code=Diagnoses.ICD_10);


CREATE TABLE Cases2019_2020_GROUPED
SELECT COUNT(Report_number) AS Number_of_cases, Age_gr_id, Sex, Municipality, Category AS TBC_type , Year_diagnosis, Month_diagnosis 
FROM Cases19_20_DIAGNTYPE
GROUP BY Age_gr_id, Sex, Municipality, TBC_type, Year_diagnosis, Month_diagnosis
ORDER BY Year_diagnosis, Month_diagnosis;

-- incidence rate by municipality and month in 2019
CREATE TEMPORARY TABLE Cases_municipal (SELECT SUM(Number_of_cases) AS Number_of_cases, Municipality, 
Month_diagnosis FROM Cases2019_2020_GROUPED WHERE Year_diagnosis = 2019 GROUP BY Municipality, Month_diagnosis);

CREATE TEMPORARY TABLE Pop_municip_19 (SELECT Municipality, y_2019 FROM Population_municipality);

CREATE TABLE Incidence_by_municip_2019(
SELECT Cases_municipal.Number_of_cases, Cases_municipal.Municipality, Cases_municipal.Month_diagnosis, Pop_municip_19.y_2019 AS Population
FROM Cases_municipal
LEFT JOIN Pop_municip_19 ON Cases_municipal.Municipality=Pop_municip_19.Municipality);

ALTER TABLE Incidence_by_municip_2019
ADD Incidence DEC(10, 2);

UPDATE Incidence_by_municip_2019
SET Incidence = ((Number_of_cases / Population) * 100000);

