-- ================================================
-- SECTION 3 - SQL ANALYSIS
-- ================================================

USE ride_booking_analysis;
select count(*) as total_rows
from bookings;
describe bookings;
select * from bookings limit 10;

## Check duplicate Values

select 
     count(*) as total_rows,
     count(distinct concat_ws('|',
            `Booking ID`,
            `Booking Status`,
            `Vehicle Type`,
            `Booking Value`)) as unique_records
	 from bookings;

## Check missing values

select 
       count(*) as total_rows,
       sum(Case when `Booking Value` is null then 1 else 0 end) as missing_booking_values,
       sum(Case when `Ride Distance` is null then 1 else 0 end) as missing_ride_distance,
       sum(Case when `Customer Rating` is null then 1 else 0 end) as missing_customer_rating,
       sum(Case when `Driver Ratings` is null then 1 else 0 end) as missing_driver_rating
from bookings;

-- ========================================================
-- SECTION 3.1 - Basic Business KPI Analysis
-- ========================================================

-- ========================================================
-- 3.1.1 - Total Number of Bookings
-- ========================================================

select
      count(*) as total_bookings
from bookings;

-- ========================================================
-- 3.1.2 - Total Revenue Generated
-- ========================================================

select
      sum(`Booking Value`) as total_revenue
from bookings;

-- ========================================================
-- 3.1.3 - Average Booking Value
-- ========================================================

select
      round(avg(`Booking Value`),2) as average_booking_value
from bookings;

-- ========================================================
-- 3.1.4 - Completed Bookings
-- ========================================================

select
      count(*) as completed_bookings
from bookings
where `Booking Status`= 'Completed';


-- ========================================================
-- 3.1.5 - Overall Completion Rate
-- ========================================================

select
      round(
			100.0 * sum(
            case 
                 when `Booking Status` = 'Completed'
                 then 1
                 else 0 
                 end) / count(*),2) as completion_rate
from bookings;

-- ========================================================
-- 3.1.6 - Booking Status Distribution
-- ========================================================

select 
      `Booking Status`,
      count(*) as total_bookings,
      round(100.0 * count(*)/(select count(*) from bookings),2) as percentage_of_bookings
from bookings
group by `Booking Status`
order by total_bookings desc;

-- ========================================================
-- 3.1.7 - Combined Business KPI Summary
-- ========================================================

select
      count(*) as total_bookings,
      sum(`Booking Value`) as total_revenue,
      round(avg(`Booking Value`),2) as average_booking_value,
      
      sum(
           case when `Booking Status` = 'Completed' then 1 else 0
           end
           ) as completed_bookings,
       round(
			 100.00 * sum(
                          case when `Booking Status` = 'Completed' then 1 else 0
                          end)/count(*),2
			) as completion_rate
from bookings;
           
-- ========================================================
-- SECTION 3.2 - Vehicle Performance Analysis
-- ========================================================

-- ========================================================
-- 3.2.1 - Booking Volume by Vehicle Type
-- ========================================================

select
      `Vehicle Type`,
      count(*) as total_bookings
from bookings
group by `Vehicle Type`
order by total_bookings desc;

-- ========================================================
-- 3.2.2 - Completed Rides by Vehicle Type
-- ========================================================

select
	  `Vehicle Type`,
      count(*) as completed_rides
from bookings
where `Booking Status` = 'Completed'
group by `Vehicle Type`
order by completed_rides desc;

-- ========================================================
-- 3.2.3 - Completion Rate by Vehicle Type
-- ========================================================

select
      `Vehicle Type`,
      count(*) as total_bookings,
      sum(
		   case when `Booking Status` = 'Completed' then 1 else 0
           end) as completed_rides,
	  round(
            100.00 * sum(
                          case when `Booking Status` = 'Completed' then 1 else 0
                          end)/ count(*)) as completion_rate
from bookings
group by `Vehicle Type`
order by completion_rate desc;

-- ========================================================
-- 3.2.4 - Booking Value by Vehicle Type
-- ========================================================

select
      `Vehicle Type`,
      sum(`Booking Value`) as total_booking_value,
      round(avg(`Booking Value`),2) as average_booking_value

from bookings
group by `Vehicle Type`
order by total_booking_value desc;

-- ========================================================
-- 3.2.5 - Combined Vehicle Performance
-- ========================================================

select
      `Vehicle Type`,
      count(*) as total_bookings,
      sum(
           case when `Booking Status` = 'Completed' then 1 else 0
           end) as completed_rides,
	  round(
			100.00 * sum(
						 case when `Booking Status` = 'Completed' then 1 else 0
                         end)/count(*),2) as completion_rate,
      sum(`Booking Value`) as total_booking_value,
      round(avg(`Booking Value`),2) as average_booking_value
from bookings
group by `Vehicle Type`
order by total_booking_value desc;


-- ========================================================
-- SECTION 3.3 - Booking Status & Cancellation Analysis
-- ========================================================

