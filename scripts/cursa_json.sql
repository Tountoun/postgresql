drop table if exists books;
-- create a table
create table books(
	bid serial primary key,
	bclient text not null,
	bdata jsonb not null
);
-- populating the db
insert into  books(bclient, bdata) values
('Joe', 
 	'{"title": "Girou", "author": {"firstname": "Hermann", "lastname":"Hesse"} }'),
('Jenny', 
	'{"title": "Dharma Bums", "author":{"firstname": "Jack", "lastname":"Kerouac"}}'),
('Jenny',
	'{"titlte": "100 ans de voyage", "author":{"firstname":"Gabo", "lastname":"Marquez"}}');

update books set 
	bdata = '{"title": "100 ans de voyage", "author":{"firstname":"Gabo", "lastname":"Marquez"}}'
	where bid = 3;
select * from books;
select bid, bclient, bdata->>'title' as title from books;
-- uses -> to compare to JSON and ->> to text value
select bid, bclient from books where bdata->>'title' like 'Girou';	

select bclient, bdata->'author' as author from books;
select bclient, concat(bdata->'author'->>'firstname',' ', bdata->'author'->>'lastname') as author_name from books;
	
--jsonb is a data type of JSON in PostgreSQL which is used to store
--the data in the binary format.JSON data is first converted and then stored

create table if not exists events(
	ename varchar(200),
	visitor_id varchar(200),
	properties json,
	browser json
);
insert into events values
(
	'pageview', '1',
	'{"page": "/"}',
	'{"name": "Chrome", "os": "Mac", "resolution": {"x": 1440, "y": 900}}'
),
(
	'pageview', '2',
	'{"page": "/"}',
	'{"name": "FireFox", "os": "Windows", "resolution": {"x": 1920, "y": 1200}}'
),
(
	'pageview', '1',
	'{"page": "/account"}',
	'{"name": "Chrome", "os": "Mac", "resolution": {"x": 1440, "y": 900}}'
),
(
	'purchase', '5',
	'{"amount": 10}',
	'{"name": "FireFox", "os": "Windows", "resolution": {"x": 1024, "y": 768}}'
),
(
	'purchase', '15',
	'{"amount": 200}',
	'{"name": "FireFox", "os": "Windows", "resolution": {"x": 1280, "y": 800}}'
),
(
	'purchase', '15',
	'{"amount": 500}',
	'{"name": "FireFox", "os": "Windows", "resolution": {"x": 1280, "y": 800}}'
);
select * from events;
--browser usage
select browser->>'name' as browser, count(browser) 
	from events
	group by browser->>'name';
select json_each_text(browser) from events;
select json_object_keys(browser->'resolution') from events;
--total revenue per visitor
select visitor_id, sum(cast(properties->>'amount' as integer)) as total
	from events
	where cast(properties->>'amount' as integer) > 0
	group by visitor_id;
--screen average
select avg(cast(browser->'resolution'->>'x' as integer)) as width, avg(cast(browser->'resolution'->>'y' as integer)) as height
	from events;

-- Cette requête affiche toutes le familles d'opérateurs definies
-- et tous les opérateurs inclus dans chaque famille
SELECT am.amname AS index_method,
       opf.opfname AS opfamily_name,
       amop.amopopr::regoperator AS opfamily_operator
    FROM pg_am am, pg_opfamily opf, pg_amop amop
    WHERE opf.opfmethod = am.oid AND
          amop.amopfamily = opf.oid
    ORDER BY index_method, opfamily_name, opfamily_operator;
 
-- Quering complex json documents
create table person(pdata jsonb not null);
create index person_index on person using gin(pdata jsonb_path_ops);
insert  into person values(
'
	{
		"name": "Alice",
		"emails": ["alice1@test.com", "alice2@test.com"],
		"events":[
			{"type": "birthday","date":"1970-01-01"},
			{"type":"anniversary", "date":"2001-05-05"}
		],
		"locations":{
			"home":{
				"city":"London",
				"country":"United Kingdom"
			},
			"work":{
				"city":"Edinburgh",
				"country":"United Kingdom"
			}
		}
	}
'
);
select pdata->>'name' from person where pdata @> '{"name":"Alice"}';


-- table expressionsin select queries 

create table orders(
	oid serial primary key,
	user_id int not null,
	ordered_at date default current_date
);
with sales as(
	select o.user_id, o.ordered_at, sum(ordered_at) as total
	from orders o group by o.ordered_at, o.user_id
)select sales.ordered_at, sales.total from sales;

-- recursive queries ; sum of integers
with recursive t(n, p) as (
	values (0, 2)
	union  
		select n+1, p+3 from t where n<10
)select * from t;
