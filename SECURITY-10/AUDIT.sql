--1.	Показать и объяснить, какой режим аутентификации используется для экземпляра SQL Server.

--2.	Создать необходимые учетные записи, роли и пользователей. 
USE publishing
GO
GRANT ALTER ANY DATABASE AUDIT TO lab_9_admin;
GO

--3.	Создать для экземпляра SQL Server объект аудита.
--4.	Задать для серверного аудита необходимые спецификации. 
USE master;
GO
CREATE SERVER AUDIT HIPAA_Audit  
    TO APPLICATION_LOG;
GO  
 
--5.	Запустить серверный аудит, продемонстрировать журнал аудита.
ALTER SERVER AUDIT HIPAA_Audit  
WITH (STATE = ON);  
GO 

--6.	Создать необходимые объекты аудита.
--7.	Задать для аудита необходимые спецификации.
--8.	Запустить аудит БД, продемонстрировать журнал аудита
USE publishing;   
GO    
CREATE DATABASE AUDIT SPECIFICATION Audit_Pay_Tables  
FOR SERVER AUDIT HIPAA_Audit 
ADD (SELECT, INSERT ON SoldBooks BY dbo )   --audit_action_specification
WITH (STATE = ON) ;   
GO

--9.	Остановить аудит БД и сервера.
ALTER SERVER AUDIT HIPAA_Audit  
WITH (STATE = OFF);  
GO 
USE publishing
GO
ALTER DATABASE AUDIT SPECIFICATION Audit_Pay_Tables
WITH (STATE = OFF);  
GO 

--10.	Создать для экземпляра SQL Server ассиметричный ключ шифрования.
CREATE ASYMMETRIC KEY PacificSales09   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = '<StrongPasswordHere>';   
GO  

--11.	Зашифровать и расшифровать данные при помощи этого ключа.
CREATE DATABASE [EncryptedDB]
use EncryptedDB
GO
USE [EncryptedDB]
GO
DROP TABLE [dbo].[CreditCardInformation]
DELETE FROM [dbo].[CreditCardInformation]
GO
CREATE TABLE [dbo].[CreditCardInformation]
([PersonID] [int] PRIMARY KEY IDENTITY,
[CreditCardNumber] [varbinary](max))
GO
--Шифрование с помощью асииметричного ключа.
INSERT INTO [dbo].[CreditCardInformation]
VALUES (ENCRYPTBYASYMKEY( AsymKey_ID('PacificSales09') , N'QWеуккаакекE12у4пкууууууууууум3'))
GO
SELECT * FROM [dbo].[CreditCardInformation]
GO
--Расшифрование с помощью асииметричного ключа.
SELECT [PersonID], CONVERT(nvarchar(max),  DecryptByAsymKey( AsymKey_Id('PacificSales09'), [CreditCardNumber], N'<StrongPasswordHere>'))   
AS DecryptedData   
FROM [dbo].[CreditCardInformation]
GO  

--12.	Создать для экземпляра SQL Server сертификат.
use [EncryptedDB]
go
drop certificate SampleCert
create certificate SampleCert
encryption by password = N'pA$$W0RD'
with subject = N'Цель создания',
Expiry_DATE = N'31/10/2022';

--13.	Зашифровать и расшифровать данные при помощи этого сертификата.
INSERT INTO [dbo].[CreditCardInformation] values(EncryptByCert(Cert_ID('SampleCert'), N'Секретные данные'));
GO
SELECT * FROM [dbo].[CreditCardInformation]
GO
SELECT (Convert(Nvarchar(100), DecryptByCert(Cert_ID('SampleCert'), CreditCardInformation.CreditCardNumber, N'pA$$W0RD'))) FROM [dbo].[CreditCardInformation];
GO

--14.	Создать для экземпляра SQL Server симметричный ключ шифрования данных.
--для шифрования симм ключа
create Symmetric key SKey
WITH ALGORITHM = AES_256  ENCRYPTION
 by password = 'PA$$W0RD';

Open symmetric key SKey
Decryption by password = 'PA$$W0RD'
create Symmetric key SData
with Algorithm =  AES_256
encryption by symmetric key SKey;

Open symmetric key SData 
Decryption by symmetric key SKey;

create Master key encryption by password = N'StRoNgPa$$w0Rd';
--15.	Зашифровать и расшифровать данные при помощи этого ключа.
--Шифрование с помощью симетричного ключа.
INSERT INTO [dbo].[CreditCardInformation] VALUES (ENCRYPTBYKEY( Key_GUID('SData') , N'Secret Data'))
GO
SELECT * FROM [dbo].[CreditCardInformation]
GO
--Расшифрование с помощью симетричного ключа.
SELECT [PersonID], CONVERT(nvarchar(max),  DecryptByKey( [CreditCardNumber])) AS DecryptedData  FROM [dbo].[CreditCardInformation]
GO 

--16.	Продемонстрировать прозрачное шифрование базы данных.
USE master;  
GO  
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<UseStrongPasswordHere>';  
go
CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'My DEK Certificate';  
go  
USE publishing; 
-------------------------------------------настройка--------------------------

------------------------------------------------------------------------------- 
GO  
CREATE DATABASE ENCRYPTION KEY  
WITH ALGORITHM = AES_128  
ENCRYPTION BY SERVER CERTIFICATE MyServerCert;  
GO  
ALTER DATABASE publishing  
SET ENCRYPTION ON;  
GO  

--17.	Продемонстрировать применение хэширования.
select HASHBYTES('SHA1', 'Hesh example');

--18.	Продемонстрировать применение ЭЦП при помощи сертификата.
use [EncryptedDB]
GO
select SignByCert(Cert_Id( 'SampleCert' ),'Sauchuk Aliona', N'pA$$W0RD')

--19.	Сделать резервную копию необходимых ключей и сертификатов.
Backup certificate SampleCert
to File = N'E:\UNIVER\DB\SECURITY-10\BackupSampleCert.cer'
with private key (
File = N'E:\UNIVER\DB\SECURITY-10\BackupSampleCert.pvk',
Encryption by password = N'pA$$W0RD',
Decryption by password = N'pA$$W0RD');