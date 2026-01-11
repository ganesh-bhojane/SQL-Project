--Database
PostgreSQL

--tool
PgAdmin 4

--create database bookstore
create database bookstore;

--create tables
create table books
(Book_Id serial primary key,
Title varchar(90),
Author varchar(100),
Genre varchar(90),
Published_year int,
Price decimal(10,2),
Stock int
);

create table customers
(Customer_ID serial primary key,
Name varchar(100),
Email varchar(100),
Phone varchar(30),
City varchar(60),
Country varchar(150));

create table orders
(Orders_id serial primary key,
Customer_id int references customers(Customer_id),
Book_id int references books(Book_id),
Order_date date,
Quantity int,
Total_amount decimal(10,2));

select * from books;
select * from customers;
select * from orders;

--import data into books table
copy books from 'C:/Books.csv' DELIMITER',' CSV HEADER;

--import data into customers table
copy customers from 'C:/Customers.csv' DELIMITER',' CSV HEADER;

--import data into orders table
COPY orders from 'C:/Orders.csv' DELIMITER',' CSV HEADER;

-- 1) Retrieve all books in the "Fiction genre"
select * from books
where genre='Fiction';

--2) Find books published after the year 1950
select * from books
where published_year>1950;

--3) Select all customers from the canada
select * from customers
where country='Canada';

--4) Show orders placed in November 2023
select * from orders
where order_date between '2023-11-01' and '2023-11-30';

--5) Retrieve the total stock of books available
select sum(stock) as total_stock from books;

--6) Find the details of the most expensive book
select * from books
order by price 
desc limit 1;

--7) Show all customers who ordered more than 1 quantity of a book
select c.customer_id,c.name,o.quantity from customers c
join orders o on c.customer_id=o.customer_id
where o.quantity>1;

--8) Retrieve all orders where the total amount exceeds $20
select * from orders
where  total_amount>20 
order by total_amount asc;

--9) Retrieve all genres available in the books table
select distinct genre from books;

--10) Find the book with the lowest stock 
select * from books
order by  stock asc
limit 1;

--11) Calculate the total revenue generated from all orders
select sum(total_amount) as total_revenue from orders;

--Advanced Questions

--1) Retrieve the total number of books sold for each genre
select b.genre,sum(o.quantity) as total_books_sold
from orders o 
join books b on b.book_id=o.book_id
group by b.genre ;

--2) Find the average price of books in the 'Fantasy' genre
select avg(price) as avg_price
from books
where genre='Fantasy';

--3) List customers who have placed at least 2 orders
select c.name ,c.customer_id, count(o.orders_id) as order_count
from customers c
join orders o on c.customer_id=o.customer_id
group by c.customer_id,c.name
having count(o.orders_id)>2;

--4) Find the most frequently ordered book
select o.book_id,b.title,
count(o.orders_id) as order_count
from orders o
join books b on o.book_id=b.book_id
group by o.book_id,b.title
order by order_count desc
limit 1;

--5) Show the top 3 most expensive books of 'Fantasy genre'
select * from books
where genre='Fantasy'
order by price desc 
limit 3;

--6) Retrieve the total quantity of books sold by each author
select b.author,sum(o.quantity) as total_book_sold
from orders o
join books b on b.book_id=o.book_id
group by b.author;

--7) List the cities where customers who spent over $30 are located 
select distinct c.city,total_amount
from orders o
join customers c on c.customer_id=o.customer_id
where o.total_amount>30;

--8) Find the customer who spent the most on orders
select c.customer_id,c.name,sum(o.total_amount) as total_spent
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_id,c.name
order by total_spent desc
limit 1;

--9) Calculate the stock remaining after fulfilling all orders
select b.book_id,b.title,b.stock,coalesce (sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id,b,title,b.stock
order by b.book_id;


