-- Import Nashville Housing Data dataset

SELECT *
FROM HousingData..house_data;



-- Change Date format and store in new column

SELECT SaleDate, CONVERT(date,SaleDate)
FROM HousingData..house_data;

ALTER TABLE HousingData..house_data
ADD Sale_Date date;

UPDATE HousingData..house_data
SET Sale_Date = CONVERT(date,SaleDate);

SELECT *
FROM HousingData..house_data;



-- Populate PropertyAddress data at the Null values based on ParcelID and UniqueID

SELECT *
FROM HousingData..house_data
WHERE PropertyAddress IS NULL
ORDER BY ParcelID ;


SELECT a.ParcelID, a.PropertyAddress ,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData..house_data a
JOIN HousingData..house_data b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL ;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData..house_data a
JOIN HousingData..house_data b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL ;



-- Extract Address, City from PropertyAddress 

SELECT PropertyAddress
FROM HousingData..house_data ;


SELECT 
SUBSTRING( PropertyAddress, 1, CHARINDEX( ',', PropertyAddress )-1 ) AS Address,
SUBSTRING( PropertyAddress, CHARINDEX( ',', PropertyAddress )+1, LEN( PropertyAddress) ) AS City
FROM HousingData..house_data ;


ALTER TABLE HousingData..house_data
ADD Property_Address NVARCHAR(255),
	Property_City NVARCHAR(255);


UPDATE HousingData..house_data
SET Property_Address = SUBSTRING( PropertyAddress, 1, CHARINDEX( ',', PropertyAddress )-1 ),
	Property_City = SUBSTRING( PropertyAddress, CHARINDEX( ',', PropertyAddress )+1, LEN( PropertyAddress) ) ;


SELECT *
FROM HousingData..house_data;



-- Extract Address, City, State from  OwnerAddress

SELECT OwnerAddress
FROM HousingData..house_data ;


SELECT
PARSENAME( REPLACE( OwnerAddress, ',', '.' ), 1 ) AS state,
PARSENAME( REPLACE( OwnerAddress, ',', '.' ), 2 ) AS city,
PARSENAME( REPLACE( OwnerAddress, ',', '.' ), 3 ) AS address
FROM HousingData..house_data ;


ALTER TABLE HousingData..house_data
ADD Owner_Address NVARCHAR(255),
	Owner_City NVARCHAR(255),
	Owner_State NVARCHAR(255) ;


UPDATE HousingData..house_data
SET Owner_Address = PARSENAME( REPLACE( OwnerAddress, ',', '.' ), 3 ) ,
	Owner_City = PARSENAME( REPLACE( OwnerAddress, ',', '.' ), 2 ) ,
	Owner_State = PARSENAME( REPLACE( OwnerAddress, ',', '.' ), 1 ) ;


SELECT *
FROM HousingData..house_data ;



-- Assign Y and N to YES and NO in 'SoldAsVacant' column

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingData..house_data
GROUP BY SoldAsVacant
ORDER BY 2 ;


UPDATE HousingData..house_data 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END ;

SELECT *
FROM HousingData..house_data ;



-- Remove Duplicate Rows by using ROW_NUMBER()

WITH RowNumCTE AS (
SELECT *,
	   ROW_NUMBER() OVER ( 
	   PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate
					ORDER BY UniqueID ) row_num	
FROM HousingData..house_data 
) 
DELETE
FROM RowNumCTE
WHERE row_num > 1 ;


SELECT *
FROM HousingData..house_data ;



-- delete undesired column

ALTER TABLE HousingData..house_data
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict ;

SELECT *
FROM HousingData..house_data ;
