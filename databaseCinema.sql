create database cinema;
use cinema;

create table genres (
genre_id int auto_increment primary key,
name varchar(50) not null
);

create table movies (
movie_id int auto_increment primary key,
title VARCHAR(100) NOT NULL,
duration INT,
release_date DATE,
genre_id INT,
director VARCHAR(100),
rating DECIMAL(3,1),
description TEXT,
FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    capacity INT,
    type VARCHAR(20)
);

CREATE TABLE seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    row__number INT,
    seat_number INT,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE screenings (
    screening_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    room_id INT,
    start_time DATETIME,
    end_time DATETIME,
    price DECIMAL(6,2),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    screening_id INT,
    seat_id INT,
    customer_id INT,
    purchase_time DATETIME,
    price DECIMAL(6,2),
    FOREIGN KEY (screening_id) REFERENCES screenings(screening_id),
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT,
    payment_method VARCHAR(30),
    payment_time DATETIME,
    amount DECIMAL(6,2),
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);

-- genres → movies → screenings
-- rooms → seats
-- rooms → screenings
-- screenings → tickets
-- customers → tickets
-- tickets → payments

INSERT INTO genres (name) VALUES
('Action'),
('Comedy'),
('Drama'),
('Horror'),
('ScienceFiction'),
('Animation');

INSERT INTO movies (title, duration, release_date, genre_id, director, rating, description) VALUES
('Inception', 148, '2010-07-16', 5, 'Christopher Nolan', 8.8, 'Dream manipulation'),
('The Dark Knight', 152, '2008-07-18', 1, 'Christopher Nolan', 9.0, 'Batman vs Joker'),
('Titanic', 195, '1997-12-19', 3, 'James Cameron', 7.9, 'Romantic drama'),
('The Conjuring', 112, '2013-07-19', 4, 'James Wan', 7.5, 'Paranormal horror'),
('Toy Story', 81, '1995-11-22', 6, 'John Lasseter', 8.3, 'Animated adventure');

INSERT INTO rooms (name, capacity, type) VALUES
('Room 1', 100, '2D'),
('Room 2', 80, '3D'),
('Room 3', 120, 'IMAX');

INSERT INTO seats (room_id, row__number, seat_number) VALUES
(1,1,1),
(1,1,2),
(1,1,3),
(1,2,1),
(1,2,2),
(2,1,1),
(2,1,2),
(3,1,1),
(3,1,2);

INSERT INTO screenings (movie_id, room_id, start_time, end_time, price) VALUES
(1,1,'2026-03-10 18:00:00','2026-03-10 20:30:00',30),
(2,2,'2026-03-10 19:00:00','2026-03-10 21:30:00',35),
(3,1,'2026-03-11 17:00:00','2026-03-11 20:00:00',25),
(4,3,'2026-03-11 21:00:00','2026-03-11 23:00:00',40),
(5,2,'2026-03-12 16:00:00','2026-03-12 17:30:00',20);

INSERT INTO customers (first_name, last_name, email, phone) VALUES
('Ion','Popescu','ion@email.com','0711111111'),
('Maria','Ionescu','maria@email.com','0722222222'),
('Andrei','Georgescu','andrei@email.com','0733333333'),
('Elena','Dumitrescu','elena@email.com','0744444444');

INSERT INTO tickets (screening_id, seat_id, customer_id, purchase_time, price) VALUES
(1,1,1,'2026-03-09 12:00:00',30),
(1,2,2,'2026-03-09 12:05:00',30),
(2,6,3,'2026-03-09 13:00:00',35),
(3,3,4,'2026-03-10 10:00:00',25);

INSERT INTO payments (ticket_id, payment_method, payment_time, amount) VALUES
(1,'Card','2026-03-09 12:00:10',30),
(2,'Cash','2026-03-09 12:05:10',30),
(3,'Card','2026-03-09 13:00:10',35),
(4,'Card','2026-03-10 10:00:10',25);

SELECT * FROM movies;
SELECT * FROM screenings;
SELECT * FROM tickets;

-- list of all movies with their genres
SELECT m.title, g.name AS genre
FROM movies m
JOIN genres g ON m.genre_id = g.genre_id;

-- movies sorted by rating
SELECT title, rating
FROM movies
ORDER BY rating DESC;

-- the film screenings and the hall
SELECT m.title, r.name AS room, s.start_time, s.price
FROM screenings s
JOIN movies m ON s.movie_id = m.movie_id
JOIN rooms r ON s.room_id = r.room_id;

-- what movie did each customer buy
SELECT c.first_name, c.last_name, m.title
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
JOIN screenings s ON t.screening_id = s.screening_id
JOIN movies m ON s.movie_id = m.movie_id;

-- total number of tickets sold
SELECT COUNT(*) AS total_tickets
FROM tickets;

-- the number of tickets sold for each movie
SELECT m.title, COUNT(t.ticket_id) AS tickets_sold
FROM tickets t
JOIN screenings s ON t.screening_id = s.screening_id
JOIN movies m ON s.movie_id = m.movie_id
GROUP BY m.title;

-- total revenue for each film
SELECT m.title, SUM(t.price) AS revenue
FROM tickets t
JOIN screenings s ON t.screening_id = s.screening_id
JOIN movies m ON s.movie_id = m.movie_id
GROUP BY m.title;

-- movies that sold more than one ticket
SELECT m.title, COUNT(t.ticket_id) AS sold
FROM tickets t
JOIN screenings s ON t.screening_id = s.screening_id
JOIN movies m ON s.movie_id = m.movie_id
GROUP BY m.title
HAVING COUNT(t.ticket_id) > 1;

-- daverage length of movies
SELECT AVG(duration) AS average_duration
FROM movies;

-- the most expensive screeningg
SELECT MAX(price) AS highest_price
FROM screenings;

-- movies with ratings above the average of all movies
SELECT title, rating
FROM movies
WHERE rating > (
SELECT AVG(rating)
FROM movies
);

-- customers who bought tickets
SELECT first_name, last_name
FROM customers
WHERE customer_id IN (
SELECT customer_id
FROM tickets
);

-- customers who did not buy tickets
SELECT first_name, last_name
FROM customers
WHERE customer_id NOT IN (
SELECT customer_id
FROM tickets
);

-- number of screenings for each film
SELECT m.title, COUNT(s.screening_id) AS screenings
FROM movies m
JOIN screenings s ON m.movie_id = s.movie_id
GROUP BY m.title;

-- total cinema revenue
SELECT SUM(amount) AS total_revenue
FROM payments;

-- payment method used
SELECT DISTINCT payment_method
FROM payments;

-- the number of seats in each room
SELECT room_id, COUNT(seat_id) AS seats
FROM seats
GROUP BY room_id;

-- customers and total amount spent
SELECT c.first_name, c.last_name, SUM(t.price) AS total_spent
FROM customers c
JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.customer_id;

-- screenings ordered by price
SELECT screening_id, price
FROM screenings
ORDER BY price DESC;

--  movies that don't have screenings
SELECT m.title
FROM movies m
LEFT JOIN screenings s ON m.movie_id = s.movie_id
WHERE s.screening_id IS NULL;






































