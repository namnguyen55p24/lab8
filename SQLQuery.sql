/**c�u 1**/
CREATE PROCEDURE spThemMoiNhanVien 
(
    @manv varchar(10),
    @tennv nvarchar(50),
    @gioitinh nvarchar(10),
    @diachi nvarchar(100),
    @sodt varchar(20),
    @email varchar(50),
    @phong varchar(50),
    @flag bit
)
AS
BEGIN
IF (@gioitinh <> 'Nam' AND @gioitinh <> 'N?')
    BEGIN
        RETURN 1 -- Tr? v? m� l?i 1 n?u gi?i t�nh kh�ng h?p l?
    END

    IF (@flag = 0)
    BEGIN
        INSERT INTO Nhanvien(manv, tennv, gioitinh, diachi, sodt, email, phong)
        VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)
    END
    ELSE
    BEGIN
        UPDATE Nhanvien
        SET tennv = @tennv, gioitinh = @gioitinh, diachi = @diachi, sodt = @sodt, email = @email,
            phong = @phong
        WHERE manv = @manv
    END

    RETURN 0 -- Tr? v? m� l?i 0 n?u th?c hi?n th�nh c�ng
END

EXEC spThemMoiNhanVien 'NV001', N'Nguy?n Th? H?ng', 'N?', N'123 ???ng A', '0987654320', 'nva@gmail.com', 'K? to�n', 0
/**c�u 2**/
CREATE PROCEDURE ThemSanPham 
    @masp VARCHAR(10), 
    @tenhang VARCHAR(50), 
    @tensp NVARCHAR(100), 
    @soluong INT, 
    @mausac NVARCHAR(50), 
    @giaban FLOAT, 
    @donvitinh NVARCHAR(20), 
    @mota NVARCHAR(MAX), 
    @flag INT
AS 
BEGIN 
  IF @flag = 0 -- th�m m?i s?n ph?m
    BEGIN
        IF NOT EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
            RETURN 1 -- tr? v? m� l?i 1 n?u tenhang kh�ng c� trong b?ng hangsx
        IF @soluong < 0
		 RETURN 2 -- tr? v? m� l?i 2 n?u soluong < 0
        INSERT INTO Sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang), @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
    END
    ELSE -- c?p nh?t s?n ph?m
    BEGIN
		IF @soluong < 0
            RETURN 2 -- tr? v? m� l?i 2 n?u soluong < 0
        UPDATE Sanpham 
        SET mahangsx = (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang), 
            tensp = @tensp, 
            soluong = @soluong, 
            mausac = @mausac, 
            giaban = @giaban, 
            donvitinh = @donvitinh, 
            mota = @mota 
        WHERE masp = @masp
    END 
    RETURN 0 -- tr? v? m� l?i 0 n?u kh�ng c� l?i 
END
EXEC ThemSanPham 'SP06', 'Iphone', 'iPhone 12', 10, 'T�m', 20000000, 'C�i', N'Th? h? m?i', 0
SELECT*FROM SANPHAM
/**c�u 3**/
CREATE PROCEDURE XOA_NHANVIEN
    @MANV NCHAR(10)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM NHANVIEN WHERE MANV = @MANV)
    BEGIN
        RETURN 1
    END
    ELSE
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY
			  DELETE FROM BANGNHAP WHERE MANV = @MANV
            DELETE FROM BANGXUAT WHERE MANV = @MANV
            DELETE FROM NHANVIEN WHERE MANV = @MANV
            COMMIT TRANSACTION
            RETURN 0
        END TRY
        BEGIN CATCH
		ROLLBACK TRANSACTION
            RETURN 1
        END CATCH
    END
END
EXECUTE XOA_NHANVIEN 'NV03'
/**c�u 4**/
CREATE PROCEDURE XOA_SANPHAM
    @MASP NCHAR(10)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM SANPHAM WHERE MASP = @MASP)
    BEGIN
        RETURN 1
    END
    ELSE
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY
            DELETE FROM BANGNHAP WHERE MASP = @MASP
            DELETE FROM BANGXUAT WHERE MASP = @MASP
            DELETE FROM SANPHAM WHERE MASP = @MASP
            COMMIT TRANSACTION
            RETURN 0
			 END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RETURN 1
        END CATCH
    END
END
EXECUTE XOA_SANPHAM'SP07'