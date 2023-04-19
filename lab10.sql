-- lap 10 -- 
--cau 1 --
--a--
INSERT INTO Nhanvien
VALUES ('NV06', 'Nguyễn Thu', 'Nam', 'Nam Định', '0982626222', 'thung@gmail.com', 'markerting')
BACKUP DATABASE [Quanlibanhang] TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Quanlibanhang.bak'
--b-- 
INSERT INTO Nhanvien
VALUES ('NV07', 'Nguyễn bá hải', 'Nam', 'Hải dương', '0986887894', 'bahai@gmail.com', 'nhân sự')
BACKUP DATABASE [Quanlibanhang] TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Quanlibanhang.bak' with differential 
--c-- 
INSERT INTO Nhanvien
VALUES ('NV08', 'Trần hiệp', 'Nam', 'Gia lai', '08667848438', 'hiepga@gmail.com', 'kho bãi')
BACKUP  LOG  [Quanlibanhang] TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Quanlibanhang.bak'

-- cau 2 -- 
RESTORE DATABASE [Quanlibanhang] FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Quanlibanhang.bak' WITH standby 
RESTORE DATABASE [Quanlibanhang] FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Quanlibanhang.bak' WITH standby 
RESTORE LOG [Quanlibanhang] FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Quanlibanhang.bak' 