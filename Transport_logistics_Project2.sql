create database transport_logistics;
use transport_logistics;
select * from transport_logistics_dataset_with_products;

#1.--"FleetOptimization"
#--1.Which Vehicles have the highest cost per KM ?

select Transport_Mode,
    round(sum(Freight_Cost)/sum(Distance_km),2) as cost_per_km
    from transport_logistics_dataset_with_products
    group by Transport_Mode
    order by cost_per_km desc;
    
#--Insights--High cost per km = inefficient vehicle,poor routing, or higher maintenance cost.

#--2.Identify underutilized shipments based on total distance.

select ï»¿Shipment_ID,
     sum(Distance_km) as total_distance
	from transport_logistics_dataset_with_products
    group by ï»¿Shipment_ID
    having sum(Distance_km) <1000;

#--Insights--Underutilized vehicles can be reassigned or removed.

#--3.Which vehicle has the maximum delayed deliveries?

select ï»¿Shipment_ID,
       count(*) as failed_deliveries
       from transport_logistics_dataset_with_products
       where Delivery_Status = 'delayed'
       group by ï»¿Shipment_ID
       order by failed_deliveries desc
       limit 1;

#--Insights--Frequent delayed increase freight cost and customer dissatisfaction.
    
    
#2."Delivery Time Reduction"
#--1.Average delivery time by destination city.

SELECT `Destination`,
     ROUND(AVG(DATEDIFF(str_to_date(delivery_date,'%d-%m-%Y %H:%i'),str_to_date(order_date,'%d-%m-%Y %H:%i'))),2) AS avg_delivery_days
From transport_logistics_dataset_with_products
WHERE Delivery_Status = 'Delivered'
GROUP BY `Destination`;

#--Insights--This analysis identifies logistics bottlenecks by highlighting cities with higher-than-average delivery times.

#--2.Percentage of delayed deliveries (more than 2 /days).

SELECT 
    COUNT(CASE WHEN Delay_Days > 1 THEN 1 END) * 100.0 
    / COUNT(*) AS delayed_percentage
FROM transport_logistics_dataset_with_products;

#--Insights--the overall delivery reliability by determining the percentage of shipments that failed to meet a one-day delivery threshold.

#--3.. Identify orders with maximum delivery duration.

SELECT ï»¿Shipment_ID,
	DATEDIFF(str_to_date(Delivery_Date,'%d-%m-%Y %H:%i'),str_to_date(Order_Date,'%d-%m-%Y %H:%i'))as delivery_days
from transport_logistics_dataset_with_products
ORDER BY delivery_days DESC
LIMIT 5;

#--Insights--The maximum delivery duration for orders in 6 days.

#3."Route Performance Analysis"
#--1.Average delivery time per route.

SELECT Destination,
       ROUND(AVG(DATEDIFF(str_to_date(Delivery_Date,'%d-%m-%Y %H:%i'),str_to_date(Order_Date,'%d-%m-%Y %H:%i'))), 2) AS avg_delivery_days
FROM transport_logistics_dataset_with_products
GROUP BY Destination;

#--Insights--Transportation costs vary by destination, with averages ranging between 26.44 and 31.01 units per km.

#--2.Route success rate.

SELECT Destination,
       COUNT(CASE WHEN delivery_status = 'Delivered' THEN 1 END) * 100.0 
       / COUNT(*) AS success_rate
FROM transport_logistics_dataset_with_products
GROUP BY Destination;

#--Insights--the percentage of orders successfully marked as 'Delivered' for each specific route.

#--3.Freight cost per km by Route.

SELECT Destination,
       ROUND(SUM(freight_cost) / SUM(distance_km), 2) AS cost_per_km
FROM transport_logistics_dataset_with_products
GROUP BY Destination;

#--Insights--the freight cost per kilometer by dividing total cost by total distance for each destination.


  





