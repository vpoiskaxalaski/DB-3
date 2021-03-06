/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP (1000) [id]
      ,[book_id]
      ,[nbook]
      ,[order_data]
  FROM [publishing].[dbo].[SoldBooks]


GO
use publishing
INSERT INTO SoldBooks VALUES
(2, 72, '2019-06-02'),
(4, 68, '2019-07-02'),
(6, 52, '2019-06-03');

select * from SoldBooks
WHERE SoldBooks.order_data BETWEEN '2018-05-02' AND '2019-12-01'
--•	сравнение с общим объемом выпуска (в %);
SELECT book_id, SUM(nbook) OVER(PARTITION BY book_id) AS Total   FROM SoldBooks 
WHERE SoldBooks.order_data IN('2018-05-02', '2019-05-02')



select Authors.nickname, Books.caption from Books
join Authors on Books.author_id = Authors.id
