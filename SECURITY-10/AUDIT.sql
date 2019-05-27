--1.	�������� � ���������, ����� ����� �������������� ������������ ��� ���������� SQL Server.

--2.	������� ����������� ������� ������, ���� � �������������. 
USE publishing
GO
GRANT ALTER ANY DATABASE AUDIT TO lab_9_admin;
GO

--3.	������� ��� ���������� SQL Server ������ ������.
--4.	������ ��� ���������� ������ ����������� ������������. 
USE master;
GO
CREATE SERVER AUDIT HIPAA_Audit  
    TO APPLICATION_LOG;
GO  
 
--5.	��������� ��������� �����, ������������������ ������ ������.
ALTER SERVER AUDIT HIPAA_Audit  
WITH (STATE = ON);  
GO 

--6.	������� ����������� ������� ������.
--7.	������ ��� ������ ����������� ������������.
--8.	��������� ����� ��, ������������������ ������ ������
USE publishing;   
GO    
CREATE DATABASE AUDIT SPECIFICATION Audit_Pay_Tables  
FOR SERVER AUDIT HIPAA_Audit 
ADD (SELECT, INSERT ON SoldBooks BY dbo )   --audit_action_specification
WITH (STATE = ON) ;   
GO

--9.	���������� ����� �� � �������.
ALTER SERVER AUDIT HIPAA_Audit  
WITH (STATE = OFF);  
GO 
USE publishing
GO
ALTER DATABASE AUDIT SPECIFICATION Audit_Pay_Tables
WITH (STATE = OFF);  
GO 

--10.	������� ��� ���������� SQL Server ������������� ���� ����������.
CREATE ASYMMETRIC KEY PacificSales09   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = '<StrongPasswordHere>';   
GO  

--11.	����������� � ������������ ������ ��� ������ ����� �����.
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
--���������� � ������� �������������� �����.
INSERT INTO [dbo].[CreditCardInformation]
VALUES (ENCRYPTBYASYMKEY( AsymKey_ID('PacificSales09') , N'QW���������E12�4��������������3'))
GO
SELECT * FROM [dbo].[CreditCardInformation]
GO
--������������� � ������� �������������� �����.
SELECT [PersonID], CONVERT(nvarchar(max),  DecryptByAsymKey( AsymKey_Id('PacificSales09'), [CreditCardNumber], N'<StrongPasswordHere>'))   
AS DecryptedData   
FROM [dbo].[CreditCardInformation]
GO  

--12.	������� ��� ���������� SQL Server ����������.
use [EncryptedDB]
go
drop certificate SampleCert
create certificate SampleCert
encryption by password = N'pA$$W0RD'
with subject = N'���� ��������',
Expiry_DATE = N'31/10/2022';

--13.	����������� � ������������ ������ ��� ������ ����� �����������.
INSERT INTO [dbo].[CreditCardInformation] values(EncryptByCert(Cert_ID('SampleCert'), N'��������� ������'));
GO
SELECT * FROM [dbo].[CreditCardInformation]
GO
SELECT (Convert(Nvarchar(100), DecryptByCert(Cert_ID('SampleCert'), CreditCardInformation.CreditCardNumber, N'pA$$W0RD'))) FROM [dbo].[CreditCardInformation];
GO

--14.	������� ��� ���������� SQL Server ������������ ���� ���������� ������.
--��� ���������� ���� �����
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
--15.	����������� � ������������ ������ ��� ������ ����� �����.
--���������� � ������� ������������ �����.
INSERT INTO [dbo].[CreditCardInformation] VALUES (ENCRYPTBYKEY( Key_GUID('SData') , N'Secret Data'))
GO
SELECT * FROM [dbo].[CreditCardInformation]
GO
--������������� � ������� ������������ �����.
SELECT [PersonID], CONVERT(nvarchar(max),  DecryptByKey( [CreditCardNumber])) AS DecryptedData  FROM [dbo].[CreditCardInformation]
GO 

--16.	������������������ ���������� ���������� ���� ������.
USE master;  
GO  
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<UseStrongPasswordHere>';  
go
CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'My DEK Certificate';  
go  
USE publishing; 
-------------------------------------------���������--------------------------

------------------------------------------------------------------------------- 
GO  
CREATE DATABASE ENCRYPTION KEY  
WITH ALGORITHM = AES_128  
ENCRYPTION BY SERVER CERTIFICATE MyServerCert;  
GO  
ALTER DATABASE publishing  
SET ENCRYPTION ON;  
GO  

--17.	������������������ ���������� �����������.
select HASHBYTES('SHA1', 'Hesh example');

--18.	������������������ ���������� ��� ��� ������ �����������.
use [EncryptedDB]
GO
select SignByCert(Cert_Id( 'SampleCert' ),'Sauchuk Aliona', N'pA$$W0RD')

--19.	������� ��������� ����� ����������� ������ � ������������.
Backup certificate SampleCert
to File = N'E:\UNIVER\DB\SECURITY-10\BackupSampleCert.cer'
with private key (
File = N'E:\UNIVER\DB\SECURITY-10\BackupSampleCert.pvk',
Encryption by password = N'pA$$W0RD',
Decryption by password = N'pA$$W0RD');