use publishing
go

select * from Report
--TASK1
create table Report (
id INTEGER primary key identity(1,1),
xml_column XML
);
GO
--TASK2	
create or alter procedure generateXML
as
declare @x XML
set @x = (Select nickname, GETDATE() [Дата] from Authors 
join Books on Books.author_id = Authors.id
join SoldBooks on SoldBooks.book_id = Books.id
FOR XML AUTO);
SELECT @x
GO

execute generateXML;

GO
--TASK3
create or alter procedure InsertInReport
as
DECLARE  @s XML  
set @s = (Select nickname, GETDATE() [Дата] from Authors 
join Books on Books.author_id = Authors.id
join SoldBooks on SoldBooks.book_id = Books.id
for xml raw);
--FOR XML AUTO);
--FOR XML EXPLICIT);
insert into Report values(@s);
go
  
  execute InsertInReport
  select * from Report;

--task4
create primary xml index My_XML_Index on Report(xml_column)

--task5
select * from Report

GO
create or alter procedure SelectData
as
select xml_column.query('(/row[3])') as[xml_column] from Report for xml auto, type;
go

execute SelectData
