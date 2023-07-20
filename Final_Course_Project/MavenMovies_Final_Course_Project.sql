use mavenmovies;
/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

select
	    store.store_id,
        concat(staff.first_name," ",staff.last_name) as Manager_Full_Name,
		concat(address.address,", ",address.district,", ",city.city,", ",country.country) as Full_Address
from store
	inner join staff
    on store.store_id = staff.store_id
    inner join address
    on staff.address_id = address.address_id
    inner join city
    on address.city_id = city.city_id
    inner join country
    on city.country_id = country.country_id;

		
	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

select
	inventory.store_id,
    inventory.inventory_id,
    film.title as Film_Name,
    film.rating as Film_Rating,
    film.rental_rate as Film_Rental_Rate,
    film.replacement_cost as Film_Replacement_Cost
from inventory
	inner join film
    on inventory.film_id = film.film_id;	
    

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
select
	inventory.store_id,
    film.rating,
    count(distinct inventory.film_id) as Count_Inventory_By_rating
from film
	inner join inventory
    on film.film_id = inventory.film_id
    group by inventory.store_id,film.rating
	order by inventory.store_id asc;


/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

select
	inventory.store_id,
	film_category.category_id,
    count(film.film_id) as No_of_Films,
    round(avg(film.replacement_cost),2) as Avearge_Repalcement_Cost,
    round(sum(film.replacement_cost),2) as Total_Replacement_Cost
 from inventory
	inner join film
    on inventory.film_id = film.film_id
    inner join film_category
    on film.film_id = film_category.film_id
group by inventory.store_id, film_category.category_id;



/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

select
	customer.store_id,
        concat(customer.first_name," ",customer.last_name) as Full_Name,
		concat(address.address,", ",address.district,", ",city.city,", ",country.country) as Full_Address,
	case 
		when customer.active = 1 then "Active"
		when customer.active = 0 then "InActive"
	end as Customer_Status	
from customer
	inner join address
    on customer.address_id = address.address_id
    inner join city
    on address.city_id = city.city_id
    inner join country
    on city.country_id = country.country_id;


/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

select
        concat(customer.first_name," ",customer.last_name) as Customer_Name,
        count(rental.rental_id) as Total_Renatl_Paid,
        sum(payment.amount) as Total_Payment_Recieved
from customer
	inner join rental
    on customer.customer_id = rental.customer_id
    inner join payment
    on rental.rental_id = payment.rental_id
group by  Customer_Name
	order by count(rental.rental_id) desc;

    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

select 
		advisor_id as stakeholder_id,
		concat(first_name," ",last_name) as Full_Name,
		"advisor" as stakeholder,
        "N/A" as Company
	from advisor
union 
select 
		investor_id as stakeholder_id,
		concat(first_name," ",last_name) as Full_Name,
		"investor" as stakeholder,
        company_name as Company
	from investor;


/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

select
	case
		when awards = 'Emmy, Oscar, Tony ' then " 3 Awards"
		when awards in ('Emmy, Tony','Emmy, Oscar','Oscar, Tony') then " 2 Awards"
		when awards in ('Oscar','Emmy','Tony') then " 1 Awards"
	end as Number_Of_Awards,
	sum(case when actor_id is null then 0 else 1 end) as film_count_values,
	(sum(case when actor_id is null then 0 else 1 end)/count(case when actor_id is null then 0 else 1 end))*100 as Film_Percentage_Count
from actor_award
 group by 
	case
		when awards = 'Emmy, Oscar, Tony ' then " 3 Awards"
		when awards in ('Emmy, Tony','Emmy, Oscar','Oscar, Tony') then " 2 Awards"
		when awards in ('Oscar','Emmy','Tony') then " 1 Awards"
	end;



