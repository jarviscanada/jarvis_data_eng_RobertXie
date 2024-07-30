# Introduction
# SQL queries
###### Table Setup (DDL)
```
create table cd.members
(
memid integer not null,
surname varchar(200) not null,
firstname varchar(200) not null,
address varchar(300) not null,
zipcode integer not null,
telephone varchar(20) not null,
recommendedby integer,
joindate timestamp not null,
constraint members_pk primary key (memid),
constraint fk_members_recommendedby foreign key (recommendedby) references cd.members(memid) on delete set null
);

create table cd.facilities
(
facid integer not null,
name varchar(100) not null,
membercost numeric not null,
guestcost numeric not null,
initialoutlay numeric not null,
monthlymaintenance numeric not null,
constraint facid_pk primary key (facid)
);

create table cd.bookings
(
bookid integer not null,
facid integer not null,
memid integer not null,
starttime timestamp not null,
slots integer not null,
constraint bookings_pk primary key (bookid),
constraint fk_bookings_facid foreign key (facid) references cd.facilities(facid),
constraint fk_bookings_memid foreign key (memid) references cd.members(memid)
);
```
###### Question 1: Insert some data into a table
```sql
insert into cd.facilities values (9, 'Spa', 20, 30, 100000, 800);
```
###### Question 2: Insert calculated data into a table
```sql
insert into cd.facilities select (select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;
```         
###### Question 3: Update some existing data
```sql
update cd.facilities set initialoutlay = 10000 where facid = 1;
```
###### Question 4: Update a row based on the contents of another row
```sql
update cd.facilities fac 
set 
membercost = (select membercost * 1.1 from cd.facilities where facid = 0),
guestcost = (select guestcost * 1.1  from cd.facilities where facid = 0)
where fac.facid = 1;
```
###### Question 5: Delete all bookings
```sql
delete from cd.bookings;
```
###### Question 6: Delete a member from the cd.members table
```sql
delete from cd.members where memid = 37;
```
###### Question 7: Control which rows are retrieved - part 2
```sql
select facid, name, membercost, monthlymaintenance
from cd.facilities
where membercost < monthlymaintenance * 1/50 and membercost > 0;
```
###### Question 8: Basic string searches
```sql
select * from cd.facilities
where name like '%Tennis%';
```
###### Question 9: Matching against multiple possible values
```sql
select * from cd.facilities
where facid in (1,5);
```
###### Question 10: Working with dates
```sql
select memid, surname, firstname, joindate from cd.members
where joindate >= '2012-09-01';
```
###### Question 11: Combining results from multiple queries
```sql
select surname from cd.members
union
select name from cd.facilities;
```
###### Question 12: Retrieve the start times of members' bookings
```sql
select starttime from cd.bookings b
join cd.members mem
on b.memid = mem.memid
where firstname = 'David' and surname = 'Farrell';
```
###### Question 13: Work out the start times of bookings for tennis courts
```sql
select starttime as start, fac.name from cd.bookings b
join cd.facilities fac
on b.facid = fac.facid
where fac.name like 'Tennis%' and
starttime >= '2012-09-21' and
starttime < '2012-09-22'
order by start;
```
###### Question 14: Produce a list of all members, along with their recommender
```sql
select mem.firstname as memfname, mem.surname as memsname, rec.firstname as recfname, rec.surname as recsname
from cd.members mem
left join cd.members rec
on rec.memid = mem.recommendedby
```
order by memsname, memfname;
###### Question 15: Produce a list of all members who have recommended another member
```sql
select distinct rec.firstname, rec.surname from cd.members mem
join cd.members rec
on mem.recommendedby = rec.memid
order by surname, firstname;
```
###### Question 16: Produce a list of all members, along with their recommender, using no joins
```sql
select distinct mems.firstname || ' ' ||  mems.surname as member,
	(select recs.firstname || ' ' || recs.surname as recommender 
		from cd.members recs 
		where recs.memid = mems.recommendedby
	)
	from 
		cd.members mems
order by member;
```
###### Question 17: Count the number of recommendations each member makes
```sql
select recommendedby, count(*) from cd.members
where recommendedby is not null
group by recommendedby
order by recommendedby;
```
###### Question 18: List the total slots booked per facility
```sql
select facid, sum(slots) as "Total Slots" from cd.bookings
group by facid
order by facid;
```
###### Question 19: List the total slots booked per facility in a given month
```sql
select facid, sum(slots) as "Total Slots" from cd.bookings
where starttime >= '2012-09-01' and starttime < '2012-10-01'
group by facid
```
###### Question 20: List the total slots booked per facility per month
```sql
select facid, extract(month from starttime) as month, sum(slots) as "Total Slots" from cd.bookings
where starttime >= '2012-01-01' and starttime < '2013-01-01'
group by facid, month
order by facid, month;
```
###### Question 21: Find the count of members who have made at least one booking
```sql
select count(distinct memid) from cd.bookings;
order by "Total Slots";
```
###### Question 22: List each member's first booking after September 1st 2012
```sql
select surname, firstname, m.memid, min(starttime) as starttime from cd.members m
join cd.bookings b
on b.memid = m.memid
where starttime >= '2012-09-01'
group by surname, firstname, m.memid
order by m.memid;
```
###### Question 22: Produce a list of member names, with each row containing the total member count
```sql
select (select count(*) from cd.members) as count, firstname, surname from cd.members
order by joindate
```
###### Question 23: Produce a numbered list of members
```sql
select count(*) over(order by joindate) as row_number, firstname, surname
from cd.members
```
###### Question 24: Output the facility id that has the highest number of slots booked, again
```sql
select facid, total from
(select facid, sum(slots) as total, rank() over(order by sum(slots) desc) from cd.bookings
group by facid) as ranked_table
where rank = 1;
```
###### Question 25: Format the names of members
```sql
select surname || ', ' || firstname as name from cd.members
```
###### Question 26: Find telephone numbers with parentheses
```sql
select memid, telephone from cd.members
where telephone ~ '[()]';
```
###### Question 27: Count the number of members whose surname starts with each letter of the alphabet
```sql
select substr(surname, 1, 1) as letter, count(*) from cd.members
group by substr
order by substr
```
