/*
-- Standardised Date Formate
-- change the text to date first then further format the date
SELECT SaleDate, DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %d, %Y'),'%Y-%m-%d' )AS NewDate
FROM `freecodecamp`.`nashville housing data for data cleaning`;

-- set sql safe as safe mode on so UPDATE rows without WHERE statement is not allowed
SET SQL_SAFE_UPDATES = 0;

UPDATE `freecodecamp`.`nashville housing data for data cleaning`
SET SaleDate = DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %d, %Y'),'%Y-%m-%d' );

SET SQL_SAFE_UPDATES = 1;


SELECT *
FROM `freecodecamp`.`nashville housing data for data cleaning`;

--
*/

/*
-- Property Address
SELECT *
FROM `freecodecamp`.`nashville housing data for data cleaning`
WHERE ParcelID in ( SELECT ParcelID FROM `freecodecamp`.`nashville housing data for data cleaning` WHERE PropertyAddress ='');

SELECT a.UniqueID, a.ParcelID, a.PropertyAddress, b.UniqueID, b.ParcelID, b.PropertyAddress, IF(a.PropertyAddress='',b.PropertyAddress,b.PropertyAddress)
FROM `freecodecamp`.`nashville housing data for data cleaning` a
JOIN (SELECT * FROM `freecodecamp`.`nashville housing data for data cleaning` )  b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress="";

--Answer Below--
--Need to use UPDATE JOIN as MySQL doesnt allow updating table which is also querying it with FROM
UPDATE `freecodecamp`.`nashville housing data for data cleaning` a 
JOIN 
	( 	SELECT *
		FROM `freecodecamp`.`nashville housing data for data cleaning` 
	) b
        ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
SET	a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress="";

*/

/*
-- Spliting Address into City, State

SELECT PropertyAddress, SUBSTRING_INDEX(PropertyAddress,",",1) AS Street, SUBSTRING_INDEX(PropertyAddress,",",-1) AS STATE
FROM `freecodecamp`.`nashville housing data for data cleaning`;

ALTER TABLE `freecodecamp`.`nashville housing data for data cleaning`
ADD PropertySplitAddress varchar(255);

UPDATE `freecodecamp`.`nashville housing data for data cleaning`
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress,",",1);

ALTER TABLE `freecodecamp`.`nashville housing data for data cleaning`
ADD PropertySplitCity varchar(255);

UPDATE `freecodecamp`.`nashville housing data for data cleaning`
SET PropertySplitCity = SUBSTRING_INDEX(PropertyAddress,",",-1);

*/

/*
-- Splitting owner address
SELECT SUBSTRING_INDEX(OwnerAddress,",",1) AS Street,SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,",",-2),",",1) AS City, SUBSTRING_INDEX(OwnerAddress,",",-1) AS State
FROM `freecodecamp`.`nashville housing data for data cleaning`;

ALTER TABLE `freecodecamp`.`nashville housing data for data cleaning`
ADD OwnerSplitAddress varchar(255);

UPDATE `freecodecamp`.`nashville housing data for data cleaning`
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress,",",1);

ALTER TABLE `freecodecamp`.`nashville housing data for data cleaning`
ADD OwnerSplitCity varchar(255);

UPDATE `freecodecamp`.`nashville housing data for data cleaning`
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,",",-2),",",1);

ALTER TABLE `freecodecamp`.`nashville housing data for data cleaning`
ADD OwnerSplitState varchar(255);

UPDATE `freecodecamp`.`nashville housing data for data cleaning`
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress,",",-1);

*/

/*
-- Change Y & N to Yes & No

SELECT SoldAsVacant
From `freecodecamp`.`nashville housing data for data cleaning`
group by SoldAsVacant;

UPDATE `freecodecamp`.`nashville housing data for data cleaning`
SET SoldAsVacant = 
CASE	WHEN SoldAsVacant = 'Y' THEN "Yes"
		WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
END 

*/

/*
-- Remove Duplicate

WITH DUPLICATECTE AS (
SELECT *,
row_number() OVER	(
PARTITION BY 	ParcelID,
				SalePrice,
                SaleDate,
                LegalReference
                ORDER BY
					UniqueID
                    ) AS row_num
From `freecodecamp`.`nashville housing data for data cleaning`
)


DELETE `freecodecamp`.`nashville housing data for data cleaning`
FROM `freecodecamp`.`nashville housing data for data cleaning`
JOIN DUPLICATECTE ON DUPLICATECTE.UniqueID = `freecodecamp`.`nashville housing data for data cleaning`.UniqueID
WHERE row_num > 1

*/

/*
-- Delete unused columns

SELECT *
From `freecodecamp`.`nashville housing data for data cleaning`;

ALTER TABLE  `freecodecamp`.`nashville housing data for data cleaning`
DROP COLUMN OwnerAddress, 
DROP COLUMN PropertyAddress, 
DROP COLUMN TaxDistrict
*/


