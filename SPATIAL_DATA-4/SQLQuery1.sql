use publishing;

select * from world_cities where org_fid=345;
select * from Books;
select * from Publishings;

create table Publishings
(
	id int primary key,
	pname nvarchar(35),
	city int foreign key references world_cities(ogr_fid)
)

insert into Publishings values (1, 'Азбука', 5), (2, 'Книга', 48), (3, 'Мир', 194), (4, 'Москва', 11);

--Города, в которых есть издательства
 SELECT * FROM world_cities 
	WHERE ogr_fid in (
    SELECT ogr_fid FROM world_cities
    INTERSECT
    SELECT city FROM Publishings);

--Пересечение городов
DECLARE @geom1 geometry;  
DECLARE @geom2 geometry;  
DECLARE @result geometry;  
  
SELECT @geom1 = ogr_geometry FROM world_cities WHERE ogr_fid = 1;  
SELECT @geom2 = ogr_geometry FROM world_cities WHERE ogr_fid = 2;  
SELECT @result = @geom1.STUnion(@geom2);  
SELECT @result.STAsText();


-- Рассояние между городами
DECLARE @geom1 geometry;  
DECLARE @geom2 geometry;  
DECLARE @result float,
		@gid int = 1; 
 
--exec Distance @gid;
SELECT @geom1 = ogr_geometry FROM world_cities WHERE ogr_fid = 1;  
SELECT @geom2 = ogr_geometry FROM world_cities WHERE ogr_fid = 2;  
SELECT @result = @geom1.STDistance (@geom2);  
SELECT @result;

GO
--Изменить (уточнить) пространственный объект
DECLARE @g geometry;  

SET @g = geometry::STPointFromText('POINT (100 100)', 0);
UPDATE world_cities SET ogr_geometry = geometry::STPointFromText('POINT (100 100)', 0) WHERE ogr_fid = 416;
SELECT * FROM world_cities WHERE ogr_fid = 413;

--Ускорение поиска 
CREATE SPATIAL INDEX SIndx_world_cities_geometry_col ON world_cities(ogr_geometry)
   WITH ( BOUNDING_BOX = ( 0, 0, 500, 200 ) );  