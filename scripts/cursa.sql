-- use of array in postgres
drop table if exists contacts;

drop sequence if exists contacts_pk_seq;
create sequence contacts_pk_seq
	as int 
	increment 2 
	start 5
	maxvalue 50;

create table contacts(
	cid serial,
	cname varchar(30),
	cphones text [], -- un tableau contenant les différents contacts d'une personne
	primary key(cid)
);

-- Insertion dans la table contacts
-- using array keyword
insert into contacts(cname, cphones) values
('RAD', array ['(00228)91548573', '(00228)96458215']),
('KOUAM', array [, '(00228)99662415']);
-- using curly braces
insert into contacts(cname, cphones) values
('NAPO', '{"(00228)96451232", "(00228)79121002"}'),
('SAM', '{"(00228)93546212"}');

select * from contacts;
select cname, cphones[2] from contacts;
select cname from contacts where cphones[1] like '(00228)96%';

update contacts set cphones[2] = '(00228)93021241' where cid = 4;

select nextval('contacts_pk_seq');

update contacts set cphones = '{"(00228)97890135", "(00228)91511471"}'
where cid = 7;

-- rechercher dans un tableau grâce à la fonction any

select cid, cname from contacts where '(00228)93021241' = any(cphones);

-- expand an array to a list of rows
select cid, cname, unnest(cphones) from contacts;

-- char_length(<value>) retourne la longueur d'une chaîne
select cname, char_length(cname) from contacts;
alter table client add constraint client_pk primary key(cid);
create table client(cid int not null, cname varchar(20) not null);
select * from client;
insert into client values(nextval('contacts_pk_seq'), 'ROGA') returning cid;

-- insertion in client by selecting data from another table; the columns have to match
insert into client select cid, cname from contacts limit 4;
-- on conflit insertion
insert into client values(2, 'GOZA') on conflict(cid) do update set cname = 'KOUAMI'
returning *; 
--copy client from stdin delimiter ',';
copy contacts to '/home/tountoun/Bureau/postgres/example.txt' using delimiters '|' with null as
'null_string' csv header; -- on error, do this with psql tool




