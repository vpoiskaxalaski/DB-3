create directory bfile_dir as 'D:\pict\' 
drop directory bfile_dir

CREATE TABLE esignatures (
  office   NUMBER(6,0)  NOT NULL,
  username VARCHAR2(10) NOT NULL,
  FOTO  blob  NOT NULL
)
drop table esignatures

INSERT INTO esignatures  
VALUES (100, 'BOB', utl_raw.cast_to_raw('D:\pict\pasha.jpg'));

--INSERT INTO esignatures VALUES (101, 'Alex',  bfilename('bfile_dir' , 'IMGEKA.png'));

select * from esignatures

------
create table bfile_table(
          name varchar2(255),
          the_file bfile );

insert into bfile_table values ( 'doc 2', BFILENAME( 'bfile_dir', 'qwe.docx' ) );

select * from bfile_table


-------------------
DECLARE
  l_dir    VARCHAR2(10) := 'IMAGES'; -------Is the Directory Object Created Above.
  l_file   VARCHAR2(20) := 'site_logo.gif'; ------ Is the BLOB File that is present in the Directory mentioned.
  l_bfile  BFILE;
  l_blob   BLOB;
BEGIN
  INSERT INTO images (id, name, image)
  VALUES (1,l_file, empty_blob())
  RETURN image INTO l_blob;

  l_bfile := BFILENAME(l_dir, l_file);
  DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
  DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
  DBMS_LOB.fileclose(l_bfile);

  COMMIT;
END;