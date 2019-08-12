-- 1. non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT FirstName, LastName, CustomerId, Country 
FROM Customer
WHERE Country <> 'USA'

-- 2. brazil_customers.sql: Provide a query only showing the Customers from Brazil.
SELECT FirstName, LastName, CustomerId, Country 
FROM Customer
WHERE Country = 'Brazil'

-- 3. brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. 
-- The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT c.FirstName, c.LastName, c.CustomerId, c.Country, i.InvoiceId, i.InvoiceDate, i.BillingCountry
FROM Customer c
JOIN Invoice i
ON i.CustomerId = c.CustomerId
WHERE Country = 'Brazil'

-- 4. sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.
SELECT FirstName, LastName, Title
FROM Employee
WHERE Title = 'Sales Support Agent'

-- 5. unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM Invoice

-- 6. sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. 
-- The resultant table should include the Sales Agent's full name.
SELECT i.InvoiceId, e.FirstName, e.LastName
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
JOIN Employee e
ON e.EmployeeId = c.SupportRepId
WHERE e.Title = 'Sales Support Agent'

-- 7. invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT i.Total, c.FirstName+ ' ' + c.LastName as CustomerName, e.FirstName + ' ' + e.LastName as EmployeeName
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
JOIN Employee e
ON e.EmployeeId = c.SupportRepId
WHERE e.Title = 'Sales Support Agent'

-- 8. total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?
SELECT COUNT(*) as TotalInvoicesRange
FROM Invoice 
WHERE Year (InvoiceDate) = 2009
OR Year (InvoiceDate) = 2011;

-- 9. total_sales_{year}.sql: What are the respective total sales for each of those years?
SELECT SUM(Total) as Totals, Year(InvoiceDate) as [Year]
FROM Invoice 
WHERE Year (InvoiceDate) = 2009
OR Year (InvoiceDate) = 2011
GROUP BY Year(InvoiceDate);

-- 10. invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(*) as LineItems
FROM InvoiceLine
WHERE InvoiceId = 37

-- 11. line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. 
-- HINT: GROUP BY
SELECT COUNT(InvoiceId) as LineItems
FROM InvoiceLine
GROUP BY InvoiceId

-- 12. line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
SELECT il.InvoiceId as LineItems, t.Name
FROM InvoiceLine il
JOIN Track t
ON il.TrackId = t.TrackId

-- 13. line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT il.InvoiceId as LineItems, t.Name as TrackName, a.Name as ArtistName
FROM InvoiceLine il
JOIN Track t
ON il.TrackId = t.TrackId
JOIN Album al
ON al.AlbumId = il.TrackId
JOIN Artist a
ON al.ArtistId = a.ArtistId

-- 14. country_invoices.sql: Provide a query that shows the # of invoices per country. 
-- HINT: GROUP BY
SELECT COUNT(BillingCountry) as Invoices, BillingCountry
FROM Invoice
GROUP BY BillingCountry

-- 15. playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. 
-- The Playlist name should be include on the resulant table.
SELECT COUNT(pt.TrackId) as NumOfTracks, p.Name
FROM PlaylistTrack pt
JOIN Playlist p
ON p.PlaylistId = pt.PlaylistId
GROUP BY p.Name

-- 16. tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. 
-- The result should include the Album name, Media type and Genre.
SELECT t.Name as SongTitle, al.Title as Album, m.Name as MediaType, g.Name as Genere
FROM Track t
JOIN Album al
ON t.AlbumId = al.AlbumId
JOIN MediaType m
ON t.MediaTypeId = m.MediaTypeId
JOIN Genre g
ON t.GenreId = g.GenreId

-- 17. invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT COUNT(il.InvoiceId) as NumLineItems, i.InvoiceId
FROM Invoice i
LEFT JOIN InvoiceLine il
ON il.InvoiceId = i.InvoiceId
GROUP BY i.InvoiceId

-- 18. sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
SELECT SUM(i.Total) as TotalSales, e.EmployeeId, e.FirstName + ' ' + e.LastName as EmployeeName
FROM Employee e
JOIN Customer c
ON e.EmployeeId = c.SupportRepId
JOIN Invoice i
ON c.CustomerId = i.CustomerId
WHERE e.Title = 'Sales Support Agent'
GROUP BY e.EmployeeId, e.FirstName, e.LastName

