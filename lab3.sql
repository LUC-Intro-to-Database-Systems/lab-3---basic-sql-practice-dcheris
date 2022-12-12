--Creating a Database

CREATE DATABASE Lab;


------------------------------------------------------------------
--Creating a table named "CLIENT"

USE Lab;
CREATE TABLE CLIENT (
clientID INT NOT NULL AUTO_INCREMENT,
client_name VARCHAR(55) NOT NULL,
client_address VARCHAR(55) NOT NULL,
client_age INT NOT NULL,
PRIMARY KEY (clientID)
);

------------------------------------------------------------------
--Creating a table named "POLICY"

USE Lab;
CREATE TABLE POLICY (
policyID INT NOT NULL AUTO_INCREMENT,
policyType VARCHAR(55) NOT NULL,
policyTerm VARCHAR(45) NOT NULL,
policyLimits VARCHAR(100) NOT NULL,
PRIMARY KEY (policyID)
);

------------------------------------------------------------------
--Creating a table named "POLICY_LIST"

USE Lab;
CREATE TABLE POLICY_LIST (
CLIENT_clientID INT NOT NULL,
POLICY_policyID INT NOT NULL
);

------------------------------------------------------------------
--Adding (trying to) Composite Key

ALTER TABLE POLICY_LIST ADD PRIMARY KEY (CLIENT_clientID,POLICY_policyID)

------------------------------------------------------------------
--Trying to load data from text files

LOAD DATA LOCAL INFILE '/Users/dominique/github-classroom/LUC-Intro-to-Database-Systems/lab-3---basic-sql-practice-dcheris/client_data.txt' INTO TABLE CLIENT
show global variables like '/Users/dominique/github-classroom/LUC-Intro-to-Database-Systems/lab-3---basic-sql-practice-dcheris/client_data.txt';
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = true;
LOAD DATA LOCAL INFILE '/Users/dominique/github-classroom/LUC-Intro-to-Database-Systems/lab-3---basic-sql-practice-dcheris/client_data.txt' INTO TABLE CLIENT

------------------------------------------------------------------
--Adding data to CLIENT table

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("James Clark", "1001 Plymouth Ave", 38);

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("Leah Nicole", "2401 Chicago Ave", 36);

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("Silas Alexander", "5012 Humboldt Lane", 22);

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("Noah Charles", "501 College Ave", 25);

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("Chris Isaac", "228 e, 149th st.", 37);

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("Noah Charles", "501 College Ave", 25);

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("Brittney Owens", "321 Thursday Ave.", 42);

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("Kurt Douglas", "123 Mt. Glenwood", 58);

INSERT INTO CLIENT (client_name, client_address, client_age)
VALUES ("Areta Farries", "789 Touy Ave.", 62);

INSERT INTO 
	CLIENT(client_name, client_address, client_age)
VALUES
	("Jessica Daniel", "698 Featherstone",47),
	("Gary Moore", "698 Featherstone",48),
	("Elnora Daniel", "698 Featherstone",61),
	("Daniel Moore", "698 Featherstone",22),
	("Cheryl Pearson", "228 e, 149th st.", 67);

------------------------------------------------------------------
--Adding data to POLICY table

 INSERT INTO 
	POLICY(policyType, policyTerm, policyLimits)
VALUES
	("Home", "yearly", "100,000"),
	("Home", "yearly", "250,000"),
	("Home", "yearly", "500,000"),
	("Home", "yearly", "1,000,000"),
	("Home", "6-month", "100,000"),
	("Home", "6-month", "250,000"),
	("Home", "6-month", "500,000"),
	("Home", "6-month", "1,000,000"),
	("Car", "yearly", "60,000"),
	("Car", "yearly", "120,000"),
	("Car", "6-month", "60,000"),
	("Car", "6-month", "120,000")

------------------------------------------------------------------
--Adding data to POLICY_LIST table

INSERT INTO POLICY_LIST
VALUES
	(2,1),
	(9,1),
	(13,1),
	(2,4),
	(5,4),
	(8,5),
	(14,6),
	(11,7),
	(1,8),
	(3,8),
	(7,9),
	(1,10),
	(3,10),
	(7,10),
	(10,10),
	(6,11),
	(4,12)

