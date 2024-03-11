use csdl
CREATE TABLE DON_VI_UNG_HO 
(
MaDVUH NCHAR(5) NOT NULL
     CONSTRAINT pk_madvuh PRIMARY KEY,
HoTenNguoiDaiDien NCHAR(100) NOT NULL,
DiaChiNguoiDaiDien NCHAR(100) NOT NULL,
SoDienThoaiLienLac NCHAR(10) NOT NULL,
SoCMNDNguoiDaiDien NCHAR(9) NOT NULL,
SoTaiKhoanNganHang NCHAR(8) NOT NULL,
TenNganHang NCHAR(100) NOT NULL,
ChiNhanhNganHang NCHAR(100) NOT NULL,
TenChuTKNganHang NCHAR(100) NOT NULL,
)

CREATE TABLE DOT_UNG_HO
(
MaDotUngHo NCHAR(5) NOT NULL
     CONSTRAINT pk_madotungho PRIMARY KEY,
MaDVUH NCHAR(5) NOT NULL,
NgayUngHo DATE NOT NULL,

CONSTRAINT fk_madvuh
          FOREIGN KEY (MaDVUH)
		  REFERENCES DON_VI_UNG_HO (MaDVUH)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)

CREATE TABLE HINH_THUC_UH
(
MaHinhThucUH NCHAR(4) NOT NULL
     CONSTRAINT pk_mahinhthucuh PRIMARY KEY,
TenHinhThucUH NCHAR(100) NOT NULL,
)

CREATE TABLE CHI_TIET_UNG_HO
(
MaDotUngHo NCHAR(5) NOT NULL,
MaHinhThucUH NCHAR(4) NOT NULL,
SoLuongUngHo NCHAR(20) NOT NULL,
DonViTinh NCHAR(20) NOT NULL,

CONSTRAINT pk_chitietungho PRIMARY KEY (MaDotUngHo, MaHinhThucUH),
CONSTRAINT fk_madotuh
          FOREIGN KEY (MaDotUngHo)
		  REFERENCES DOT_UNG_HO (MaDotUngHo)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
CONSTRAINT fk_mahinhthucuh
          FOREIGN KEY (MaHinhThucUH)
		  REFERENCES HINH_THUC_UH (MaHinhThucUH)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)

CREATE TABLE HO_DAN
(
MaHoDan NCHAR(5) NOT NULL
     CONSTRAINT pk_mahodan PRIMARY KEY,
HoTenChuHo NCHAR(100) NOT NULL,
ToDanPho NCHAR(2) NOT NULL,
KhoiHoacThon NCHAR(1) NOT NULL,
SoDienThoai NCHAR(10) NOT NULL,
DiaChiNha NCHAR(100) NOT NULL,
SoNhanKhau NCHAR(1) NOT NULL,
DienGiaDinh NCHAR(100) NOT NULL,
LaHoNgheo NCHAR(5) NOT NULL
     CONSTRAINT chk_hongheo CHECK (LaHoNgheo = 'Dung' OR LaHoNgheo = 'Sai'),
)

CREATE TABLE DOT_NHAN_UNG_HO
(
MaDotNhanUngHo NCHAR(9) NOT NULL
     CONSTRAINT pk_madotnhan PRIMARY KEY,
MaHoDan NCHAR(5) NOT NULL,
NgayNhanUngHo DATE NOT NULL,

CONSTRAINT fk_mahodan
          FOREIGN KEY (MaHoDan)
		  REFERENCES HO_DAN (MaHoDan)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)

CREATE TABLE CHI_TIET_NHAN_UNG_HO
(
MaDotNhanUngHo NCHAR(9) NOT NULL,
MaHinhThucUH NCHAR(4) NOT NULL,
SoLuongNhanUngHo NCHAR(20) NOT NULL,
DonViTinh NCHAR(20) NOT NULL,

CONSTRAINT pk_chitietnhan PRIMARY KEY (MaDotNhanUngHo, MaHinhThucUH),
CONSTRAINT fk_mahinhthuc
          FOREIGN KEY (MaHinhThucUH)
		  REFERENCES HINH_THUC_UH (MaHinhThucUH)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
CONSTRAINT fk_madotnhan
          FOREIGN KEY (MaDotNhanUngHo)
		  REFERENCES DOT_NHAN_UNG_HO (MaDotNhanUngHo)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)

use csdl

