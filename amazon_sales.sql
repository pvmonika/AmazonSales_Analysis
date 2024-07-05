use amazon;
alter table record
add column Dayname varchar(50);
alter table record drop column day ;
select Dayname from record;
UPDATE record
SET Dayname = DAYNAME(date);

alter table record 
add column MonthName varchar(50);

Update record 
set MonthName = monthname(date);
alter table record 
add column timeofday varchar(50);

UPDATE record
set timeofday = 
case
WHEN HOUR(time) < 12 THEN 'Morning'
WHEN HOUR(time) < 15 THEN 'Afternoon'
        ELSE 'Evening'
 end;

select * from record;
select `customer type`,count(`customer type`) as count from record
group by `customer type` ;

-- 1. What is the count of distinct cities in the dataset?
select count(distinct city) city_count from record ; 
-- 3 cities

-- 2. For each branch, what is the corresponding city?
select distinct branch,city from record ;
-- Yangon
-- Naypyitaw
-- Mandalay

-- 3.What is the count of distinct product lines in the dataset?
select count(distinct `product line`) from record;
-- 6
-- Health and beauty
-- Electronic accessories
-- Home and lifestyle
-- Sports and travel
-- Food and beverages
-- Fashion accessories

-- 4. Which payment method occurs most frequently?

select `payment` from record group by 1 order by count(*) desc limit 1;
-- Ewallet	345
-- Cash	    344
-- Credit card	311

-- 5.Which product line has the highest sales?

select `product line` from record group by 1 order by sum(total) desc limit 1 ;
-- Food and beverages
-- Food and beverages	56144.844000000005
-- Sports and travel	55122.826499999996
-- Electronic accessories	54337.531500000005
-- Fashion accessories	54305.895
-- Home and lifestyle	53861.91300000001
-- Health and beauty	49193.739000000016

-- 6.How much revenue is generated each month?

select MonthName , round(sum(total),2) as overall_revenue from record group by 1 order by overall_revenue desc;
-- January	  116291.87
-- March	   109455.51
-- February	97219.37

-- 7.In which month did the cost of goods sold reach its peak?

select monthname,sum(cogs) overall_cogs from record group by 1 order by overall_cogs desc limit 1;
-- January	110754.16000000002
-- March	104243.33999999997
-- February	92589.88

-- 8.Which product line generated the highest revenue?

select `product line` from record group by 1 order by sum(total) desc limit 1; 
 -- Food and beverages
 
-- 9. In which city was the highest revenue recorded?
select city from record group by 1 order by sum(total) desc limit 1; 
-- Naypyitaw

-- 10. Which product line incurred the highest Value Added Tax?

select `product line` ,round(sum(`Tax 5%`),2) VAT from record group by 1 order by VAT desc;
-- Food and beverages	2673.56
-- Sports and travel	2624.9
-- Electronic accessories	2587.5
-- Fashion accessories	2586
-- Home and lifestyle	2564.85
-- Health and beauty	2342.56

-- 11. For each product line, add a column indicating "Good" if its sales are above average, 
-- otherwise "Bad."

-- select `product line` , round(sum(total),2) average_sales,
-- case 
-- when round(sum(total),2)>=(select round(avg(total),2) from record) then 'Good' else 'Bad' 
-- end sales_category
-- from record group by 1 ;
-- Error Code: 1055. Expression #3 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'amazon.record.Total' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
ALTER TABLE record ADD COLUMN product_category VARCHAR(20);

UPDATE record 
SET product_category= 
CASE 
	WHEN total >= 322.96674900000005 THEN "Good"
    ELSE "Bad"
END ;

-- 12. Identify the branch that exceeded the average number of products sold.

select avg(quantity) from record; -- 5.5100
with  branch_avg as (
select branch , avg(quantity) branch_avg from record 
group by 1 )
select branch from branch_avg where branch_avg > (select avg(quantity) from record); -- 5.5100
-- C
# 13  Which product line is most frequently associated with each gender?
select gender,`product line` , count(*) freq from record group by 1,2 order by freq desc;
-- Female	Fashion accessories	96
-- Female	Food and beverages	90
-- Female	Sports and travel	88
-- Female	Electronic accessories	84
-- Female	Home and lifestyle	79
-- Female	Health and beauty	64
-- Male	Health and beauty	88
-- Male	Electronic accessories	86
-- Male	Food and beverages	84
-- Male	Fashion accessories	82
-- Male	Home and lifestyle	81
-- Male	Sports and travel	78

-- 14. Calculate the average rating for each product line.
select `product line`,round(avg(rating),2) from record group by 1 ;
-- Food and beverages	7.11
-- Fashion accessories	7.03
-- Health and beauty	7
-- Electronic accessories	6.92
-- Sports and travel	6.92
-- Home and lifestyle	6.84

-- 15. Count the sales occurrences for each time of day on every weekday.
-- select timeofday , count(*) Frequency from record group by 1;
select timeofday ,dayname, count(*) Frequency from record 
where dayname != 'Saturday' and dayname != 'Sunday'
group by 1,2;

-- 16. Identify the customer type contributing the highest revenue.
select `customer type` , round(sum(total),2) overall_revenue from record group by 1 order by overall_revenue desc;
-- Member	164223.44
-- Normal	158743.31

-- 17.Determine the city with the highest VAT percentage.

select city,round(sum(`Tax 5%`),2) as highes_vat from record group by 1 order by highes_vat desc;
-- Naypyitaw	5265.18
-- Yangon	5057.16
-- Mandalay	5057.03

-- 18.Identify the customer type with the highest VAT payments.

select `customer type`,round(sum(`Tax 5%`),2) as highes_vat from record group by 1 order by highes_vat desc;
-- Member	7820.16
-- Normal	7559.21

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct `customer type`) from record;
-- 2 (member, normal)

-- 20. What is the count of distinct payment methods in the dataset?

select count(distinct `payment`) from record;
-- 3 Ewallet Cash Credit card

-- 21.Which customer type occurs most frequently?
select `customer type`  from record  group by 1 order by count(*) desc limit 1 ;
-- Member	501
-- Normal	499

-- 22. Identify the customer type with the highest purchase frequency.

select `customer type` from record group by 1 order by count(total) desc limit 1;

-- Member	164223.44400000002
-- Normal	158743.30500000005

-- 23. Determine the predominant gender among customers.
select gender  from record group by 1 order by count(*) desc limit 1;
-- female

-- 24. Examine the distribution of genders within each branchs
select branch,gender,count(*) frque from record group by 1,2 order by frque desc;

-- A	Male	179
-- C	Female	178
-- B	Male	170
-- B	Female	162
-- A	Female	161
-- C	Male	150

-- 25.Identify the time of day when customers provide the most ratings.
select timeofday , avg(rating) from record group by 1 order by count(rating) desc;
-- Evening	534
-- Afternoon	275
-- Morning	191

-- 26.Determine the time of day with the highest customer ratings for each branch.
select branch,timeofday , round(sum(rating),2) from record group by 1,2 order by sum(rating) desc;

-- 27.Identify the day of the week with the highest average ratings.
select dayname , round(avg(rating),2) as highest_rating from record group by 1;

-- select dayname , round(count(Total),2) as highest_rating from record group by 1;

-- select timeofday , round(count(Total),2) as highest_rating from record group by 1;

-- 28. Determine the day of the week with the highest average ratings for each branch.
select dayname ,branch, avg(rating) from record group by 1,2;

select `product line`,round((sum(total)/322966.75) *100,2) Total_revenue_per from record group by 1 order by Total_revenue_per desc  ; 
select round(sum(total),2) from record;
