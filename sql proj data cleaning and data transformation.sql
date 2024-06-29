-- data cleaning --
use ecomm;

-- Handling Missing Values and Outliers: 
-- Impute mean for the following columns, and round off to the nearest integer if required: WarehouseToHome, HourSpendOnApp, 
-- OrderAmount HikeFromlastYear, DaySinceLastOrder. 
select * from customer_churn;

select round(avg(warehousetohome))as avgwhh from customer_churn;
select round(avg(HourSpendOnApp)) as hsonapp from customer_churn;
select round(avg(orderamounthikefromlastyear)) as order_amount_hikeyear from customer_churn;
select round(avg(daysincelastorder)) as lorder from customer_churn;
-- Impute mode for the following columns: Tenure, CouponUsed, OrderCount.

select count(tenure) as mode_tenure from customer_churn group by tenure order by tenure desc limit 1;
select count(CouponUsed) as mode_coupon from customer_churn group by CouponUsed order by couponused desc limit 1;
select count(ordercount) as mode_order from customer_churn group by ordercount  order by ordercount desc limit 1;

-- Handle outliers in the 'WarehouseToHome' column by deleting rows where the values are greater than 100.
set sql_safe_updates=0;
delete from customer_churn
where WarehouseToHome > 100; /* two rows changed*/

-- Dealing with Inconsistencies: 
-- 1) Replace occurrences of “Phone” in the 'PreferredLoginDevice' column and “Mobile” in the 'PreferedOrderCat' column with “Mobile Phone”
-- to ensure uniformity. 
set sql_safe_updates = 0;
update customer_churn
set preferredlogindevice = 'phone'
where preferredlogindevice like '%phone%'; /* changes occrues*/
select * from customer_churn;

set sql_safe_updates = 0;
update customer_churn
set PreferedOrderCat = 'mobile'
where preferedordercat like '%phone%'; /* 1270 rows  matched changes occrues*/
select * from customer_churn;

-- 2) Standardize payment mode values: Replace "COD" with "Cash on Delivery" and "CC" with "Credit Card" in the
-- PreferredPaymentMode column.
set sql_safe_updates = 0;
update customer_churn
set Preferredpaymentmode = 'cash on delivery'
where preferredpaymentmode like 'cod'; /* 365 rows changed*/
select * from customer_churn;

set sql_safe_updates = 0;
update customer_churn
set Preferredpaymentmode = 'credit card'
where preferredpaymentmode like 'cc'; /* 273 rows changed*/
select * from customer_churn;

-- Data Transformation 
-- Column Renaming 
-- Rename the column "PreferedOrderCat" to "PreferredOrderCat".
-- Rename the column "HourSpendOnApp" to "HoursSpentOnApp". 

alter table customer_churn
rename column PreferedOrderCat to PreferredOrderCat;
select * from customer_churn;
alter table customer_churn
rename column HourSpendOnApp to HoursSpentOnApp;
select * from customer_churn;

-- Creating New Columns: 
-- Create a new column named ‘ComplaintReceived’ with values "Yes" if the corresponding value in the ‘Complain’ is 1, and
-- "No" otherwise. 

alter table customer_churn
add column complaintreceived varchar(10);

update complaintreceived
set complaintreceived = case when complain =1 then 'yes' else 'no' end; /* 5628 rows changed changes occrues */

select * from customer_churn;
-- Create new column named 'ChurnStatus'. Set its value to “Churned” if the corresponding value in the 'Churn' column is 1, 
-- else assign “Active”. 
alter table customer_churn
add column churnstatus varchar(20);

update customer_churn
set churnstatus = case when churn = 1 then 'churned' else 'active' end; /* 5628 rows changed*/

select * from customer_churn;
-- Column Dropping: 
-- Drop the columns "Churn" and "Complain" from the table. 

alter table customer_churn
drop column churn,
drop column complain;
select * from customer_churn;














 