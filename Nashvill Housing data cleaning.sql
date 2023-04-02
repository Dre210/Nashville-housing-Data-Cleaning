--------------------------------------------------------------------------------------------------------------------------------------------

---Cleaning Nashvile Data in SQL Queries

--------------------------------------------------------------------------------------------------------------------------------------------


select *
from dbo.Nashville

-------------------------------------------------------------------------------------------------------------------------------------------

--- Standardize Date Format

select SaleDate, cast(SaleDate as date)          
from dbo.Nashville


Alter table dbo.Nashville
add converted_saledate date

update dbo.Nashville
set converted_saledate =cast(SaleDate as date)

---Alter table dbo.Nashville
---drop column converted_saledate


------------------------------------------------------------------------------------------------------------------------------------

------Populate Property Address data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from dbo.Nashville a
join dbo.Nashville b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress =isnull(a.PropertyAddress, b.PropertyAddress)
from dbo.Nashville a
join dbo.Nashville b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <>b.[UniqueID ]
where a.PropertyAddress is null



-----------------------------------------------------------------------------------------------------------------------------------

----- Breaking out Address into Individual Columns (Address, City, State)

select
left(PropertyAddress, CHARINDEX(',', PropertyAddress)-1),
right(PropertyAddress,len(PropertyAddress)-len(left(PropertyAddress, CHARINDEX(',', PropertyAddress))))
from dbo.Nashville

Alter table dbo.Nashville
add Property_Address nvarchar(255)

--alter table dbo.Nashville
--drop column Property_Address

update dbo.Nashville
set Property_Address =left(PropertyAddress, CHARINDEX(',', PropertyAddress)-1)


Alter table dbo.Nashville
add property_city nvarchar(255)

update dbo.Nashville
set property_city =right(PropertyAddress,len(PropertyAddress)-len(left(PropertyAddress, CHARINDEX(',', PropertyAddress)))) 



--------------------------------------------------------------------------------------------------------------------------------------
 
-- Breaking out Address into Individual Columns (Address, City, State)

 select * --OwnerAddress
from dbo.Nashville

select
left(OwnerAddress, charindex(',',  OwnerAddress)-1), 
right(OwnerAddress,len(OwnerAddress)- len(left(OwnerAddress, charindex(',', OwnerAddress))))
from dbo.Nashville

alter table dbo.Nashville
add owner_address nvarchar(255)

update dbo.Nashville
set owner_address =left(OwnerAddress, charindex(',',  OwnerAddress)-1)
from dbo.Nashville 

alter table dbo.Nashville
add owner_city nvarchar(255)

update dbo.Nashville
set owner_city =right(OwnerAddress,len(OwnerAddress)- len(left(OwnerAddress, charindex(',', OwnerAddress))))
from dbo.Nashville

select 
left(owner_city, CHARINDEX(',',owner_city)-1),
right(owner_city, len(owner_city)-len(left(owner_city, CHARINDEX(',',owner_city))))
from dbo.Nashville

alter table dbo.Nashville
add ownercity nvarchar(255)

update dbo.Nashville
set ownercity =left(owner_city, CHARINDEX(',',owner_city)-1)

alter table dbo.Nashville
add Ownercitycode nvarchar(255)

update dbo.Nashville
set Ownercitycode =right(owner_city, len(owner_city)-len(left(owner_city, CHARINDEX(',',owner_city))))

--alter table dbo.Nashville
--drop column owner_city



---------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from dbo.Nashville
group by SoldAsVacant



select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
      ELSE SoldAsVacant 
      end
from dbo.Nashville

update dbo.Nashville
set SoldAsVacant =case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
      ELSE SoldAsVacant 
      end


	  select * 
	  from dbo.Nashville



--------------------------------------------------------------------------------------------------------------------------------------------

------ Remove Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From dbo.Nashville)
--order by ParcelID

select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



--------------------------------------------------------------------------------------------------------------------------------------------

-----Remove unused columns

      select * 
	  from dbo.Nashville


alter table dbo.Nashville
drop column owner_city, property_city, PropertyAddress, SaleDate, OwnerAddress


