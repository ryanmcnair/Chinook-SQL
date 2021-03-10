--1. `non_usa_customers.sql`: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
select concat(FirstName,' ', LastName) FullName, CustomerId, Country
from Customer
Where Country != 'USA'
--2. `brazil_customers.sql`: Provide a query only showing the Customers from Brazil.
select concat(FirstName,' ', LastName) FullName, CustomerId, Country
from Customer
Where Country = 'Brazil'
--3. `brazil_customers_invoices.sql`: Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's 
--full name, Invoice ID, Date of the invoice and billing country.
select concat(c.FirstName, ' ', c.LastName) FullName, i.InvoiceId, i.InvoiceDate, i.BillingCountry
from Invoice i
join Customer c
	on c.CustomerId = i.CustomerId
Where i.BillingCountry = 'Brazil'
--4. `sales_agents.sql`: Provide a query showing only the Employees who are Sales Agents.
select *
from Employee
where title like '%agent%'
--5. `unique_invoice_countries.sql`: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
select distinct BillingCountry
from Invoice
--6. `sales_agent_invoices.sql`: Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
select i.*, CONCAT(e.FirstName, ' ', e.LastName) EmployeeName
from Invoice i
	join Customer c
		on i.CustomerId = c.CustomerId
	join Employee e
		on c.SupportRepId = e.EmployeeId
--7. `invoice_totals.sql`: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
select i.Total as InvoiceTotal,CONCAT(c.FirstName, ' ', c.LastName) CustomerName, CONCAT(e.FirstName, ' ', e.LastName) EmployeeName
from Invoice i
	join Customer c
		on i.CustomerId = c.CustomerId
	join Employee e
		on c.SupportRepId = e.EmployeeId
--8. `total_invoices_year.sql`: How many Invoices were there in 2009 and 2011?
select count(*) as InvoiceTotal
from Invoice i
	where i.InvoiceDate between '2009-01-01' and '2011-12-31' 
--9. `total_sales_year.sql`: What are the respective total sales for each of those years?
select sum(i.Total) as NineTotal
from Invoice i
	where i.InvoiceDate between '2009-01-01' and '2009-12-31'
union
select sum(i.Total) as TenTotal
from Invoice i
	where i.InvoiceDate between '2010-01-01' and '2010-12-31'
union
select sum(i.Total) as ElevenTotal
from Invoice i
	where i.InvoiceDate between '2011-01-01' and '2011-12-31'

--Rob's code:
select
	Year(InvoiceDate) as SalesYear,
	sum(Total) as TotalSales
from Invoice i
	where Year(InvoiceDate) = 2009 or Year(InvoiceDate) = 2011
group by Year(InvoiceDate)

--10. `invoice_37_line_item_count.sql`: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
select count(*)
from InvoiceLine il
	where InvoiceId = 37
--11. `line_items_per_invoice.sql`: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: [GROUP BY](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql)
select InvoiceId, count(*) LineItems
from InvoiceLine il
	group by InvoiceId 
--12. `line_item_track.sql`: Provide a query that includes the purchased track name with each invoice line item.
select il.*, t.Name
from InvoiceLine il
	join Track t
	on il.TrackId = t.TrackId
--13. `line_item_track_artist.sql`: Provide a query that includes the purchased track name AND artist name with each invoice line item.
select il.*, t.Name, ar.Name
from InvoiceLine il
	join Track t
	on il.TrackId = t.TrackId
	join Album al
	on t.AlbumId = al.AlbumId
	join Artist ar
	on al.ArtistId = ar.ArtistId

--14. `country_invoices.sql`: Provide a query that shows the # of invoices per country. HINT: [GROUP BY](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql)
select BillingCountry, count(*) InvoicesPerCountry
from Invoice
	group by BillingCountry
--15. `playlists_track_count.sql`: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table.
select count(*) NumberOfSongs, p.Name
from PlaylistTrack pt
	join Playlist p
	on pt.PlaylistId = p.PlaylistId
		group by p.Name
--16. `tracks_no_id.sql`: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
select t.Name, m.Name, g.Name
from Track t
	join MediaType m
	on t.MediaTypeId = m.MediaTypeId
	join Genre g
	on t.GenreId = g.GenreId
