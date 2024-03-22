-- Keep a log of any SQL queries you execute as you solve the mystery.
-- find the csar report
SELECT *
FROM crime_scene_reports
WHERE month = 07 AND day = 28 AND year = 2021 AND street ="Humphrey Street";
-- tell about there are 3 interviews done that mention the thief. Theft occur at 10:15

SELECT *
FROM interviews
WHERE year = 2021 AND month = 07 AND day = 28;
--Ruth: Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away.
--If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.
--Eugene
-- I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery,
--I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
--Raymond
--As the thief was leaving the bakery, they called someone who talked to them for less than a minute.
--In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
--The thief then asked the person on the other end of the phone to purchase the flight ticket

--Find the license_plate that the thief drive away from bakery
CREATE temp TABLE bakery_car_plate AS
SELECT *
FROM bakery_security_logs
WHERE year = 2021 AND month = 07 AND day = 28 AND hour = 10 AND minute > 14 AND minute <=25;

--thief there withdrawing some money.
SELECT *
FROM atm_transactions
WHERE year = 2021 AND month = 07 AND day = 28 AND atm_location = "Leggett Street";

--call log from thieft to partner

SELECT *
FROM phone_calls
WHERE year = 2021 AND day = 28 AND month = 07 AND duration <60;

--Find the abbreviation of Fuftyville airport
SELECT *
FROM airports
WHERE city = "Fiftyville";

--Finf the earliest flight flight ID = 36
SELECT id
FROM flights
WHERE year = 2021 AND month = 07 AND day = 29 ORDER by hour LIMIT 1;

-- find all the passenger on board that flight by passport number
SELECT passport_number
FROM passengers
WHERE flight_id = (SELECT id
FROM flights
WHERE year = 2021 AND month = 07 AND day = 29 ORDER by hour LIMIT 1);

-- find the name, license plate and phone number of all on board passenger by using their passport number
CREATE temp TABLE passenger_table AS
SELECT *
FROM people
WHERE passport_number IN (SELECT passport_number
FROM passengers
WHERE flight_id = (SELECT id
FROM flights
WHERE year = 2021 AND month = 07 AND day = 29 ORDER by hour LIMIT 1));

--Find the person info based on bakery captured car plate
CREATE temp TABLE suspect_after_car_plate AS
SELECT *
FROM passenger_table
WHERE passenger_table.license_plate IN (SELECT license_plate FROM bakery_car_plate);

--Find the person info based on bakery captured car plate and phone log
--CREATE temp TABLE suspect_after_car_plate_and_call_log AS
CREATE temp TABLE suspect_after_car_plate_and_call_log AS
SELECT *
FROM suspect_after_car_plate
WHERE suspect_after_car_plate.phone_number IN (SELECT phone_calls.caller FROM phone_calls WHERE year = 2021 AND day = 28 AND month = 07 AND duration <60);

-- find the account holder name from the ATM record
CREATE temp TABLE atm_person_id AS
SELECT DISTINCT (person_id)
FROM bank_accounts, atm_transactions
WHERE bank_accounts.account_number = atm_transactions.account_number AND year = 2021 AND month = 07 AND day = 28 AND atm_location = "Leggett Street";

-- Find the person info from atm_person_id
CREATE temp TABLE atm_person_info AS
SELECT *
FROM people
WHERE people.id in (SELECT * FROM atm_person_id);

--Find the theif who fit the atm, car plate and phoe call criteria
SELECT *
FROM suspect_after_car_plate_and_call_log
WHERE suspect_after_car_plate_and_call_log.id IN (SELECT id FROM atm_person_info);

-- find the flight that the thief take and hence the city fly to
SELECT city
FROM people, passengers, flights, airports
WHERE people.passport_number = passengers.passport_number AND passengers.flight_id = flights.id AND airports.id = flights.destination_airport_id AND people.name = "Bruce";

-- find the accomplice by check the phone lock
SELECT name
FROM people
WHERE phone_number = (
SELECT receiver
FROM phone_calls, people
WHERE people.phone_number = phone_calls.caller AND people.name = "Bruce" AND year = 2021 AND day = 28 AND month = 07 AND duration <60);