-- 1: Delete supporters with bank accounts opened at "DongA" bank
delete from DON_VI_UNG_HO where TenNganHang = 'DongA';

-- 2: Update the form of support called "Mi tom" to "Mi an lien"
update HINH_THUC_UH
set TenHinhThucUH = 'Mi an lien'
where TenHinhThucUH = 'Mi tom'

-- 3: List householders whose full names start with the letter 'Ph' and have a maximum length of 30 characters (including whitespace)
select HD.HoTenChuHo
from HO_DAN HD
where HD.HoTenChuHo like 'Ph%' and LEN(HD.HoTenChuHo) <= 30

-- 4: List the donations have "NgayNhanUngHo" in 2015 and with "MaHoDan" ending with the character '1' (digit number 1)
select DN.MaDotNhanUngHo
from DOT_NHAN_UNG_HO DN 
where DN.MaHoDan like '%1' and YEAR(DN.NgayNhanUngHo) = 2015

-- 5: List MaDVUH, HoTenNguoiDaiDien, MaDotUngHo, NgayUngHo of donations that took place before April 30, 2016. Displayed results need to be sorted descending according to NgayUngHo and ascending according to HoTenNguoiDaiDien
select DV.MaDVUH, DV.HoTenNguoiDaiDien, DUH.MaDotUngHo,DUH.NgayUngHo
from DON_VI_UNG_HO DV join DOT_UNG_HO DUH
on DV.MaDVUH = DUH.MaDVUH
where DUH.NgayUngHo < '2016-04-30'
order by DV.HoTenNguoiDaiDien ASC , DUH.NgayUngHo DESC

-- 6: List households that are poor and have never received support
select *
from HO_DAN HD
where HD.LaHoNgheo = 'Dung' and HD.MaHoDan not in 
(select DN.MaHoDan from DOT_NHAN_UNG_HO DN)

-- 7: List the full names of householders currently in the system. If the full name is the same, it will only be displayed once (2 different ways).
select distinct HoTenChuHo 
from HO_DAN

select HoTenChuHo
from HO_DAN
group by HoTenChuHo

-- 8: List MaHoDan, HoTenChuHo, ToDanPho, KhoiHoacThon, MaDotNhanUngHo, NgayNhanUngHo, MaHinhThucUH, SoLuongNhanUngHo, DonViTinh of all households in the system
select HD.MaHoDan, HD.HoTenChuHo, HD.ToDanPho, HD.KhoiHoacThon, DN.MaDotNhanUngHo, DN.NgayNhanUngHo, CT.MaHinhThucUH, CT.SoLuongNhanUngHo, CT.DonViTinh
from HO_DAN HD join DOT_NHAN_UNG_HO DN
on HD.MaHoDan = DN.MaHoDan
join CHI_TIET_NHAN_UNG_HO CT
on DN.MaDotNhanUngHo = CT.MaDotNhanUngHo

-- 9: List supporters who have bank accounts at "DongA" bank and have supported people at least 5 times with TenHinhThucUngHo as "Mi an lien" in 2016
select DV.MaDVUH, DV.HoTenNguoiDaiDien
from DON_VI_UNG_HO DV
where DV.TenNganHang = 'DongA' and DV.MaDVUH in 
(select DUH.MaDVUH 
from DOT_UNG_HO DUH join CHI_TIET_UNG_HO CT
on DUH.MaDotUngHo = CT.MaDotUngHo
join HINH_THUC_UH HT
on CT.MaHinhThucUH = HT.MaHinhThucUH
where YEAR(DUH.NgayUngHo) = 2016 and HT.TenHinhThucUH = 'Mi an lien'
group by DUH.MaDVUH
having count (DUH.MaDotUngHo) >= 5
)

-- 10: List households that have received support with TenHinhThucUngHo as "Mi an lien" and have never received support with TenHinhThucUngHo as "Gao"
select HD.MaHoDan, HD.HoTenChuHo
from HO_DAN HD join DOT_NHAN_UNG_HO DN
on HD.MaHoDan = DN.MaHoDan
join CHI_TIET_NHAN_UNG_HO CTN
on DN.MaDotNhanUngHo = CTN.MaDotNhanUngHo
join HINH_THUC_UH HT
on CTN.MaHinhThucUH = HT.MaHinhThucUH
where HT.TenHinhThucUH = 'Mi an lien' and not HT.TenHinhThucUH = 'Gao'