--17. `invoices_line_item_count.sql`: Provide a query that shows all Invoices but includes the # of invoice line items.
select i.*, (select Count(il.InvoiceLineId)
				from InvoiceLine il
				where il.InvoiceId = i.InvoiceId) InvoiceLineItems
from Invoice i
--18. `sales_agent_total_sales.sql`: Provide a query that shows total sales made by each sales agent.
select sum(i.total) Totals, 
(
	select concat(e.FirstName, ' ', e.LastName) SalesAgent
		from Employee e
		where e.EmployeeId = c.SupportRepId
)
from Invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
group by c.SupportRepId

--19. `top_2009_agent.sql`: Which sales agent made the most in sales in 2009? HINT: [TOP](https://docs.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql)
select top(1) sum(i.total) Totals, 
(
	select concat(e.FirstName, ' ', e.LastName) SalesAgent
		from Employee e
		where e.EmployeeId = c.SupportRepId
)
from Invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
where i.InvoiceDate like '%2009%'
group by c.SupportRepId
order by Totals desc
 
--20. `top_agent.sql`: Which sales agent made the most in sales over all?
select top(1) sum(i.total) Totals, 
(
	select concat(e.FirstName, ' ', e.LastName) SalesAgent
		from Employee e
		where e.EmployeeId = c.SupportRepId
)
from Invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
group by c.SupportRepId
order by Totals desc

--21. `sales_agent_customer_count.sql`: Provide a query that shows the count of customers assigned to each sales agent.
select count(*) NumberOfCustomers, concat(e.firstName, ' ', e.LastName) SalesAgent
from Customer c
	join Employee e
	on c.SupportRepId = e.EmployeeId
group by e.firstName, e.LastName
order by NumberOfCustomers desc

--22. `sales_per_country.sql`: Provide a query that shows the total sales per country.
select sum(i.total) CountryTotal, i.BillingCountry
from invoice i
group by i.BillingCountry
order by CountryTotal desc

--23. `top_country.sql`: Which country's customers spent the most?
select Top(1) sum(i.total) CountryTotal, i.BillingCountry
from invoice i
group by i.BillingCountry
order by CountryTotal desc

--24. `top_2013_track.sql`: Provide a query that shows the most purchased track of 2013.
--join invoice for date, invoiceline for trackId & track for the tracks name 
select Top(1) sum(i.total) SalesTotal, t.name
from Invoice i
	join InvoiceLine il
	on i.InvoiceId = il.InvoiceId
	join Track t
	on il.TrackId = t.TrackId
where Year(i.InvoiceDate) = 2013
group by t.Name
order by SalesTotal desc

--25. `top_5_tracks.sql`: Provide a query that shows the top 5 most purchased songs.
select Top(5) sum(i.total) SalesTotal, t.name
from Invoice i
	join InvoiceLine il
	on i.InvoiceId = il.InvoiceId
	join Track t
	on il.TrackId = t.TrackId
group by t.Name
order by SalesTotal desc

--26. `top_3_artists.sql`: Provide a query that shows the top 3 best selling artists.
--invoice for sales totals, invoiceline for trackId, track for AlbumId, album for ArtistId & Artist for Artist
select top(3) sum(i.total) SalesTotal, ar.Name
from Invoice i
	join InvoiceLine il
	on i.InvoiceId = il.InvoiceId
	join Track t
	on il.TrackId = t.TrackId
	join Album al
	on t.AlbumId = al.AlbumId
	join Artist ar
	on  al.ArtistId = ar.ArtistId
group by ar.Name
order by SalesTotal desc

--27. `top_media_type.sql`: Provide a query that shows the most purchased Media Type.
select top(1) sum(i.total) SalesTotal, m.Name
from Invoice i
	join InvoiceLine il
	on i.InvoiceId = il.InvoiceId
	join Track t
	on il.TrackId = t.TrackId
	join MediaType m
	on t.MediaTypeId = m.MediaTypeId
group by m.Name
order by SalesTotal desc
