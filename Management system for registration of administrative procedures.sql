use csdl
CREATE TABLE LOAITHUTUC
(
MaLoaiTT NCHAR(5) NOT NULL
    CONSTRAINT pk_loaithutuc PRIMARY KEY,
TenLoaiTT NCHAR(100) NOT NULL,
ThoiHanTraKetQuaToiDa NCHAR(2) NOT NULL,
MucPhi NCHAR(10) NOT NULL,
)

CREATE TABLE CONGDAN
(
MaCD NCHAR(5) NOT NULL
    CONSTRAINT pk_congdan PRIMARY KEY,
HoTenCD NCHAR(100) NOT NULL,
DiaChi NCHAR(100) NOT NULL,
ToDanPho NCHAR(5) NOT NULL,
GioiTinh NCHAR(3) NOT NULL
    CONSTRAINT chk_congdan CHECK (GioiTinh = 'Nam' or GioiTinh = 'Nu'),
HoTenChuHo NCHAR(100) NOT NULL,
QuanHeVoiChuHo NCHAR(100) NOT NULL,
)

CREATE TABLE CANBOTIEPNHAN
(
MaCBTN NCHAR(5) NOT NULL
    CONSTRAINT pk_canbotiepnhan PRIMARY KEY,
HoTenCBTN NCHAR(7) NOT NULL,
ChucVu NCHAR(50) NOT NULL
)

CREATE TABLE YEUCAUTHUTUC
(
MaYeuCau NCHAR(7) NOT NULL
    CONSTRAINT pk_yeucauthutuc PRIMARY KEY,
MaCD NCHAR(5) NOT NULL,
NoiDungYeuCau NCHAR(100) NOT NULL,
MaLoaiTT NCHAR(5) NOT NULL,
ThoiDiemTaoYeuCau DATETIME NOT NULL,
ThoiDiemHenTraKetQua DATETIME NULL,
MaCBTN NCHAR(5) NOT NULL,
TrangThai NCHAR(100) NOT NULL,

CONSTRAINT fk_macd
          FOREIGN KEY (MaCD)
		  REFERENCES CONGDAN (MaCD)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
CONSTRAINT fk_maloaitt
          FOREIGN KEY (MaLoaiTT)
		  REFERENCES LOAITHUTUC (MaLoaiTT)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
CONSTRAINT fk_macbtn
          FOREIGN KEY (MaCBTN)
		  REFERENCES CANBOTIEPNHAN (MaCBTN)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)

CREATE TABLE GIAYTOCANBOSUNG
(
MaYeuCau NCHAR(7) NOT NULL,
TenGiayToCanBoSung NCHAR(100) NOT NULL,
MoTaGiayToCanBoSung NCHAR(100) NOT NULL,
ThoiHanCuoiCungDeBoSung DATETIME NOT NULL,
TinhTrangBoSung NCHAR(100) NOT NULL,

CONSTRAINT pk_giaytobosung PRIMARY KEY (MaYeuCau, TenGiayToCanBoSung),
CONSTRAINT fk_mayeucau
          FOREIGN KEY (MaYeuCau)
		  REFERENCES YEUCAUTHUTUC (MaYeuCau)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)


CREATE TABLE GIAYTOKEMTHEO
(
MaYeuCau NCHAR(7) NOT NULL,
TenGiayToKemTheo NCHAR(100) NOT NULL,
MoTaGiayToKemTheo NCHAR(100) NOT NULL,
ThoiDiemNhanGTKT DATETIME NOT NULL,

CONSTRAINT pk_giaytokemtheo PRIMARY KEY (MaYeuCau, TenGiayToKemTheo),
CONSTRAINT fk_giaytokemtheo
          FOREIGN KEY (MaYeuCau)
		  REFERENCES YEUCAUTHUTUC (MaYeuCau)
		  ON DELETE CASCADE
		  ON UPDATE CASCADE,
)


use csdl

-- 1:Delete the citizens in residential group 13.
delete from CONGDAN where ToDanPho = 'To 13'

-- 2: Update the types of procedures that have a maximum time limit of 2 (days) to return results to 5 (days).
update LOAITHUTUC
set ThoiHanTraKetQuaToiDa = '5'
where ThoiHanTraKetQuaToiDa = '2'

