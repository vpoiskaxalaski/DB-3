USE publishing;

--1
--Х	объем выпуска
SELECT Books.caption, SUM(SoldBooks.nbook) OVER(PARTITION BY book_id ORDER BY book_id ASC) AS јmount, order_data FROM SoldBooks
CROSS JOIN Books
WHERE SoldBooks.order_data BETWEEN '2018-01-02' AND '2020-12-01';

--Х	сравнение с общим объемом выпуска (в %);
SELECT book_id, nbook  
    ,SUM(nbook) OVER(PARTITION BY book_id) AS Total  
    ,CAST(1. * nbook / SUM(nbook) OVER(PARTITION BY book_id)   
        *100 AS DECIMAL(5,2))AS "Percent by ProductID"  
FROM SoldBooks   
WHERE SoldBooks.order_data BETWEEN '2018-05-02' AND '2019-12-01'
GROUP BY book_id, nbook;

--Х	сравнение с пиковыми значени€ми объема выпуска (в %).
SELECT id, book_id, nbook  
    ,SUM(nbook) OVER(PARTITION BY book_id) AS Total  
    ,CAST(1. * nbook / MAX(nbook) OVER(PARTITION BY book_id)   
        *100 AS DECIMAL(5,2))AS "Percent by ProductID"  
FROM SoldBooks   
WHERE SoldBooks.order_data BETWEEN '2018-05-02' AND '2019-12-01';


--3.разбиение результатов запроса на страницы.
--ROW_NUMBER вычисл€ет уникальные идентификаторы в секции, начина€ с 1 и с шагом 1
SELECT * , ROW_NUMBER() OVER(PARTITION BY book_id ORDER BY book_id) AS rownum
FROM SoldBooks;

select * from SoldBooks
insert into SoldBooks values( 4, 52, GETDATE())

--4. ROW_NUMBER() дл€ удалени€ дубликатов
SELECT count(*) FROM SoldBooks;

delete x from (
  select *, rn=row_number() over (partition by book_id order by book_id)
  from SoldBooks 
) x
where rn > 1;


--5  акой жанр пользовалс€ наибольшей попул€рностью дл€ определенного автора? ¬ернуть дл€ всех авторов.
select Authors.nickname, Books.caption from Books
join Authors on Books.author_id = Authors.id

SELECT book_id,
  SUM(nbook),
  RANK() OVER(ORDER BY SUM(nbook) DESC) AS rnk
FROM SoldBooks
  JOIN Books ON SoldBooks.book_id = Books.id
GROUP BY book_id;
