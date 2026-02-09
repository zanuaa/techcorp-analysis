create database techcorp;
show databases;
use techcorp; 
show tables from techcorp;

create table Products (
	product_id int auto_increment primary key, 
    product_name varchar (100) not null,
    category varchar (500) not null,
    price decimal (10,2), 						
    stock_quantity int
);

select * from products;

create table Customers (
	customer_id int auto_increment primary key,
    first_name varchar (100) not null,
    last_name varchar (100) not null,
	email varchar(100) unique, 						
    phone varchar(20),
    address varchar(100)
);
select * from Customers;

create table Orders (
	order_id int auto_increment primary key,
    customer_id int,
    order_date date,
    total_amount decimal (10,2),
    foreign key (customer_id) references Customers(customer_id)
);
select * from Orders;
describe Orders;

create table OrderDetails (
	order_detail_id int auto_increment primary key,
    order_id int, 															
    product_id int,
    quantity int,
    unit_price decimal (10,2),
    foreign key (order_id) references Orders(order_id),
    foreign key (product_id) references Products(product_id)
);
select * from OrderDetails;

create table Employees (
	employee_id int auto_increment primary key,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    phone varchar(20),
    hire_date date,
    department varchar(50)
); 
alter table Employees rename column departement to department;
select * from employees;

create table SupportTickets(
	ticket_id int auto_increment primary key,
    customer_id int,
    employee_id int,
    issue text, 													
    status varchar(20),
    created_at datetime, 											
    resolved_at datetime,
    foreign key (customer_id) references Customers(customer_id),
    foreign key (employee_id) references Employees(employee_id)
);

alter table SupportTickets rename column ststus to status;
select * from products;

alter table products
add column discount decimal (5,2) default 0; 

select * from products;
select * from customers;
select * from Orders;
select * from orderdetails;
select * from employees;
select * from supporttickets;


-- Practice
-- 1. Top 3 customers based on orders
select 
	c.first_name,
	c.last_name,
    sum(o.total_amount) as total_order_amount
from Customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by total_order_amount desc
limit 3;

-- 2. avg order value for each customer
select 
	c.first_name,
    c.last_name,
    avg(o.total_amount) as avg_order_amount 
from Customers c
join Orders o on c.customer_id=o.customer_id
group by c.customer_id; 									

-- 3. Employee with > 4 resolved ticket support 
select
	e.first_name,
	e.last_name, 
	count(s.status) as resolved_ticket
from Employees e
join SupportTIckets s on e.employee_id=s.employee_id
where s.status = 'resolved'
group by e.employee_id
having count(s.status) > 4;

-- 4. product yang belum pernah dipesan
select 
p.product_name
from products p
left join orderdetails od on p.product_id=od.order_id
where od.order_id is null;

-- 5. Total revenue yang dihasilkan dari penjualan produk
select 
sum(quantity * unit_price) as total_revenue
from orderdetails;

-- 6. Temukan harga rata-rata produk untuk setiap kategori dan temukan katagori dengan harga rata-rata > $500
with avg_price as (
	select 
		category,
		round(avg(price),2) as avg_product
	from products
	group by category
)
select * from avg_price
where avg_product > 500;

-- 7. Temukan pelanggan yg telah membuat setidaknya satu pesanan dg total jumlah > $1000
 select * 
from customers
where customer_id in 
(select customer_id
from orders
where total_amount > 1000);
