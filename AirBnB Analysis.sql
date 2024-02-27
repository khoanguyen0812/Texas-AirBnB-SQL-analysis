USE AirBnB;

-- Checking data
SELECT *
FROM calendar;

SELECT *
FROM listings;

-- Assigning relations

DESCRIBE listings;

ALTER TABLE listings
ADD CONSTRAINT
PRIMARY KEY(id);

DESCRIBE reviews;

ALTER TABLE reviews
ADD CONSTRAINT
PRIMARY KEY(id);

ALTER TABLE reviews
ADD CONSTRAINT
FOREIGN KEY (listing_id)
REFERENCES listings(id);

DESCRIBE calendar;

ALTER TABLE calendar
ADD COLUMN unique_id INT AUTO_INCREMENT PRIMARY KEY;

DESCRIBE neighbourhoods;

SELECT *
FROM neighbourhoods;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'listings'
AND COLUMN_NAME = 'neighbourhood';

SELECT neighbourhood, COUNT(DISTINCT neighbourhood) AS num_neigh
FROM neighbourhoods
GROUP BY neighbourhood;

ALTER TABLE neighbourhoods
ADD CONSTRAINT
PRIMARY KEY(neighbourhood);

SELECT neighbourhood
FROM listings;


/* We have a lot of errors including $ infront of price. We need to fix this*/

SELECT *,
Price,
CAST(REPLACE(Price, '$','') AS UNSIGNED) AS price_clean
FROM listings;

/* Now, we need to try to figure out how many days each AirBnB was booked out for. To
do this, we will subtract the days available from the 30 days column, by 30 days in order to
figure out how many days were they booed out for.*/

SELECT id, availability_30
FROM listings
ORDER BY availability_30 ASC;

SELECT id, listing_url, name, 30 - availability_30 AS booked_out_30,
CAST(REPLACE(Price, '$','') AS UNSIGNED) AS price_clean,
CAST(REPLACE(Price, '$','') AS UNSIGNED)*(30 - availability_30) AS proj_rev_30
FROM listings
ORDER BY proj_rev_30 DESC
LIMIT 20;

/* Lastly, we will try to see what customer list we can pull for an AirBnB cleaning business.
To do this, we will re-examine the data table.*/

SELECT *
FROM listings;

SELECT listing_id, COUNT( DISTINCT comments) AS num_comments
FROM reviews
GROUP BY listing_id
ORDER BY num_comments DESC
LIMIT 10;

SELECT host_id, COUNT( DISTINCT comments) AS num_comments
FROM listings
INNER JOIN reviews
ON listings.id = reviews.listing_id
GROUP BY host_id
ORDER BY num_comments DESC;

SELECT *
FROM reviews;

SELECT COUNT(DISTINCT host_id) AS Diff_host
FROM listings;

SELECT host_id, host_url, host_name, COUNT(*) AS num_dirty_reviews
FROM reviews r
INNER JOIN listings l
ON r.listing_id = l.id
WHERE comments LIKE "%dirty%"
GROUP BY host_id, host_url, host_name
ORDER BY num_dirty_reviews DESC
LIMIT 50;