-- ========================================================
-- 3.3.1 - Booking Status Distribution
-- ========================================================

select
       `Booking Status`,
       count(*) as booking_count,
       
       round(
             100.00 * count(*)/(select count(*) from bookings),2)as percentage_of_bookings
from bookings
group by `Booking Status`
order by booking_count desc;

-- ========================================================
-- 3.3.2 - Customer Cancellation Analysis
-- ========================================================

select
      count(*) as customer_cancellation,
      
      round(
            100.00 * count(*) / (select count(*) from bookings),2) as percentage_bookings
from bookings
where `Booking Status` = 'Cancelled by Customer';

-- ========================================================
-- 3.3.3 - Driver Cancellation Analysis
-- ========================================================

select
      count(*) as driver_cancellations,
      round( 100.00 * count(*)/(select count(*) from bookings),2) as percentage_of_bookings
      
from bookings
where `Booking Status` = 'Cancelled by Driver';

-- ========================================================
-- 3.3.4 - Customer Cancellation Reasons
-- ========================================================

select 
      `Cancelled Rides by Customer`,
      count(*) as cancellation_count
from bookings
where `Booking Status` = 'Cancelled by Customer'
group by `Cancelled Rides by Customer`
order by `Cancelled Rides by Customer`;

-- ========================================================
-- 3.3.5 - Driver Cancellation Reasons
-- ========================================================

select
      `Cancelled Rides by Driver` as Cancellation_reason,
      count(*) as cancellation_count
      
from bookings
where `Booking Status`='Cancelled by Driver'
group by `Cancelled Rides by Driver`
order by cancellation_count desc;

-- ========================================================
-- 3.3.6 - Cancellation Comparison
-- ========================================================

select
      `Booking Status`,
      count(*) as cancellation_count,
      
      round(100.00 * count(*)/(select count(*) from bookings where `Booking Status` in ('Cancelled by Customer',
      'Cancelled by Driver'))) as percentage_of_cancellations
      
from bookings
where `Booking Status` in ('Cancelled by Customer','Cancelled by Driver')
group by `Booking Status`
order by cancellation_count desc;

-- ========================================================
-- 3.3.7 - Cancellation by Vehicle Type
-- ========================================================

select
      `Vehicle Type`,
      `Booking Status`,
      count(*) as cancellation_count
      
from bookings
where `Booking Status` in ('Cancelled by Customer','Cancelled by Driver')
group by `Vehicle Type`,`Booking Status`
order by `Vehicle Type`,cancellation_count desc;

-- ========================================================
-- SECTION 3.4 - Customer Experience & Ratings
-- ========================================================

-- ========================================================
-- 3.4.1 - Customer Rating Distribution
-- ========================================================

select 
       `Customer Rating` as customer_rating,
       count(*) as rating_count,
       
       round(100.00 * count(*)/ (select count(*) from bookings where `Customer Rating` is not null),2)as percentage
from bookings
where `Customer Rating` is not null
group by `Customer Rating`
order by `Customer Rating`;

-- ========================================================
-- 3.4.2 - Driver Rating Distribution
-- ========================================================

select
      `Driver Ratings` as driver_rating,
      count(*) as rating_count,
      
      round(100.00 * count(*)/(select count(*) from bookings where `Driver Ratings` is not null ),2) as percentage
from bookings
where `Driver Ratings` is not null
group by `Driver Ratings`
order by `Driver Ratings`;

-- ========================================================
-- 3.4.3 - Driver Rating vs Customer Rating
-- ========================================================

select 
      round(avg (`Driver Ratings`),2) as average_driver_ratings,
      round(avg(`Customer Rating`),2) as average_customer_rating,
      round(
            avg(
				(`Driver Ratings`- (select avg(`Driver Ratings`)from bookings)
				* 
                (`Customer Rating` - (select avg(`Customer Rating`) from bookings)))
                ),4) as rating_covariance
from bookings
where `Driver Ratings` is not null and `Customer Rating` is not null;

-- ========================================================
-- 3.4.4 - Average Customer Rating by Vehicle Type
-- ========================================================

select 
      `Vehicle Type`,
      round(avg(`Customer Rating`),2) as average_customer_rating,
      count(`Customer Rating`) as rated_bookings
from bookings
where `Customer Rating` is not null
group by `Vehicle Type`
order by average_customer_rating desc;

-- ========================================================
-- 3.4.5 - Average Driver Rating by Vehicle Type
-- ========================================================

select
      `Vehicle Type`,
	  round(avg(`Driver Ratings`),2) as average_driver_ratings,
      count(`Driver Ratings`) as rated_bookings
from bookings
where `Driver Ratings` is not null
group by `Vehicle Type`
order by average_driver_ratings desc;

-- ========================================================
-- SECTION 3.5 - Ride Distance & Fare Relationship
-- ========================================================

-- ========================================================
-- 3.5.1 - Average Ride Distance
-- ========================================================

