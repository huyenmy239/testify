USE [TTN]
GO
/****** Object:  View [dbo].[V_BODETABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_BODETABLE]
AS
SELECT * FROM BODE
GO
/****** Object:  View [dbo].[V_COSOTABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_COSOTABLE]
AS
SELECT * FROM COSO
GO
/****** Object:  View [dbo].[V_DanhSachGVChuaCoUsername]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_DanhSachGVChuaCoUsername]
AS
    SELECT 
        GV.MAGV, 
        GV.HO, 
        GV.TEN
    FROM 
        GIAOVIEN GV
    LEFT JOIN 
        sys.database_principals DP
    ON 
        GV.MAGV = DP.name
    WHERE 
        DP.name IS NULL
GO
/****** Object:  View [dbo].[V_DSPHANMANH]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_DSPHANMANH]
AS
SELECT p.description AS 'TenCoSo', s.subscriber AS 'Server'
FROM distribution.dbo.MSpublications AS p, distribution.dbo.MSmerge_subscriptions AS s
WHERE p.publication_id = s.publication_id
GO
/****** Object:  View [dbo].[V_DSSINHVIENDANGKY]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_DSSINHVIENDANGKY] AS
SELECT 
    SV.MASV,
    SV.HO + ' ' + SV.TEN AS Ten,
    CS.MACS
FROM 
    Sinhvien SV
JOIN 
    Lop L ON SV.MALOP = L.MALOP
JOIN 
    Khoa K ON L.MAKH = K.MAKH
JOIN 
    Coso CS ON K.MACS = CS.MaCS

WHERE SV.PASSWORD is NULL
GO
/****** Object:  View [dbo].[V_GIAOVIENCOSOTABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_GIAOVIENCOSOTABLE]
AS
SELECT GV.MAGV, GV.HO, GV.TEN, GV.DIACHI, GV.MAKH
FROM GIAOVIEN GV
INNER JOIN KHOA K
	ON K.MAKH = GV.MAKH
GO
/****** Object:  View [dbo].[V_GIAOVIENTABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_GIAOVIENTABLE]
AS
SELECT * FROM GIAOVIEN
GO
/****** Object:  View [dbo].[V_GVDKTABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_GVDKTABLE]
AS
SELECT * FROM GIAOVIEN_DANGKY
GO
/****** Object:  View [dbo].[V_KHOATABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_KHOATABLE]
AS
SELECT * FROM KHOA
GO
/****** Object:  View [dbo].[V_LOPTABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_LOPTABLE]
AS
SELECT * FROM LOP
GO
/****** Object:  View [dbo].[V_MONHOCTABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_MONHOCTABLE]
AS
SELECT * FROM MONHOC
GO
/****** Object:  View [dbo].[V_SINHVIENTABLE]    Script Date: 15/07/2024 7:19:02 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_SINHVIENTABLE]
AS
SELECT * FROM SINHVIEN
GO
