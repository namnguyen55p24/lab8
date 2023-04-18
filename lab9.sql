/***câu 1**/
CREATE TRIGGER tr_nhap
ON Nhap
AFTER INSERT
AS
BEGIN
    -- Kiểm tra mã sản phẩm và mã nhân viên có tồn tại
    IF NOT EXISTS (SELECT 1 FROM Sanpham WHERE masp IN (SELECT masp FROM inserted))
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng Sanpham.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Nhanvien WHERE manv IN (SELECT manv FROM inserted))
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng Nhanvien.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    -- Kiểm tra ràng buộc dữ liệu: soluongN và dongiaN > 0
    IF EXISTS (SELECT 1 FROM inserted WHERE soluongN <= 0 OR dongiaN <= 0)
    BEGIN
        RAISERROR('Số lượng và đơn giá nhập phải lớn hơn 0.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    -- Cập nhật số lượng sản phẩm trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong + i.soluongN
    FROM inserted i
    WHERE Sanpham.masp = i.masp;
END;
/***câu 2 **/
CREATE TRIGGER kiem_soat_nhap
BEFORE INSERT ON Nhap
FOR EACH ROW
BEGIN
    -- Kiểm tra ràng buộc toàn vẹn
    IF NOT EXISTS(SELECT 1 FROM Sanpham WHERE masp = NEW.masp) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã sản phẩm không tồn tại trong bảng Sanpham';
    END IF;
    
    IF NOT EXISTS(SELECT 1 FROM Nhanvien WHERE manv = NEW.manv) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã nhân viên không tồn tại trong bảng Nhanvien';
    END IF;
    
    -- Kiểm tra ràng buộc dữ liệu
    IF NEW.soluongX > (SELECT soluong FROM Sanpham WHERE masp = NEW.masp) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Số lượng nhập vượt quá số lượng tồn kho của sản phẩm';
    END IF;
    
    -- Cập nhật số lượng sản phẩm sau khi nhập
    UPDATE Sanpham SET soluong = soluong - NEW.soluongX WHERE masp = NEW.masp;
END;
/**câu 3**/
CREATE TRIGGER update_sanpham ON Phieuxuat
AFTER DELETE
AS
BEGIN
   UPDATE Sanpham SET SoLuong = SoLuong + (SELECT SoLuong FROM DELETED WHERE Masp = Sanpham.masp);
END;

/**câu 4**/
CREATE TRIGGER update_xuat ON Xuat
AFTER UPDATE
AS
BEGIN
   IF (SELECT COUNT(*) FROM INSERTED) > 1
   BEGIN
      RAISERROR('Chỉ được phép cập nhật một bản ghi tại một thời điểm.', 16, 1)
      ROLLBACK TRANSACTION
      RETURN
   END

   DECLARE @MaSanPham INT
   DECLARE @SoLuong INT
   DECLARE @SoLuongConLai INT

   SELECT @MaSanPham = i.masp, @SoLuong = i.soluongX FROM INSERTED i
   SELECT @SoLuongConLai = s.SoLuong FROM Sanpham s WHERE s.Masp = @MaSanPham

   IF @SoLuongConLai - @SoLuong < 0
   BEGIN
      RAISERROR('Số lượng sản phẩm trong kho không đủ.', 16, 1)
      ROLLBACK TRANSACTION
      RETURN
   END

   UPDATE Xuat SET soluongX = @SoLuong WHERE Masp = @MaSanPham
   UPDATE Sanpham SET SoLuong = @SoLuongConLai - @SoLuong WHERE masp = @MaSanPham
END;
/**câu 5**/
CREATE TRIGGER update_soluong_nhap
AFTER UPDATE ON Nhap
FOR EACH ROW
BEGIN
    DECLARE num_rows_changed INT;
    SET num_rows_changed = (SELECT ROW_COUNT());
    
    IF num_rows_changed > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không được phép cập nhật quá một bản ghi!';
    ELSE
        UPDATE Nhap SET soluong = NEW.soluong WHERE id = NEW.id;
        UPDATE Sanpham SET soluong = soluong + NEW.soluong - OLD.soluong WHERE id = NEW.sanpham_id;
    END IF;
END;
/**câu 6**/
CREATE TRIGGER delete_Nhap
AFTER DELETE ON Nhap
FOR EACH ROW
BEGIN
    UPDATE Sanpham SET soluong = soluong - OLD.soluong WHERE id = OLD.sanpham_id;
END;

