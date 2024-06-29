-- Data Exploration and Analysis
use ecomm;
-- 1
 select churnstatus,count(*) as countchurn from customer_churn
 group by churnstatus; /* churned 948,active 4680*/
 -- 2
 select avg(tenure) as avgtenureofchurned from customer_churn
 where churnstatus = 'churned';/* avg 3.3795*/
 -- 3
 select sum(cashbackamount) as sumamountofchurnedcustomer from customer_churn
 where churnstatus = 'churned'; /* sum 152030*/
-- 4
select (count(case when complaintreceived = 'yes' then 1 end )*100.0 )/count(case when churnstatus = 'churned' then 1 end)as percentage
 from customer_churn;
-- select;
-- 5 
select gender,count(complaintreceived) from customer_churn group by gender; /* female 2246,male 3382*/
-- 6
select max(citytier) as maximum from customer_churn where churnstatus = 'churned' and PreferredOrderCat = 'Laptop & Accessory';
/* maximum tier 3*/
-- 7
select max(preferredpaymentmode) as maximumpaymentin from customer_churn where Churnstatus = 'active';
/* upi mode preffering */
-- 8
select max(preferredlogindevice) as preffered from customer_churn
where DaySinceLastOrder > 10; /* phone*/
-- 9
select count(churnstatus) as listactivehoursspend from customer_churn
where churnstatus = 'active' and HoursSpentOnApp >'3'; /* 981 active customers spend time more than 3hour*/
-- 10
select CustomerID,avg(cashbackamount) from customer_churn where HoursSpentOnApp >= '2' group by customerid;
use ecomm;
-- 11
SELECT preferredordercat,max(hoursspentonapp) as maximumhoursspend from customer_churn group by preferredordercat; 
-- 12
select maritalstatus,avg(orderamounthikefromlastyear) as avgamountfromlastyear from customer_churn group by MaritalStatus;
-- 13 
select PreferredOrdercat,sum(orderamounthikefromlastyear) as totalamount from customer_churn 
where MaritalStatus = 'single' and PreferredOrderCat like ('%mobile%')
group by PreferredOrdercat;
-- 14
select PreferredPaymentMode,avg(numberofdeviceregistered)as avgcustomer from customer_churn where PreferredPaymentMode = 'upi'group by PreferredPaymentMode;
-- 15
select max(citytier) from customer_churn where CustomerID > (select count(CustomerID)from customer_churn);
-- 16
select MaritalStatus,max(NumberOfAddress) as highestaddress from customer_churn group by MaritalStatus order by maritalstatus desc limit 1;
-- 17
select gender, max(CouponUsed) from customer_churn  group by gender order by gender limit 1 ;
-- 18
select preferredordercat,avg(satisfactionscore) from customer_churn group by PreferredOrderCat;
-- 19
select PreferredPaymentMode,sum(ordercount)as totalscore ,max(satisfactionscore) as moresatisfied from customer_churn 
group by PreferredPaymentMode 
order by PreferredPaymentMode desc limit 1; 
-- 20
select count(*) as totalcustomer from customer_churn where HoursSpentOnApp = 1 and DaySinceLastOrder > 5;
-- 21
select avg(satisfactionscore) as avgscoreforcomplaint from customer_churn where complaintreceived = 'yes';
-- 22
select PreferredOrderCat,count(CustomerID) from customer_churn group by PreferredOrderCat;
-- 23
select avg(cashbackamount) as avgcashamountformarried from customer_churn where MaritalStatus = 'married';
-- 24
SELECT AVG(numberofdeviceregistered) AS average_devices
FROM (
    SELECT customerid,COUNT(numberofdeviceregistered) AS number_of_devices
    FROM customer_churn
    WHERE preferredordercat != 'mobile'
    GROUP BY customerid
) AS filtered_customers;
-- 25
select PreferredOrderCat, count(CustomerID) as morethan5coupounused from customer_churn where couponused > 5 
group by PreferredOrderCat;
-- 26
select preferredordercat,max(cashbackamount) as top3catogeory from customer_churn group by PreferredOrderCat 
order by PreferredOrderCat desc limit 3; 
-- 27 
SELECT ordercount,preferredpaymentmode, COUNT(*) AS mode_count
FROM customer_churn
WHERE tenure = 10 AND ordercount > 500
GROUP BY preferredpaymentmode,OrderCount
ORDER BY OrderCount desc;
-- 28
select case when warehousetohome <= 5 then 'very close'
when warehousetohome <=10 then 'close' 
when warehousetohome <=15 then 'moderate'
else 'far'
end as distancecategory,count(*) as custcount 
from customer_churn
group by distancecategory;
-- 29
select CustomerID,ordercount from customer_churn where MaritalStatus ='married' and CityTier = 1 
and OrderCount > (select avg(OrderCount) from customer_churn);
-- 30
create table customers_returns(
return_id int unique,
customerID int primary key,
returndate date default(current_date()),
refundamount decimal(10,2) ,
foreign key(customerId) references customer_churn(customerID)
);

SELECT* FROM customers_returns;

insert into customers_returns  (return_id,customerID,returndate,refundamount)
values 
(1001 ,50022, '2023-01-01', 2130),
(1002 ,50316 ,'2023-01-23',2000),
(1003 ,51099 ,'2023-02-14',2290),
(1004 ,52321 ,'2023-03-08',2510),
(1005 ,52928 ,'2023-03-20',3000),
(1006 ,53749 ,'2023-04-17',1740),
(1007 ,54206 ,'2023-04-21',3250),
(1008 ,54838 ,'2023-04-30',1990);

select * from customers_returns;
-- 30) -- b

select CCH.*, CRE.* from customer_churn cch
join customers_returns AS CRE
on cch.CustomerID = CRE.customerID
where CCH.CHURNstatus = 'CHURNED' and CCH.complaintreceived = 'YES';




 