------------------------------------------------------------------
--SELECT * FROM CLIENT;

------------------------------------------------------------------
--Updating Chris Issac's record

UPDATE CLIENT  
    SET client_name = 'Chris Pearson'
    WHERE clientID = 5;

------------------------------------------------------------------
--Displaying records with "policyType set to "Home"

SELECT * FROM POLICY 
    WHERE policyType = 'Home';

------------------------------------------------------------------
--Displaying records with "policyTerm set to "Yearly"

 SELECT * FROM POLICY 
    WHERE policyTerm = 'Yearly';

------------------------------------------------------------------
--Displaying clients, with client age sorted in descending order

SELECT client_name,client_address, client_age
    FROM CLIENT
    ORDER BY client_age DESC;

------------------------------------------------------------------
--Average age

 SELECT AVG (client_age)
    FROM CLIENT;

------------------------------------------------------------------
--Display client by age range 

 SELECT * FROM CLIENT
    WHERE client_age BETWEEN 22 AND 40;

------------------------------------------------------------------
--Display policyTerms for Home, and policyLimits under $250,000 (Can't get it to work)
SELECT *
    FROM POLICY
    WHERE policyType = "Home" AND policyLimits < "250000";

    SELECT *
    FROM POLICY
    WHERE EXISTS (SELECT policyLimits FROM POLICY WHERE policyLimits < '250,000');

------------------------------------------------------------------
--Display clients with "Featherstone" in address, order by ASC
SELECT client_name,client_address
FROM CLIENT
WHERE client_address LIKE '%Featherstone%' 
ORDER BY client_age ASC;

------------------------------------------------------------------
--Display all clients above the age 35 with an address that contains the number "8"
SELECT client_name,client_address,client_age
FROM CLIENT
WHERE client_age >= 35 AND client_address LIKE '%8%'

------------------------------------------------------------------
--Display total number of policies offered
SELECT COUNT(policyType)
FROM POLICY

------------------------------------------------------------------
--Display policies by type and group
SELECT policyType, COUNT(policyType)
FROM POLICY
GROUP BY policyType;

------------------------------------------------------------------
--Display Youngest to Oldest client age
SELECT MIN(client_age) AS 'Youngest Client' , MAX(client_age) AS 'Oldest Client'
FROM CLIENT

------------------------------------------------------------------
--List all clients that have a home policy
SELECT CLIENT.clientID,CLIENT.client_name,CLIENT.client_address,CLIENT.client_age,POLICY_LIST.CLIENT_clientID,POLICY_LIST.POLICY_policyID,POLICY.policyID
FROM ((POLICY_LIST
INNER JOIN CLIENT ON POLICY_LIST.CLIENT_clientID= CLIENT.clientID)
INNER JOIN POLICY ON POLICY_LIST.POLICY_policyID = POLICY.policyID)
WHERE policyType = "Home";

------------------------------------------------------------------
--INNER JOIN CLIENT TABLE and POLICY_LIST WHERE clientID = 2
SELECT CLIENT.clientID,CLIENT.client_name,CLIENT.client_age,POLICY_LIST.CLIENT_clientID,POLICY_LIST.POLICY_policyID
FROM CLIENT
INNER JOIN POLICY_LIST ON CLIENT.clientID = POLICY_LIST.CLIENT_clientID
WHERE clientID = 2;

------------------------------------------------------------------
--BONUS List all clients along with their respective policies
SELECT CLIENT.clientID,CLIENT.client_name,CLIENT.client_address,CLIENT.client_age,POLICY_LIST.CLIENT_clientID,POLICY_LIST.POLICY_policyID,POLICY.policyID,POLICY.policyType,POLICY.policyTerm,POLICY.policyLimits
FROM ((POLICY_LIST
INNER JOIN CLIENT ON POLICY_LIST.CLIENT_clientID= CLIENT.clientID)
INNER JOIN POLICY ON POLICY_LIST.POLICY_policyID = POLICY.policyID);

------------------------------------------------------------------

