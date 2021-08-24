
--CLEANING DATA

--STANDARISE DATE FORMAT

SELECT * FROM NashvilleHousing

SELECT SaleDate, CONVERT(date,SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate=CONVERT(date,SaleDate)


SELECT SaleDateConverted, CONVERT(date,SaleDate)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted=CONVERT(date,SaleDate) 

--Populate Property Address

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



-- Full Adress broken down into Address,City,State

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as PropertyAdd, 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as PropertyCity
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertyAdd Nvarchar(255)

UPDATE NashvilleHousing
SET PropertyAdd=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertyCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertyCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

SELECT * FROM PortfolioProject..NashvilleHousing

--OWNER ADDRESS BROKEN DOWN TO DIFFERENT PARTS


SELECT PARSENAME(Replace(OwnerAddress,',','.'),3) as OwnerAdd,
PARSENAME(Replace(OwnerAddress,',','.'),2) as City,
PARSENAME(Replace(OwnerAddress,',','.'),1) as State
FROM PortfolioProject..NashvilleHousing 

ALTER TABLE NashvilleHousing 
ADD OwnerAdd Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerAdd= PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerCity Nvarchar(255)

UPDATE NashvilleHousing 
SET OwnerCity= PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing 
ADD OwnerState Nvarchar(255)

UPDATE NashvilleHousing 
SET OwnerState= PARSENAME(Replace(OwnerAddress,',','.'),1)


----------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='N' THEN 'No'
	WHEN SoldAsVacant='Y' THEN 'Yes'
	ELSE SoldAsVacant
	END
FROM PortfolioProject..NashvilleHousing 


UPDATE NashvilleHousing 
SET SoldAsVacant= CASE WHEN SoldAsVacant='N' THEN 'No'
						WHEN SoldAsVacant='Y' THEN 'Yes'
						ELSE SoldAsVacant
						END




--REMOVE DUPLICATES


WITH RowCTE AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY ParcelID) as Row_num
FROM PortfolioProject..NashvilleHousing)


Select * FROM RowCTE
where Row_num>1



--DELETE 
--FROM RowCTE
--where Row_num>1


--DELETE UNUSED COLUMNS

SELECT * FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, SaleDate, TaxDistrict, PropertyAddress