-- 3: List citizens whose full names start with the letter 'Ng', end with the letter 'g' and have a maximum length of 50 characters (including spaces).
select CD.MaCD, CD.HoTenCD
from CONGDAN CD
where CD.HoTenCD like 'Ng%' and CD.HoTenCD like '%g' and LEN(CD.HoTenCD) <= 50

-- 4: List requests whose creation date is in 2016 or 2019.
select YC.MaYeuCau, YC.NoiDungYeuCau
from YEUCAUTHUTUC YC
where YEAR(YC.ThoiDiemTaoYeuCau) = 2016 or YEAR(YC.ThoiDiemTaoYeuCau) = 2019

-- 5: List MaYeuCau, MaCD, NoiDungYeuCau, ThoiDiemTaoYeuCau, ThoiDiemHenTraKetQua, TrangThai of all requests whose status is "Da tiep nhan xu ly". Displayed results are arranged in descending order according to MaCD and ascending according to ThoiDiemHenTraKetQua.
select YC.MaCD, YC.MaYeuCau, YC.NoiDungYeuCau, YC.ThoiDiemTaoYeuCau, YC.ThoiDiemHenTraKetQua, YC.TrangThai
from YEUCAUTHUTUC YC
where YC.TrangThai = 'Da tiep nhan xu ly'
order by YC.ThoiDiemHenTraKetQua ASC, YC.MaCD DESC

-- 6: List officials whose position is "Can bo ho tich" and have never received any requests from citizens.
select CB.MaCBTN, CB.HoTenCBTN
from CANBOTIEPNHAN CB
where CB.ChucVu = 'Can bo ho tich' and CB.MaCBTN not in 
(select YC.MaCBTN from YEUCAUTHUTUC YC)

-- 7: List the full names of citizens currently in the system. If the full name is the same, it will only be displayed once (2 different ways).
select distinct CD.HoTenCD
from CONGDAN CD

select CD.HoTenCD
from CONGDAN CD
group by CD.HoTenCD

-- 8: List MaCD, HoTenCD, MaYeuCau, NoiDungYeuCau, TrangThai of all citizens in the system (if a citizen has never created a request, that citizen's information must also be displayed).
select CD.MaCD, CD.HoTenCD, YC.MaYeuCau, YC.NoiDungYeuCau, YC.TrangThai
from CONGDAN CD left join YEUCAUTHUTUC YC
on CD.MaCD = YC.MaCD

-- 9: List citizens who are heads of households and have created at least 10 different requests in the first half of 2019.
select YC.MaCD
from YEUCAUTHUTUC YC
where MONTH(YC.ThoiDiemTaoYeuCau) <= 6 and YEAR(YC.ThoiDiemTaoYeuCau) = 2019 and YC.MaCD in 
(select CD.MaCD from CONGDAN CD
where CD.QuanHeVoiChuHo = 'Ban than')
group by YC.MaCD
having count (YC.MaYeuCau) >= 10

select CD.MaCD
from CONGDAN CD
where CD.QuanHeVoiChuHo = 'Ban than' and CD.MaCD in
(select YC.MaCD from YEUCAUTHUTUC YC
where MONTH(YC.ThoiDiemTaoYeuCau) <= 6 and YEAR(YC.ThoiDiemTaoYeuCau) = 2019
group by YC.MaCD
having count(YC.MaYeuCau) >= 10

-- 10: Lists citizens who have ever created a request with the procedure type named 'Chung nhan doc than' and have never created a request with the procedure type named 'Dang ky ket hon' in October 2019.
select CD.MaCD
from CONGDAN CD join YEUCAUTHUTUC YC
on CD.MaCD = YC.MaCD
join LOAITHUTUC LTT
on LTT.MaLoaiTT = YC.MaLoaiTT
where LTT.TenLoaiTT = 'Chung nhan doc than' and CD.MaCD in 
(select CD.MaCD
from CONGDAN CD join YEUCAUTHUTUC YC
on CD.MaCD = YC.MaCD
join LOAITHUTUC LTT
on LTT.MaLoaiTT = YC.MaLoaiTT
where MONTH(YC.ThoiDiemTaoYeuCau) =10 and YEAR(YC.ThoiDiemTaoYeuCau) = 2019 and not LTT.TenLoaiTT = 'Dang ky ket hon')
