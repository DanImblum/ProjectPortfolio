
--Adding a SaleDateConverted column to convert SaleDate column to Date Type

-- Selects SaleDateConverted and converts SaleDate to a Date data type.
-- This query retrieves two columns from the NashvilleHousing table in the ProjectPortfolio database.
SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM ProjectPortfolio.dbo.NashvilleHousing;

-- Updates the SaleDate column in the NashvilleHousing table to store Date data.
-- This query modifies the existing SaleDate column by converting its values to Date data type.
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

-- Adds a new column named SaleDateConverted to the NashvilleHousing table.
-- This SQL statement alters the structure of the NashvilleHousing table by adding a new column called SaleDateConverted with a Date data type.
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

-- Updates the SaleDateConverted column with Date values based on the SaleDate column.
-- This query updates the newly added SaleDateConverted column by converting values from the existing SaleDate column to Date data type.
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);


--Finding rows with no property address and assigning them a property address by self joining tables and using Parcel ID

-- Selects all columns from the NashvilleHousing table where PropertyAddress is null.
-- This query retrieves all rows from the NashvilleHousing table in the ProjectPortfolio database where the PropertyAddress column is null, and it orders the result by ParcelID.
SELECT *
FROM ProjectPortfolio.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

-- Selects specific columns and combines PropertyAddress values from two rows with the same ParcelID.
-- This query joins the NashvilleHousing table with itself (aliased as 'a' and 'b') on ParcelID, and it selects ParcelID, PropertyAddress from both rows. The ISNULL function combines PropertyAddress values from 'a' and 'b' into a single column 'Newaddy'.
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) AS Newaddy
FROM ProjectPortfolio.dbo.NashvilleHousing a
JOIN ProjectPortfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

-- Updates the PropertyAddress column with non-null values from the joined rows.
-- This query updates the PropertyAddress column in the 'a' table by setting it to the non-null value from either 'a.PropertyAddress' or 'b.PropertyAddress' where PropertyAddress in 'a' is null. It's based on the join condition where ParcelID matches and UniqueID is different.
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM ProjectPortfolio.dbo.NashvilleHousing a
JOIN ProjectPortfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;



--Breaking out Address into Individual Columns (address, City, State)

-- Selects a substring of PropertyAddress from the start to the first comma (',') as Address
-- and another substring from the character after the first comma to the end as Address.
-- This query extracts the address and city information from the PropertyAddress column.
SELECT
  Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
  Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
FROM ProjectPortfolio.dbo.NashvilleHousing;

-- Adds a new column named PropertySplitAddress to the NashvilleHousing table.
-- This SQL statement alters the structure of the NashvilleHousing table by adding a new column called PropertySplitAddress.
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

-- Updates the PropertySplitAddress column with the extracted address information.
-- This query sets the values in the PropertySplitAddress column by extracting the address portion from the PropertyAddress column.
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

-- Adds a new column named PropertySplitCity to the NashvilleHousing table.
-- This SQL statement alters the structure of the NashvilleHousing table by adding a new column called PropertySplitCity.
ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

-- Updates the PropertySplitCity column with the extracted city information.
-- This query sets the values in the PropertySplitCity column by extracting the city portion from the PropertyAddress column.
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

--Updating Owner Address to split address using ParseName Method

-- Selects the address, city, and state components from the OwnerAddress column.
-- This query uses the ParseName function to extract the 3rd, 2nd, and 1st components (from right to left) of the OwnerAddress column after replacing commas with periods.
SELECT 
  ParseName(Replace(OwnerAddress, ',', '.'), 3) as Address,
  ParseName(Replace(OwnerAddress, ',', '.'), 2) as City,
  ParseName(Replace(OwnerAddress, ',', '.'), 1) as State
FROM ProjectPortfolio.dbo.NashvilleHousing;

-- Adds new columns for OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState to the NashvilleHousing table.
-- These ALTER TABLE statements add three new columns to the NashvilleHousing table, each of type NVARCHAR(255).
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255),
    OwnerSplitCity NVARCHAR(255),
    OwnerSplitState NVARCHAR(255);

-- Updates the newly added columns with the parsed components from OwnerAddress.
-- This UPDATE statement uses the ParseName function to extract the address, city, and state components from the OwnerAddress column and sets them in the corresponding newly added columns.
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET OwnerSplitAddress = ParseName(Replace(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = ParseName(Replace(OwnerAddress, ',', '.'), 2),
    OwnerSplitState = ParseName(Replace(OwnerAddress, ',', '.'), 1);

-- Alters the data type of the OwnerSplitState column to NVARCHAR(255).
-- This ALTER TABLE statement modifies the data type of the OwnerSplitState column to NVARCHAR(255), presumably to match the data type of the other newly added columns.
ALTER TABLE NashvilleHousing
ALTER COLUMN OwnerSplitState NVARCHAR(255);

-- Change Y and N to Yes and N in "Sold as Vacant" field

-- Query to create a new column with mapped 'Yes' or 'No' values based on 'SoldAsVacant' values.
SELECT
  SoldAsVacant,
  CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
  END AS UpdatedSoldAsVacant
FROM ProjectPortfolio.dbo.NashvilleHousing;

-- Query to update the 'SoldAsVacant' column with mapped 'Yes' or 'No' values.
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET SoldAsVacant =
  CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
  END;



--Remove Duplicates

-- Create a Common Table Expression (CTE) named RowNumCTE.
WITH RowNumCTE AS (
  -- Select all columns from the NashvilleHousing table.
  -- Additionally, assign a unique row number to each row within partitions.
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
      ORDER BY UniqueID
    ) AS row_num
  FROM ProjectPortfolio.dbo.NashvilleHousing
)

-- Delete rows from the CTE where row_num is greater than 1.
-- This keeps only the first row within each partition of identical values
-- in the specified columns and deletes duplicates.
-- The rows to be retained are determined by the ORDER BY clause.
DELETE
FROM RowNumCTE
WHERE Row_num > 1
-- Order the rows before applying the deletion, here by PropertyAddress.
ORDER BY PropertyAddress;




WITH RowNumCTE AS (
Select *,
ROW_NUMBER() OVER (
Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate, 
				LegalReference
				ORDER BY 
				UniqueID
				) as row_num

From ProjectPortfolio.dbo.NashvilleHousing


)
Select *
From RowNumCTE
where Row_num > 1
Order by PropertyAddress