select
      round(avg(`Ride Distance`),2) as average_ride_distance,
      min(`Ride Distance`) as minimun_distance,
      max(`Ride Distance`) as maximum_distance
from bookings
where `Ride Distance` is not null;

-- ========================================================
-- 3.5.2 - Average Booking Value
-- ========================================================

select
      round(avg(`Booking Value`),2) as average_booking_value,
      min(`Booking Value`) as minimum_value,
      max(`Booking Value`) as maximum_value
from bookings
where `Booking Value` is not null;

-- ========================================================
-- 3.5.3 - Ride Distance vs Booking Value
-- ========================================================

select
      round(
		    (
            avg(`Ride Distance`*`Booking Value`)- avg(`Ride Distance`)*avg(`Booking Value`))
            /
            (stddev_pop(`Ride Distance`)*stddev_pop(`Booking Value`)),4) as distance_fare_correlation
from bookings
where `Ride Distance` is not null and `Booking Value` is not null;
      
-- ========================================================
-- 3.5.4 - Average Booking Value by Distance Category
-- ========================================================

select
       case
           when `Ride Distance` >=0
                 and `Ride Distance` <2
                 then '0-2 km'
			
            when `Ride Distance` >=2
                 and `Ride Distance` <5
                 then '2-5 km'
                 
			when `Ride Distance` >=5
                 and `Ride Distance` <10
                 then '5-10 km'
                 
			when `Ride Distance` >=10
                 and `Ride Distance` <20
                 then '10-20 km'
                 
			when `Ride Distance` >=20
                 then '20+ km'
                 
end as distance_category,
count(*) as booking_count,
round(avg(`Booking Value`),2) as average_booking_value

from bookings
where `Ride Distance` is not null and `Booking Value` is not null

group by distance_category
order by
       case distance_category
            when '0-2 km' then 1
            when '2-5 km' then 2
            when '5-10 km' then 3
            when '10-20 km' then 4
            when '20+ km' then 5
            end;
            
-- ========================================================
-- 3.5.5 - Vehicle Type vs Ride Distance & Booking Value
-- ========================================================

select
      `Vehicle Type`,
      
      count(*) as total_bookings,
      
      round(avg(`Ride Distance`),2) as average_ride_distance,
      round(avg(`Booking Value`),2) as average_ride_distance,
      round(sum(`Booking Value`),2) as total_booking_value
      
from bookings
where `Ride Distance` is not null and `Booking Value` is not null
group by `Vehicle Type`
order by total_booking_value desc;

-- ========================================================
-- SECTION 3.6 - Operational Efficiency
-- ========================================================

-- ========================================================
-- 3.6.1 - Average VTAT
-- ========================================================

select 
       round(avg(`Avg VTAT`),2) as overall_average_VTAT,
       min(`Avg VTAT`) as minimum_vtat,
       max(`Avg VTAT`) as maximum_vtat
       
from bookings
where `Avg VTAT` is not null;

-- ========================================================
-- 3.6.2 - Average CTAT
-- ========================================================

select 
       round(avg(`Avg CTAT`),2) as overall_average_CTAT,
       min(`Avg CTAT`) as minimum_ctat,
       max(`Avg CTAT`) as maximum_ctat
       
from bookings
where `Avg CTAT` is not null;

-- ========================================================
-- 3.6.3 - VTAT by Booking Status
-- ========================================================

select
      `Booking Status`,
      count(*) as booking_count,
      round(avg(`Avg VTAT`),2) as overall_average_vtat
from bookings
where `Avg VTAT` is not null
group by `Booking Status`
order by overall_average_vtat desc;

-- ========================================================
-- 3.6.3 - CTAT by Booking Status
-- ========================================================

select
      `Booking Status`,
      count(*) as booking_count,
      round(avg(`Avg CTAT`),2) as overall_average_ctat
from bookings
where `Avg CTAT` is not null
group by `Booking Status`
order by overall_average_ctat desc;

-- ========================================================
-- 3.6.5 VTAT & CTAT by Vehicle Type
-- ========================================================

select 
      `Vehicle Type`,
      round(avg(`Avg VTAT`),2) as average_vtat,
      round(avg(`Avg CTAT`),2) as average_ctat
from bookings
where `Avg VTAT` is not null and `Avg CTAT` is not null
group by `Vehicle Type`
order by average_vtat asc;

-- ========================================================
-- 3.6.6 - Operational Time vs Booking Outcome
-- ========================================================

select 
      case
          when `Booking Status`='Completed'
              then 'Completed'
		  else 'unsuccessfull'
          end as booking_outcome,
          
		count(*) as booking_count,
        round(avg(`Avg VTAT`),2) as average_vtat,
        round(avg(`Avg CTAT`),2) as average_ctat
from bookings
where `Avg VTAT` is not null and `Avg CTAT` is not null
group by booking_outcome
order by booking_outcome;
      


      
      
			









      






            



	
      
      




 