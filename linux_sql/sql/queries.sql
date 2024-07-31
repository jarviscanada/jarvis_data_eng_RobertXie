insert into cd.facilities values (9, 'Spa', 20, 30, 100000, 800);

insert into cd.facilities select (select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;

update cd.facilities set initialoutlay = 10000 where facid = 1;

update cd.facilities fac 
set 
membercost = (select membercost * 1.1 from cd.facilities where facid = 0),
guestcost = (select guestcost * 1.1  from cd.facilities where facid = 0)
where fac.facid = 1;

delete from cd.bookings;

delete from cd.members where memid = 37;

select facid, name, membercost, monthlymaintenance
from cd.facilities
where membercost < monthlymaintenance * 1/50 and membercost > 0;

select * from cd.facilities
where name like '%Tennis%';

select * from cd.facilities
where facid in (1,5);

select memid, surname, firstname, joindate from cd.members
where joindate >= '2012-09-01';

select surname from cd.members
union
select name from cd.facilities;

select starttime from cd.bookings b
join cd.members mem
on b.memid = mem.memid
where firstname = 'David' and surname = 'Farrell';

select starttime as start, fac.name from cd.bookings b
join cd.facilities fac
on b.facid = fac.facid
where fac.name like 'Tennis%' and
starttime >= '2012-09-21' and
starttime < '2012-09-22'
order by start;

select mem.firstname as memfname, mem.surname as memsname, rec.firstname as recfname, rec.surname as recsname
from cd.members mem
left join cd.members rec
on rec.memid = mem.recommendedby
order by memsname, memfname;

select distinct rec.firstname, rec.surname from cd.members mem
join cd.members rec
on mem.recommendedby = rec.memid
order by surname, firstname;

select distinct mems.firstname || ' ' ||  mems.surname as member,
	(select recs.firstname || ' ' || recs.surname as recommender 
		from cd.members recs 
		where recs.memid = mems.recommendedby
	)
	from 
		cd.members mems
order by member;

select recommendedby, count(*) from cd.members
where recommendedby is not null
group by recommendedby
order by recommendedby;

select facid, sum(slots) as "Total Slots" from cd.bookings
group by facid
order by facid;

select facid, sum(slots) as "Total Slots" from cd.bookings
where starttime >= '2012-09-01' and starttime < '2012-10-01'
group by facid

select facid, extract(month from starttime) as month, sum(slots) as "Total Slots" from cd.bookings
where starttime >= '2012-01-01' and starttime < '2013-01-01'
group by facid, month
order by facid, month;

select count(distinct memid) from cd.bookings;
order by "Total Slots";

select surname, firstname, m.memid, min(starttime) as starttime from cd.members m
join cd.bookings b
on b.memid = m.memid
where starttime >= '2012-09-01'
group by surname, firstname, m.memid
order by m.memid;

select (select count(*) from cd.members) as count, firstname, surname from cd.members
order by joindate

select count(*) over(order by joindate) as row_number, firstname, surname
from cd.members

select facid, total from
(select facid, sum(slots) as total, rank() over(order by sum(slots) desc) from cd.bookings
group by facid) as ranked_table
where rank = 1;

select surname || ', ' || firstname as name from cd.members

select memid, telephone from cd.members
where telephone ~ '[()]';

select substr(surname, 1, 1) as letter, count(*) from cd.members
group by substr
order by substr
