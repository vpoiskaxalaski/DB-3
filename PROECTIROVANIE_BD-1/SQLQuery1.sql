use publishing;
go
create table Authors(
id int identity primary key,
nickname nvarchar(30) unique,
mobile_phone varchar(20) unique
);

drop table Books;
create table Books(
id int identity primary key,
caption nvarchar(50),
publication_year int,
author_id int foreign key REFERENCES Authors(id),
cost money,
publishing_id int foreign key REFERENCES Publishings(id) 
);

drop table SoldBooks;
create table SoldBooks
(
id int identity primary key,
book_id int foreign key references Books(id),
nbook int check(nbook>0),
order_data date
);

go

create index auth_nick on Authors(nickname);

go
insert into Authors values 
('Mikhail Bulgakov', '375332587856'), 
('Erich Maria Remarque',   '375294457856'),
('Oscar Wilde',     '375252545856'),
('Agatha Christie',   '375332599876');

delete from Books;
insert into Books values
('Die Traumbude', 1920, 2, 56.8, 1),
('The White Guard', 1926, 1, 57.4, 2),
('Dorian Gray', 1980, 3, 41.3, 1),
('Der Funke Leben', 1952, 2, 45.6, 3),
('The Pale Horse', 1961, 4, 78.6, 2),
('The Master and Margarita', 1967, 1, 35.7, 1),
('Heart of a Dog', 1968, 1, 45.1, 4);

delete from SoldBooks;
insert into SoldBooks values
(5, 63, '02-05-2018'),
(6, 25, '02-05-2019'),
(7, 54, '02-05-2017'),
(3, 890,'02-05-2018'),
(2, 34, '02-05-2018'),
(1, 78, '02-05-2017'),
(4, 15,'02-05-2019');

select * from Books;
select * from SoldBooks;
go

create or alter view BooksAndAuthors 
as
select caption, nickname from Books 
join Authors on Books.author_id=Authors.id;

go

select * from BooksAndAuthors;
go

create or alter procedure GetAllOrders	
	@startDate date,
	@stopDate date
as	
select SoldBooks.id, Books.caption, SoldBooks.nbook, SoldBooks.order_data 
											from SoldBooks join Books 
											on SoldBooks.book_id=Books.id
											where order_data between @startDate and @stopDate;

go

declare 
	@start date = '2018-12-05',
	@stop date  = '2019-12-05';

exec GetAllOrders @start, @stop;

go

create or alter function CountIncome(@rowid int)
returns money
as	
begin
declare 
@n int,
@c money,
@sum money,
@book_cur cursor 
set @book_cur = cursor for select SoldBooks.nbook, Books.cost from SoldBooks
																		join Books 
																		on SoldBooks.book_id=Books.id
																	 where  SoldBooks.id=@rowid;
	open @book_cur;
	fetch next from @book_cur into @n, @c;
	set @sum = @n*@c;
	close @book_cur;
	return @sum;
end;

go
select [dbo].[CountIncome](6);
go

create or alter trigger check_SoldBooks
on SoldBooks for insert
as
	print 'new row in SoldBooks';

go
insert into SoldBooks values
(2, 13, '13-09-2017');






