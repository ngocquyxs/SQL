use csdl
CREATE TABLE LOAIMATHANG 
(
MaLoaiMatHang NCHAR(5) NOT NULL
         CONSTRAINT pk_loaimathang PRIMARY KEY,
TenLoaiMatHang NCHAR(100) NOT NULL,
)

CREATE TABLE KHOANGTHOIGIAN 
(
MaKhoangThoiGianGiaoHang NCHAR(5) NOT NULL
         CONSTRAINT pk_khoangthoigian PRIMARY KEY,
MoTa NCHAR(100) NOT NULL,
)

CREATE TABLE KHUVUC 
(
MaKhuVuc NCHAR(5) NOT NULL
         CONSTRAINT pk_khuvuc PRIMARY KEY,
TenKhuVuc NCHAR(100) NOT NULL,
)

CREATE TABLE DICHVU
(
MaDichVu NCHAR(5) NOT NULL
         CONSTRAINT pk_dichvu PRIMARY KEY,
TenDichVu NCHAR(100) NOT NULL,
)

CREATE TABLE THANHVIENGIAOHANG
(
MaThanhVienGiaoHang NCHAR(6) NOT NULL
         CONSTRAINT pk_thanhviengiaohang PRIMARY KEY,
TenThanhVienGiaoHang NCHAR(100) NOT NULL,
NgaySinh DATETIME NOT NULL,
GioiTinh NCHAR(5) NOT NULL
         CONSTRAINT chk_gioitinh CHECK (GioiTinh = 'Nu' OR GioiTinh = 'Nam'),
SoDTThanhVien NCHAR(10) NULL,
DiaChiThanhVien NCHAR (100) NOT NULL,
)

CREATE TABLE DANGKYGIAOHANG
(
MaThanhVienGiaoHang NCHAR(6) NOT NULL,
MaKhoangThoiGianDKGiaoHang NCHAR(5) NOT NULL,
CONSTRAINT pk_dangkygiaohang PRIMARY KEY (MaThanhVienGiaoHang,MaKhoangThoiGianDKGiaoHang),

CONSTRAINT fk_mathoigiandkgiaohang
          FOREIGN KEY (MaKhoangThoiGianDKGiaoHang)
		  REFERENCES KHOANGTHOIGIAN (MaKhoangThoiGianGiaoHang)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,

CONSTRAINT fk_matvgiaohang 
          FOREIGN KEY (MaThanhVienGiaoHang)
		  REFERENCES THANHVIENGIAOHANG (MaThanhVienGiaoHang)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)


CREATE TABLE KHACHHANG 
(
MaKhachHang NCHAR(5) NOT NULL
          CONSTRAINT pk_makhachhang PRIMARY KEY,
MaKhuVuc NCHAR(5) NOT NULL,
TenKhachHang NCHAR(100) NOT NULL,
TenCuaHang NCHAR(100) NOT NULL,
SoDTKhachHang NCHAR(10) NOT NULL,
DiaChiEmail NCHAR(100) NOT NULL,
DiaChiNhanHang NCHAR(100) NOT NULL,

CONSTRAINT fk_makhuvuc
          FOREIGN KEY (MaKhuVuc)
		  REFERENCES KHUVUC(MaKhuVuc)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)

CREATE TABLE DONHANG_GIAOHANG 
(
MaDonHangGiaoHang NCHAR(6) NOT NULL
          CONSTRAINT pk_madonhang PRIMARY KEY,
MaKhachHang NCHAR(5) NOT NULL,
MaThanhVienGiaoHang NCHAR(6) NOT NULL,
MaDichVu NCHAR(5) NOT NULL,
MaKhuVucGiaoHang NCHAR(5) NOT NULL,
TenNguoiNhan NCHAR(100) NOT NULL,
DiaChiGiaoHang NCHAR(100) NOT NULL,
SoDTNguoiNhan NCHAR(10) NOT NULL,
MaKhoangThoiGianGiaoHang NCHAR(5) NOT NULL,
NgayGiaoHang DATETIME NOT NULL,
PhuongThucThanhToan NCHAR(100) NOT NULL,
TrangThaiPheDuyet NCHAR(100) NOT NULL,
TrangThaiGiaoHang NCHAR(100) NULL,

CONSTRAINT fk_makhoangthoigiangiaohang 
          FOREIGN KEY(MaKhoangThoiGianGiaoHang)
		  REFERENCES KHOANGTHOIGIAN(MaKhoangThoiGianGiaoHang)
		  ON UPDATE CASCADE,
CONSTRAINT fk_madichvu
          FOREIGN KEY(MaDichVu)
		  REFERENCES DICHVU(MaDichVu)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
CONSTRAINT fk_mathanhviengiaohang
          FOREIGN KEY (MaThanhVienGiaoHang)
		  REFERENCES THANHVIENGIAOHANG (MaThanhVienGiaoHang)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
CONSTRAINT fk_makhachhang 
          FOREIGN KEY (MaKhachHang)
		  REFERENCES KHACHHANG (MaKhachHang)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
CONSTRAINT fk_khuvuc
          FOREIGN KEY (MaKhuVucGiaoHang)
		  REFERENCES KHUVUC (MaKhuVuc),
)

CREATE TABLE CHITIET_DONHANG 
(
MaDonHangGiaoHang NCHAR(6) NOT NULL,
TenSanPhamDuocGiao NCHAR(50) NOT NULL,
SoLuong NCHAR(5) NOT NULL,
TrongLuong FLOAT(10) NOT NULL,
MaLoaiMatHang NCHAR(100) NOT NULL,
TienThuHo NCHAR(20) NOT NULL,

CONSTRAINT pk_chitiet PRIMARY KEY (MaDonHangGiaoHang,TenSanPhamDuocGiao),

CONSTRAINT fk_madonhang
          FOREIGN KEY (MaDonHangGiaoHang)
		  REFERENCES DONHANG_GIAOHANG (MaDonHangGiaoHang)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)