-- 19. top_2009_agent.sql: Which sales agent made the most in sales in 2009?
-- Hint: Use the MAX function on a subquery.
SELECT TOP 1 Sum(i.Total) TotalSales, e.FirstName + ' ' + e.LastName as EmployeeName
FROM Employee e
JOIN Customer c
ON e.EmployeeId = c.SupportRepId
JOIN Invoice i
ON c.CustomerId = i.CustomerId
WHERE e.Title = 'Sales Support Agent'
AND YEAR(i.InvoiceDate) = 2009
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY Sum(i.Total) desc

-- 20. top_agent.sql: Which sales agent made the most in sales over all?
SELECT TOP 1 Sum(i.Total) TotalSales, e.FirstName + ' ' + e.LastName as EmployeeName
FROM Employee e
JOIN Customer c
ON e.EmployeeId = c.SupportRepId
JOIN Invoice i
ON c.CustomerId = i.CustomerId
WHERE e.Title = 'Sales Support Agent'
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY Sum(i.Total) desc

-- 21. sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
SELECT COUNT(c.CustomerId) as NumOfCustomers, e.FirstName + ' ' + e.LastName as EmployeeName
FROM Customer c
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
WHERE e.Title = 'Sales Support Agent'
GROUP BY e.FirstName, e.LastName

-- 22. sales_per_country.sql: Provide a query that shows the total sales per country.
SELECT Sum(i.Total) TotalSales, i.BillingCountry
FROM Employee e
JOIN Customer c
ON e.EmployeeId = c.SupportRepId
JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY i.BillingCountry
ORDER BY Sum(i.Total) desc

-- 23. top_country.sql: Which country's customers spent the most?
SELECT c.FirstName, c.LastName, ts.BillingCountry, ts.TotalSales
FROM Employee e
JOIN Customer c
    on e.EmployeeId = c.SupportRepId
JOIN Invoice i
    on i.CustomerId = c.CustomerId
JOIN
(SELECT Max(i.Total) TotalSales, i.BillingCountry
FROM Employee e
JOIN Customer c
ON e.EmployeeId = c.SupportRepId
JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY i.BillingCountry) as ts
 ON ts.BillingCountry = i.BillingCountry
 AND ts.TotalSales = i.Total

-- 24. top_2013_track.sql: Provide a query that shows the most purchased track of 2013.
SELECT TOP 1 t.Name as TrackName, SUM(il.TrackId) as NumberPurchased
FROM Track t
JOIN InvoiceLine il 
ON il.TrackId = t.TrackId
JOIN Invoice i 
ON i.InvoiceId = il.InvoiceId
WHERE Year (InvoiceDate) = 2013
GROUP BY t.Name
ORDER BY SUM(il.TrackId) DESC;

-- 25. top_5_tracks.sql: Provide a query that shows the top 5 most purchased songs.
SELECT TOP 5 t.Name as TrackName, SUM(il.TrackId) as NumberPurchased
FROM Track t
JOIN InvoiceLine il 
ON il.TrackId = t.TrackId
JOIN Invoice i 
ON i.InvoiceId = il.InvoiceId
GROUP BY t.Name
ORDER BY SUM(il.TrackId) DESC;

-- 26. top_3_artists.sql: Provide a query that shows the top 3 best selling artists.
SELECT TOP 3 a.Name, SUM(il.TrackId) as TracksSold
FROM Artist a
JOIN Album al 
ON al.ArtistId = a.ArtistId
JOIN Track t 
ON t.AlbumId = al.AlbumId
JOIN InvoiceLine il 
ON il.TrackId = t.TrackId
JOIN Invoice i 
ON i.InvoiceId = il.InvoiceId
GROUP BY a.Name
ORDER BY SUM(il.TrackId) DESC;

-- 27. top_media_type.sql: Provide a query that shows the most purchased Media Type.
SELECT TOP 1 m.Name as MediaType, COUNT(il.TrackId) as NumOfTracksSold
FROM MediaType m
JOIN Track t 
ON m.MediaTypeId = t.MediaTypeId
JOIN InvoiceLine il 
ON il.TrackId = t.TrackId
GROUP BY m.Name
ORDER BY COUNT(il.TrackId) DESC;