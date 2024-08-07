USE master
GO
-- LOGIN FOR ROLE [Truong] --
CREATE LOGIN kdt
WITH PASSWORD = '239003',
CHECK_POLICY = OFF,
CHECK_EXPIRATION = OFF
GO
ALTER SERVER ROLE [processadmin] ADD MEMBER kdt
GO
ALTER SERVER ROLE [securityadmin] ADD MEMBER kdt
GO

-- LOGIN FOR ROLE [Coso] --
CREATE LOGIN pvh
WITH PASSWORD = '239003',
CHECK_POLICY = OFF,
CHECK_EXPIRATION = OFF
GO
ALTER SERVER ROLE [processadmin] ADD MEMBER pvh
GO
ALTER SERVER ROLE [securityadmin] ADD MEMBER pvh
GO

-- LOGIN FOR ROLE [Giangvien] --
CREATE LOGIN dvt
WITH PASSWORD = '239003',
CHECK_POLICY = OFF,
CHECK_EXPIRATION = OFF
GO
ALTER SERVER ROLE [processadmin] ADD MEMBER dvt
GO

-- LOGIN FOR ROLE [Sinhvien] --
CREATE LOGIN lvt
WITH PASSWORD = '239003',
CHECK_POLICY = OFF,
CHECK_EXPIRATION = OFF
GO

USE [TTN]
GO
-- CREATE AND GRANT PERMISSIONS FOR ROLE [Truong] --
CREATE ROLE Truong
GO
ALTER ROLE [db_datareader] ADD MEMBER Truong
GO
ALTER ROLE [db_accessadmin] ADD MEMBER Truong
GO
ALTER ROLE [db_securityadmin] ADD MEMBER Truong
GO

GRANT EXEC ON [dbo].[SP_LayCauHoiTheoMAGV] TO Truong
GO
GRANT EXEC ON [dbo].[SP_LayDangKyTheoMAGV] TO Truong
GO
GRANT EXEC ON [dbo].[SP_LayThongTinGiangVien] TO Truong
GO
GRANT EXEC ON [dbo].[SP_TaoMaCauHoi] TO Truong
GO
GRANT EXEC ON [dbo].[SP_TaoTaiKhoan] TO Truong
GO

CREATE USER TH101 FOR LOGIN kdt
GO
ALTER ROLE Truong ADD MEMBER TH101
GO

-- CREATE AND GRANT PERMISSIONS FOR ROLE [Coso] --
CREATE ROLE Coso
GO
ALTER ROLE [db_owner] ADD MEMBER Coso
GO
ALTER ROLE [db_accessadmin] ADD MEMBER Coso
GO
ALTER ROLE [db_securityadmin] ADD MEMBER Coso
GO

CREATE USER TH123 FOR LOGIN pvh
GO
ALTER ROLE Coso ADD MEMBER TH123
GO

-- CREATE AND GRANT PERMISSIONS FOR ROLE [Giangvien] --
CREATE ROLE Giangvien
GO

GRANT SELECT, INSERT, DELETE, UPDATE ON [dbo].[BODE] TO Giangvien
GO
GRANT SELECT ON [dbo].[LOP] TO Giangvien
GO
GRANT SELECT ON [dbo].[MONHOC] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_DELETE_BODE] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_EXISTED_BODE] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_INSERT_BODE] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_LAY_CAU_HOI] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_LayCauHoi] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_LayCauHoiTheoMAGV] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_LayDangKyTheoMAGV] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_LayThongTinGiangVien] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_REPORT_InBangDiemMonHoc] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_TAO_CAU_HOI] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_TaoCauHoi] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_UPDATE_BODE] TO Giangvien
GO
GRANT EXEC ON [dbo].[SP_DSDangKyThi] TO Giangvien
GO

CREATE USER TH234 FOR LOGIN dvt
GO
ALTER ROLE Giangvien ADD MEMBER TH234
GO

-- CREATE AND GRANT PERMISSIONS FOR ROLE [Sinhvien] --
CREATE ROLE Sinhvien
GO

GRANT SELECT, INSERT, UPDATE ON [dbo].[BAITHI] TO Sinhvien
GO
GRANT SELECT, INSERT, UPDATE ON [dbo].[CT_BAITHI] TO Sinhvien
GO
GRANT SELECT, UPDATE ON [dbo].[SINHVIEN] TO Sinhvien
GO
GRANT SELECT ON [dbo].[GIAOVIEN] TO Sinhvien
GO
GRANT SELECT ON [dbo].[LOP] TO Sinhvien
GO
GRANT SELECT ON [dbo].[MONHOC] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_LAY_CAU_HOI] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_LayBaiThiDaDangKyTheoMaLop] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_LayCauHoi] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_LayDangKyHetHieuLucTheoMaSV] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_LayDangKyTheoMaSV] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_LayThongTinSinhVien] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_SinhVienDangKy] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_TAO_CAU_HOI] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_TaoBaiThi] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_TaoCauHoi] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_ThongTinBaiThi] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_LayDangKyDaThiTheoMaSV] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_TinhDiem] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_TraLoiCauHoi] TO Sinhvien
GO
GRANT EXEC ON [dbo].[SP_UpdateTime] TO Sinhvien
GO

CREATE USER student FOR LOGIN lvt
GO
ALTER ROLE Sinhvien ADD MEMBER student
GO