Use csdl

INSERT INTO LOAIMATHANG(MaLoaiMatHang,TenLoaiMatHang)
VALUES ('MH001','Quan ao'),('MH002','My pham'),('MH003','Do gia dung'),('MH004','Do dien tu')

INSERT INTO KHOANGTHOIGIAN(MaKhoangThoiGianGiaoHang,MoTa)
VALUES ('TG001','7h - 9h AM'),('TG002','9h - 11h AM'),('TG003','1h - 3h PM'),('TG004','3h - 5h PM'),('TG005','7h - 9h30 PM')

INSERT INTO KHUVUC(MaKhuVuc,TenKhuVuc)
VALUES ('KV001','Son Tra'),('KV002','Lien Chieu'),('KV003','Ngu Hanh Son'),('KV004','Hai Chau'),('KV005','Thanh Khe')

INSERT INTO DICHVU(MaDichVu,TenDichVu)
VALUES ('DV001','Giao hang nguoi nhan tra tien phi'),('DV002','Giao hang nguoi gui tra tien phi'),('DV003','Giao hang cong ich (khong tinh phi)')

use csdl

-- 1: Delete customers named "Le Thi A".

delete from KHACHHANG where TenKhachHang = 'Le Thi A';

-- 2: Update customers residing in the "Son Tra" area to the "Ngu Hanh Son" area.

update KHUVUC
set TenKhuVuc = 'Ngu Hanh Son'
where TenKhuVuc = 'Son Tra';

-- 3: List members (shippers) whose full names start with the letter 'Tr' and are at least 25 characters long (including spaces).

select TenThanhVienGiaoHang
from THANHVIENGIAOHANG 
where TenThanhVienGiaoHang like 'Tr%' and LEN(TenThanhVienGiaoHang) >= 25

-- 4: List orders with NgayGiaoHang as year 2017 and delivery area as "Hai Chau".

select * 
from DONHANG_GIAOHANG DH  join KHUVUC KV
on DH.MaKhuVucGiaoHang = KV.MaKhuVuc
where DH.NgayGiaoHang = 2017 and KV.TenKhuVuc = 'Hai Chau'

-- 5: List MaDonHangGiaoHang, MaThanhVienGiaoHang, TenThanhVienGiaoHang, GiaiGiaoHang,PhuongThucThanhToan of all orders whose status is "Da giao hang". Displayed results are sorted ascending according to NgayGiaoHang and descending according to PhuongThucThanhToan. 

select MaDonHangGiaoHang, DH.MaThanhVienGiaoHang, TenThanhVienGiaoHang,NgayGiaoHang, PhuongThucThanhToan 
from THANHVIENGIAOHANG TV join DONHANG_GIAOHANG DH
on TV.MaThanhVienGiaoHang = DH.MaThanhVienGiaoHang
where DH.TrangThaiGiaoHang = 'Da giao hang'
order by DH.NgayGiaoHang ASC, DH.PhuongThucThanhToan DESC

-- 6: Lists members whose gender is "Male" and have never had any deliveries.
select *
from THANHVIENGIAOHANG TV
where TV.GioiTinh = 'Nam' and TV.MaThanhVienGiaoHang not in 
(select DH.MaThanhVienGiaoHang from DONHANG_GIAOHANG DH)


-- 7: List the full names of customers currently in the system. If the full name is the same, it will only be displayed once (2 different ways).
select TenKhachHang
from KHACHHANG
group by TenKhachHang

select distinct TenKhachHang
from KHACHHANG

-- 8: List MaKhachHang, TenKhachHang, DiaChiNhanHang, MaDonHangGiaoHang, PhuongThucThanhToan, TrangThaiGiaoHang of all existing customers in the system

select KH.MaKhachHang, KH.TenKhachHang, KH.DiaChiNhanHang, DH.MaDonHangGiaoHang, DH.PhuongThucThanhToan, DH.TrangThaiGiaoHang
from KHACHHANG KH join DONHANG_GIAOHANG DH
on KH.MaKhachHang = DH.MaKhachHang

-- 9: List the delivery members whose gender is "Nu" and who each delivered to 10 different customers in the delivery area "Hai Chau"

select GH.MaThanhVienGiaoHang, GH.TenThanhVienGiaoHang
from THANHVIENGIAOHANG GH
where GH.GioiTinh = 'Nu' and GH.MaThanhVienGiaoHang in (
select DH.MaThanhVienGiaoHang
from DONHANG_GIAOHANG DH join KHUVUC KV
on DH.MaKhuVucGiaoHang = KV.MaKhuVuc
where TenKhuVuc = 'Hai Chau' 
group by DH.MaThanhVienGiaoHang
having count (distinct DH.MaKhachHang) > 10 )

-- 10: List customers who have requested delivery in the "Lien Chieu" area and have never received delivery from a delivery member whose gender is "Male".

select KH.MaKhachHang , KH.TenKhachHang
from KHACHHANG KH join DONHANG_GIAOHANG DH
on KH.MaKhachHang = DH.MaKhachHang
join KHUVUC KV
on KV.MaKhuVuc = DH.MaKhuVucGiaoHang
join THANHVIENGIAOHANG TV
on TV.MaThanhVienGiaoHang = DH.MaThanhVienGiaoHang
where KV.TenKhuVuc = 'Lien Chieu' and not TV.GioiTinh = 'Nam'

 