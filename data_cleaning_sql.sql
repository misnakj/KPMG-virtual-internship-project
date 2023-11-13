--selecting data base
use kpmg

--CUSTOMER DEMOGRAPHIC TABLE

select *
from customerDemo;

--standardise date format
alter table customerDemo
add dob1 date

update customerDemo
set dob1=convert(date,DOB)

--changing F , M and U into female,male,unspecified
select distinct(gender),count(gender)
from customerDemo
group by gender            --from this code it is clear that there is F ,M and U values and also  'Femal'. Now change it.

update customerDemo
set gender=case when gender='F' then 'Female'
                when gender='M' then 'Male'
				when gender='Femal' then 'Female'
				when gender='U' then 'Unspecified'
				else gender
				end

--looking into job categories
select distinct(job_industry_category),count(job_industry_category)
from customerDemo
group by job_industry_category

select *
from customerDemo;

--looking into wealth_segment
select distinct(wealth_segment),count(wealth_segment)
from customerDemo
group by wealth_segment

--remove duplicates
with RowNumCTE as(
select *,
        row_number() over(
		partition by first_name,
		             last_name,
					 dob1,
					 job_title,
					 tenure
					 order by customer_id) AS row_num
from customerDemo)
select *
from RowNumCTE
where row_num>1   ---there is no duplicates

--drop unwanted columns
alter table customerDemo
drop column default1,DOB,job_title


--CUSTOMER TRANSACTION TABLE

select *
from transactions;

--converting list_price data type into money
alter table transactions
add list_price1 money

update transactions
set list_price1=convert(money,list_price)

--looking into product_line
select distinct(product_line),count(product_line)
from transactions
group by product_line

--remove duplicates
with RowNumCTE as(
select *,
        row_number() over(
		partition by transaction_id,
		              product_id,
					  customer_id,
					  transaction_date,
					  brand,
					  standard_cost
					 order by transaction_id) AS row_num
from transactions)
select *
from RowNumCTE
where row_num>1    --no duplicate data

--DROP UNWANTED COLUMNS
alter table transactions
drop column list_price


--CUSTOMER ADDRESS TABLE
select *
from customerAddress;

--states full names are converting to their abbreviations
select distinct(state),count(state)
from customerAddress
group by state

update customerAddress
set state=case when state='New South Wales' then 'NSW'
               when state='Victoria' then 'VIC'
			   else state
			   end



--JOINING 3 TABLES
select *
from customerDemo as demo
full outer join transactions as trans on Demo.customer_id=trans.customer_id
full outer join customerAddress as addr
on Demo.customer_id=addr.customer_id
