﻿USE [TTN]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_READ_POINT]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[FN_READ_POINT]
(
	@NUMBER FLOAT
)
RETURNS NVARCHAR(500)
AS
BEGIN
		DECLARE @RETURN NVARCHAR(500) = N''
		DECLARE @TEMP1 INT = CAST((@NUMBER/1)AS INT)
		DECLARE @TEMP2 INT = CAST(@NUMBER*10 AS INT) % 10
		
		IF @TEMP1 = 0 BEGIN SELECT @RETURN = @RETURN + N'KHÔNG' END
		IF @TEMP1 = 1 BEGIN SELECT @RETURN = @RETURN + N'MỘT' END
		IF @TEMP1 = 2 BEGIN SELECT @RETURN = @RETURN + N'HAI' END
		IF @TEMP1 = 3 BEGIN SELECT @RETURN = @RETURN + N'BA' END 
		IF @TEMP1 = 4 BEGIN SELECT @RETURN = @RETURN + N'BỐN' END
		IF @TEMP1 = 5 BEGIN SELECT @RETURN = @RETURN + N'NĂM' END 
		IF @TEMP1 = 6 BEGIN SELECT @RETURN = @RETURN + N'SÁU' END
		IF @TEMP1 = 7 BEGIN SELECT @RETURN = @RETURN + N'BẢY' END
		IF @TEMP1 = 8 BEGIN SELECT @RETURN = @RETURN + N'TÁM' END
		IF @TEMP1 = 9 BEGIN SELECT @RETURN = @RETURN + N'CHÍN' END 
		IF @TEMP1 = 10 BEGIN SELECT @RETURN = @RETURN + N'MƯỜI' END 
		
		IF @TEMP2 = 1 BEGIN SELECT @RETURN = @RETURN + N' PHẨY MỘT'	END
		IF @TEMP2 = 2 BEGIN SELECT @RETURN = @RETURN + N' PHẨY HAI'	END
		IF @TEMP2 = 3 BEGIN SELECT @RETURN = @RETURN + N' PHẨY BA'	END	
		IF @TEMP2 = 4 BEGIN SELECT @RETURN = @RETURN + N' PHẨY BỐN'	END
		IF @TEMP2 = 5 BEGIN SELECT @RETURN = @RETURN + N' PHẨY NĂM'	END	
		IF @TEMP2 = 6 BEGIN SELECT @RETURN = @RETURN + N' PHẨY SÁU'	END
		IF @TEMP2 = 7 BEGIN SELECT @RETURN = @RETURN + N' PHẨY BẢY'	END
		IF @TEMP2 = 8 BEGIN SELECT @RETURN = @RETURN + N' PHẨY TÁM'	END
		IF @TEMP2 = 9 BEGIN SELECT @RETURN = @RETURN + N' PHẨY CHÍN' END

		RETURN @RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CapQuyenJob]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_CapQuyenJob]
@LGNAME VARCHAR(50),
@USERNAME VARCHAR(50)
AS
BEGIN
	BEGIN TRY
        -- ALTER the login
        DECLARE @SQL NVARCHAR(MAX)

		SET @SQL = N'CREATE USER [' + @USERNAME + '] FOR LOGIN [' + @LGNAME + ']'
        EXEC msdb.sys.sp_executesql @SQL

        -- Add the user to the database role
        SET @SQL = N'ALTER ROLE [Truong] ADD MEMBER [' + @USERNAME + ']'
        EXEC msdb.sys.sp_executesql @SQL

    END TRY
    BEGIN CATCH

        -- Raise an error with details
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_BODE]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DELETE_BODE]
@CAUHOI INT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @isExisted int;
	EXEC @isExisted = [dbo].[SP_EXISTED_BODE] @CAUHOI
	IF @isExisted = 0
		BEGIN
			RAISERROR('Câu hỏi không tồn tại.', 16, 1);
			RETURN 
		END

	IF EXISTS (SELECT 1 FROM LINK0.TTN.DBO.CT_BAITHI WHERE CAUHOI = @CAUHOI)
		BEGIN
			RAISERROR('Câu hỏi đã được dùng để thi.', 16, 1);
			RETURN 
		END

	DECLARE @MAMH CHAR(5)
	DECLARE @TRINHDO CHAR(1)
	SELECT
		@MAMH = MAMH,
		@TRINHDO = TRINHDO
	FROM BODE
	WHERE CAUHOI = @CAUHOI
	
	DECLARE @ErrorMessage NVARCHAR(500)
	SELECT MAMH, MALOP, LAN INTO #TEMP FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND SOCAUTHI >= (SELECT COUNT(*) FROM BODE WHERE MAMH = @MAMH AND TRINHDO IN (CHAR(ASCII(@TRINHDO)+1), @TRINHDO))
	IF EXISTS (SELECT 1 FROM #TEMP)
	BEGIN
		SELECT @ErrorMessage = N'Không thể xóa câu hỏi. '
		SELECT @ErrorMessage = @ErrorMessage + '(' + TRIM(MAMH) + ',' +TRIM(MALOP) + ',' + CAST(LAN AS nvarchar) + ') ' FROM #TEMP
		SELECT @ErrorMessage = @ErrorMessage + N'không đủ câu hỏi để thi'
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN
	END
	
	SELECT MAMH, MALOP, LAN INTO #TEMP2 FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND CEILING(SOCAUTHI*0.7) >= (SELECT COUNT(*) FROM BODE WHERE MAMH = @MAMH AND TRINHDO = @TRINHDO)
	IF EXISTS (SELECT 1 FROM #TEMP2)
	BEGIN
		SELECT @ErrorMessage = N'Không thể xóa câu hỏi. '
		SELECT @ErrorMessage = @ErrorMessage + '(' + TRIM(MAMH) + ',' +TRIM(MALOP) + ',' + CAST(LAN AS nvarchar) + ') ' FROM #TEMP2
		SELECT @ErrorMessage = @ErrorMessage + N'không đủ câu hỏi cùng trình độ để thi'
		RAISERROR(@ErrorMessage, 16, 1)
		RETURN
	END

	DELETE FROM BODE WHERE CAUHOI = @CAUHOI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_DANGKYTHI]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_DELETE_DANGKYTHI]
@MALOP CHAR(15),
@MAMH CHAR(5),
@LAN SMALLINT
AS
BEGIN
	IF EXISTS (
		SELECT 1 FROM BAITHI BT
			INNER JOIN (
				SELECT MASV, MALOP FROM SINHVIEN WHERE MALOP = @MALOP
			) SV ON BT.MASV = SV.MASV
			INNER JOIN (
				SELECT MALOP, MAMH, LAN FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND LAN = @LAN AND MALOP = @MALOP
			) DK ON DK.MALOP = SV.MALOP AND BT.MAMH = DK.MAMH AND BT.LAN = DK.LAN)
	BEGIN
		RAISERROR('Không thể xóa đăng ký vì đã có sinh viên làm bài thi.', 16, 1)
		RETURN
	END

	DELETE FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND MALOP = @MALOP AND LAN = @LAN
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_GIAOVIEN]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DELETE_GIAOVIEN]
@MAGV CHAR(8)
AS
BEGIN
	DECLARE @isExisted int;
	EXEC @isExisted = SP_EXISTED_GIAOVIEN @MAGV
	IF @isExisted = 0
		BEGIN
			RAISERROR('Không tìm thấy mã giảng viên.', 16, 1)
			RETURN
		END
	IF EXISTS (SELECT 1 FROM LINK0.TTN.DBO.BODE WHERE MAGV = @MAGV)
	BEGIN
		RAISERROR('Giảng viên này đã tạo câu hỏi trong bộ đề.', 16, 1)
		RETURN
	END
	IF EXISTS (SELECT 1 FROM LINK0.TTN.DBO.GIAOVIEN_DANGKY WHERE MAGV = @MAGV)
	BEGIN
		RAISERROR('Giảng viên này đã đăng ký thi.', 16, 1)
		RETURN
	END
	DELETE FROM GIAOVIEN WHERE MAGV = @MAGV
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_KHOA]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DELETE_KHOA]
@MAKH CHAR(8)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM KHOA WHERE MAKH = @MAKH)
		BEGIN
			RAISERROR(N'Mã khoa này không tồn tại ở cơ sở này.', 16, 1);
			RETURN
		END

	IF EXISTS (SELECT 1 FROM GIAOVIEN WHERE MAKH = @MAKH)
		BEGIN
			RAISERROR(N'Khoa này đã có giảng viên.', 16, 1);
			RETURN
		END
	IF EXISTS (SELECT 1 FROM LOP WHERE MAKH = @MAKH)
		BEGIN
			RAISERROR(N'Khoa này đã có lớp.', 16, 1);
			RETURN
		END
	DELETE FROM KHOA WHERE MAKH = @MAKH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_LOP]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DELETE_LOP]
@MALOP CHAR(15)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM LOP WHERE MALOP = @MALOP)
	BEGIN
		RAISERROR('Mã lớp không tồn tại ở cơ sở này.', 16, 1);
		RETURN 
	END
	IF EXISTS(SELECT 1 FROM SINHVIEN WHERE MALOP = @MALOP)
	BEGIN
		RAISERROR('Lớp này đã có sinh viên.', 16, 1);
		RETURN 
	END
	IF EXISTS(SELECT 1 FROM GIAOVIEN_DANGKY WHERE MALOP = @MALOP)
	BEGIN
		RAISERROR('Lớp này đã được đăng ký lịch thi.', 16, 1);
		RETURN 
	END
	DELETE FROM LOP WHERE MALOP = @MALOP
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_MONHOC]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DELETE_MONHOC]
@MAMH CHAR(5)
AS
BEGIN
	DECLARE @isExisted int;
	EXEC @isExisted = [dbo].[SP_EXISTED_MONHOC] @MAMH
	IF @isExisted = 0
	  BEGIN
		  RAISERROR(N'Không tìm thấy môn học.',16,1);
		  RETURN
	  END
	  IF EXISTS (SELECT * FROM BODE WHERE MAMH = @MAMH)
	  BEGIN
		  RAISERROR(N'Không thể xóa vì môn học này đã được soạn câu hỏi.',16,1);
		  RETURN
	  END
	  IF EXISTS (SELECT * FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH)
	  BEGIN
		  RAISERROR(N'Không thể xóa vì môn học này đã được đăng ký thi.',16,1);
		  RETURN
	  END
	  IF EXISTS (SELECT * FROM BAITHI WHERE MAMH = @MAMH)
	  BEGIN
		  RAISERROR(N'Không thể xóa vì môn học này đã có bài thi.',16,1);
		  RETURN
	  END
	DELETE FROM MONHOC WHERE @MAMH = MONHOC.MAMH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_SINHVIEN]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DELETE_SINHVIEN]
@MASV CHAR(8)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM SINHVIEN WHERE MASV = @MASV)
		BEGIN 
			RAISERROR(N'Không tìm thấy mã sinh viên.', 16, 1);
			RETURN
		END
	IF EXISTS(SELECT 1 FROM BAITHI WHERE MASV = @MASV)
		BEGIN 
			RAISERROR(N'Sinh viên đã làm bài thi.', 16, 1);
			RETURN
		END
	DELETE FROM SINHVIEN WHERE @MASV = SINHVIEN.MASV
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DSDangKyThi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DSDangKyThi]
@FROMDATE DATETIME,
@TODATE DATETIME
AS
BEGIN
SELECT 
		GVDK.MALOP, 
		TENLOP, 
		GVDK.MAMH, 
		TENMH, 
		GV.TEN, 
		SOCAUTHI, 
		NGAYTHI, 
		GVDK.LAN,
		ISNULL(BT.DATHI, '') AS DATHI,
		(SELECT TENCS FROM COSO) AS GHICHU
	FROM (SELECT MAGV, TRIM(GIAOVIEN.HO) + ' ' + TRIM(GIAOVIEN.TEN) AS TEN FROM GIAOVIEN) AS GV
	INNER JOIN GIAOVIEN_DANGKY AS GVDK ON GVDK.MAGV = GV.MAGV
	INNER JOIN MONHOC ON MONHOC.MAMH = GVDK.MAMH
	INNER JOIN LOP ON LOP.MALOP = GVDK.MALOP
	LEFT JOIN (
		SELECT MAMH, SV.MALOP, LAN, 'X' AS DATHI
		FROM BAITHI 
		INNER JOIN SINHVIEN AS SV ON SV.MASV = BAITHI.MASV
		INNER JOIN LOP ON SV.MALOP = LOP.MALOP
		WHERE NGAYTHI <= GETDATE() 
		GROUP BY SV.MALOP, BAITHI.MAMH, BAITHI.LAN
	) AS BT ON BT.MAMH = GVDK.MAMH AND BT.LAN = GVDK.LAN AND BT.MALOP = GVDK.MALOP
	WHERE NGAYTHI BETWEEN @FROMDATE AND @TODATE
	ORDER BY NGAYTHI ASC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_BODE]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_EXISTED_BODE]
@CAUHOI INT
AS
BEGIN
	IF EXISTS(SELECT 1 FROM BODE WHERE CAUHOI = @CAUHOI)
		BEGIN
			RETURN 1
		END
	ELSE
		BEGIN
			RETURN 0
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_GIAOVIEN]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_EXISTED_GIAOVIEN]
@MAGV CHAR(8)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM GIAOVIEN WHERE MAGV = @MAGV)
		BEGIN
			RETURN 1
		END
	ELSE 
		BEGIN
			RETURN 0
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_KHOA]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_EXISTED_KHOA]
@MAKH CHAR(8)
AS 
BEGIN
	IF EXISTS( SELECT 1 FROM [dbo].[KHOA] AS KH WHERE @MAKH = KH.MAKH)
	BEGIN 
		RETURN 1
	END

	ELSE IF EXISTS(SELECT 1 FROM LINK0.TTN.DBO.KHOA KHOA WHERE KHOA.MAKH = @MAKH)
    BEGIN
            RETURN 1;
    END

	ELSE BEGIN
		RETURN 0
	END 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_LOP]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EXISTED_LOP]
@MALOP CHAR(15)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM LOP WHERE MALOP = @MALOP)
        BEGIN
            RETURN 1;
        END
    ELSE IF EXISTS(SELECT 1 FROM LINK0.TTN.DBO.LOP WHERE MALOP = @MALOP)
        BEGIN
            RETURN 1;
        END
	ELSE
		BEGIN
			RETURN 0;
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_MONHOC]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EXISTED_MONHOC]
@MAMH CHAR(5)
AS
BEGIN
    IF EXISTS( SELECT 1 FROM dbo.MONHOC AS MH WHERE @MAMH=MH.MAMH)
        BEGIN
            RETURN 1;
        END
    ELSE
        BEGIN
            RETURN 0;
        END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_SINHVIEN]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EXISTED_SINHVIEN]
@MASV CHAR(8)
AS
BEGIN
   
    IF EXISTS( SELECT 1 FROM dbo.SINHVIEN AS SV WHERE @MASV = SV.MASV)
        BEGIN
            RETURN 1;
        END
    ELSE IF EXISTS(SELECT 1 FROM LINK0.TTN.DBO.SINHVIEN SINHVIEN WHERE SINHVIEN.MASV = @MASV)
    BEGIN
            RETURN 1;
    END

    ELSE
        BEGIN
            RETURN 0;
        END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_BODE]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_INSERT_BODE]
@MAMH CHAR(5),
@TRINHDO CHAR(1),
@NOIDUNG NVARCHAR(MAX),
@A NVARCHAR(MAX),
@B NVARCHAR(MAX),
@C NVARCHAR(MAX),
@D NVARCHAR(MAX),
@DAP_AN CHAR(1),
@MAGV CHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM MONHOC WHERE MAMH = @MAMH)
		BEGIN
			RAISERROR('Môn học không tồn tại.', 16, 1);
			RETURN 
		END
	IF NOT EXISTS (SELECT 1 FROM GIAOVIEN WHERE MAGV = @MAGV)
		BEGIN
			RAISERROR('Giáo viên không tồn tại.', 16, 1);
			RETURN 
		END
	IF (@A = @B OR @A = @C OR @A = @D OR @B = @C OR @B = @D OR @C = @D)
        BEGIN
            RAISERROR('Các lựa chọn A, B, C, D không được trùng nhau.', 16, 1);
            RETURN
        END
	INSERT INTO BODE(MAMH, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAGV)
	VALUES(@MAMH, @TRINHDO, @NOIDUNG, @A, @B, @C, @D, @DAP_AN, @MAGV)

	SELECT CAUHOI 
    FROM BODE 
    WHERE MAMH = @MAMH 
    AND CAST(NOIDUNG AS NVARCHAR(MAX)) = @NOIDUNG 
    AND CAST(A AS NVARCHAR(MAX)) = @A 
    AND CAST(B AS NVARCHAR(MAX)) = @B 
    AND CAST(C AS NVARCHAR(MAX)) = @C 
    AND CAST(D AS NVARCHAR(MAX)) = @D
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_DANGKYTHI]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_INSERT_DANGKYTHI]
@MAGV CHAR(8),
@MAMH CHAR(5),
@MALOP NCHAR(15),
@TRINHDO CHAR(1),
@NGAYTHI DATETIME,
@SOCAUTHI SMALLINT,
@THOIGIAN SMALLINT
AS
BEGIN
	DECLARE @LAN SMALLINT
	DECLARE @CUR_LAN SMALLINT = -1

	IF NOT EXISTS (SELECT 1 FROM GIAOVIEN WHERE MAGV = @MAGV)
	BEGIN
		RAISERROR('Giáo viên không tồn tại.', 16, 1)
		RETURN
	END
	IF NOT EXISTS (SELECT 1 FROM MONHOC WHERE MAMH = @MAMH)
	BEGIN
		RAISERROR('Môn học không tồn tại.', 16, 1)
		RETURN
	END

	IF EXISTS(SELECT 1 FROM LINK3.[TTN].SYS.TABLES WHERE NAME = 'LOP') 
		AND NOT EXISTS(SELECT 1 FROM LINK3.TTN.DBO.LOP WHERE MALOP = @MALOP)
		BEGIN
			RAISERROR('Lớp không tồn tại.', 16, 1)
			RETURN
		END
	IF NOT EXISTS (SELECT 1 FROM LINK0.TTN.DBO.LOP WHERE MALOP = @MALOP)
	BEGIN
		RAISERROR('Lớp không tồn tại.', 16, 1)
		RETURN
	END

	SELECT @CUR_LAN = LAN
	FROM GIAOVIEN_DANGKY
	WHERE MALOP = @MALOP AND MAMH = @MAMH

	IF @CUR_LAN = -1
		SET @LAN = 1
	ELSE IF @CUR_LAN = 1
		SET @LAN = 2
	ELSE
		RAISERROR('Môn học đã được đăng ký 2 lần cho lớp này.', 16, 1)


	  DECLARE @countQuestionCungTrinhDo int = (
		SELECT COUNT(*)
		FROM BODE
		WHERE MAMH = @MAMH
		AND TRINHDO = @TRINHDO
	);
	DECLARE @countQuestionTrinhDoDuoi int = (
		SELECT COUNT(*)
		FROM BODE
		WHERE MAMH = @MAMH
		AND TRINHDO = CHAR(ASCII(@TRINHDO)+1)
	);

	DECLARE @ErrorMessage NVARCHAR(500)
	IF @countQuestionCungTrinhDo + @countQuestionTrinhDoDuoi < @SOCAUTHI
		BEGIN
			SET @ErrorMessage = N'Không đủ câu hỏi để thi. Thiếu ' + CAST(@SOCAUTHI - (@countQuestionCungTrinhDo + @countQuestionTrinhDoDuoi) AS NVARCHAR(10)) + N' câu.';
			RAISERROR(@ErrorMessage, 16, 1);
			RETURN
		END
	IF @countQuestionCungTrinhDo < CEILING(@SOCAUTHI * 0.7)
		BEGIN
			SET @ErrorMessage = N'Không đủ câu hỏi để thi. Thiếu ' + CAST(CEILING(@SOCAUTHI * 0.7) - @countQuestionCungTrinhDo AS NVARCHAR(10)) + N' câu hỏi cùng trình độ.';
			RAISERROR(@ErrorMessage, 16, 1);
			RETURN
		END

	INSERT INTO GIAOVIEN_DANGKY (MAGV, MAMH, MALOP, TRINHDO, NGAYTHI, LAN, SOCAUTHI, THOIGIAN)
	VALUES (@MAGV, @MAMH, @MALOP, @TRINHDO, @NGAYTHI, @LAN, @SOCAUTHI, @THOIGIAN)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_GIAOVIEN]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_INSERT_GIAOVIEN]
@MAGV CHAR(8),
@HO NVARCHAR(50),
@TEN NVARCHAR(10),
@DIACHI NVARCHAR(50),
@MAKH CHAR(8)
AS
BEGIN
	DECLARE @isExisted int;
	EXEC @isExisted = SP_EXISTED_GIAOVIEN @MAGV
	IF @isExisted = 1
		BEGIN
			RAISERROR('Mã giáo viên đã tồn tại.', 16, 1)
			RETURN
		END
	IF NOT EXISTS(SELECT 1 FROM KHOA WHERE MAKH = @MAKH)
	BEGIN
		RAISERROR('Không tồn tại khoa này.', 16, 1);
		RETURN 
	END
	INSERT INTO GIAOVIEN(MAGV, HO, TEN, DIACHI, MAKH)
	VALUES(@MAGV, @HO, @TEN, @DIACHI, @MAKH)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_KHOA]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERT_KHOA]
@MAKH CHAR(8),
@TENKH NVARCHAR(50),
@MACS CHAR(3)
AS
BEGIN
    DECLARE @isExisted int;
    EXEC @isExisted = [dbo].[SP_EXISTED_KHOA] @MAKH
    IF @isExisted = 1
      BEGIN
        RAISERROR(N'Mã khoa này đã tồn tại.',16,1);
        RETURN
      END
	IF EXISTS (SELECT * FROM LINK0.TTN.DBO.KHOA WHERE TENKH = @TENKH)
	BEGIN
        RAISERROR(N'Tên khoa đã tồn tại.',16,1);
        RETURN
      END
    INSERT INTO KHOA(MAKH, TENKH, MACS)
    VALUES (@MAKH, @TENKH, @MACS)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_LOP]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERT_LOP]
@MALOP CHAR(15),
@TENLOP NVARCHAR(50),
@MAKH CHAR(8)
AS
BEGIN
	DECLARE @isExisted int;
	EXEC @isExisted = [dbo].[SP_EXISTED_LOP] @MALOP
	IF @isExisted = 1
		BEGIN
			RAISERROR('Mã lớp này đã tồn tại', 16, 1);
			RETURN 
		END
	IF EXISTS (SELECT * FROM LINK0.TTN.DBO.LOP WHERE TENLOP = @TENLOP)
	BEGIN
        RAISERROR(N'Tên lớp đã tồn tại.',16,1);
        RETURN
      END
	IF NOT EXISTS(SELECT 1 FROM KHOA WHERE MAKH = @MAKH)
	BEGIN
		RAISERROR('Không tồn tại khoa này.', 16, 1);
		RETURN 
	END
	INSERT INTO LOP(MALOP, TENLOP, MAKH)
	VALUES(@MALOP, @TENLOP, @MAKH)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_MONHOC]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERT_MONHOC]
@MAMH CHAR(5),
@TENMH NVARCHAR(50)
AS
BEGIN
    DECLARE @isExisted int;
    EXEC @isExisted = [dbo].[SP_EXISTED_MONHOC] @MAMH
    IF @isExisted = 1
      BEGIN
        RAISERROR(N'Mã môn học này đã tồn tại.',16,1);
        RETURN
      END
	IF EXISTS (SELECT 1 FROM MONHOC WHERE TENMH = @TENMH)
	BEGIN
        RAISERROR(N'Tên môn học đã tồn tại.',16,1);
        RETURN
      END
    INSERT INTO MONHOC(MAMH, TENMH)
    VALUES(@MAMH, @TENMH)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_SINHVIEN]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_INSERT_SINHVIEN]
@MASV CHAR(8),
@HO NVARCHAR(50),
@TEN NVARCHAR(10),
@NGAYSINH DATE,
@DIACHI NVARCHAR(100),
@MALOP CHAR(15)
AS
BEGIN
	DECLARE @isExisted int;
	EXEC @isExisted = [dbo].[SP_EXISTED_SINHVIEN] @MASV 
	IF @isExisted = 1 
		BEGIN
			RAISERROR(N'Mã sinh viên này đã tồn tại.', 16, 1);
			RETURN
		END
	IF NOT EXISTS (SELECT 1 FROM LOP WHERE MALOP = @MALOP) 
		BEGIN
			RAISERROR(N'Lớp không tồn tại.', 16, 1);
			RETURN
		END
	INSERT INTO SINHVIEN(MASV, HO, TEN, NGAYSINH, DIACHI, MALOP)
	VALUES (@MASV, @HO, @TEN, @NGAYSINH, @DIACHI, @MALOP)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayBaiThiDaDangKyTheoMaLop]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LayBaiThiDaDangKyTheoMaLop]
    @malop NCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @current_time DATETIME;
    SET @current_time = GETDATE();

    SELECT MAGV, MAMH, MALOP, TRINHDO, NGAYTHI, LAN, SOCAUTHI, THOIGIAN
    FROM GIAOVIEN_DANGKY
    WHERE MALOP = @malop
    AND NGAYTHI >= @current_time;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_LayCauHoi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_LayCauHoi]
@MABT INT
AS
BEGIN
	SELECT 
		CT_BAITHI.STT_DETHI,
		NOIDUNG,
		A, B, C, D,
		TRALOI,
		CT_BAITHI.CAUHOI AS ID
	FROM CT_BAITHI 
	INNER JOIN BODE ON CT_BAITHI.CAUHOI = BODE.CAUHOI
	WHERE MABT = @MABT
	ORDER BY STT_DETHI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayCauHoiTheoMAGV]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LayCauHoiTheoMAGV]
    @MAGV CHAR(8)
AS
BEGIN
    SELECT *
    FROM BODE
    WHERE MAGV = @MAGV;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_LayChiTietBaiThi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayChiTietBaiThi]
@MABT INT
AS
BEGIN
	SELECT CT.STT_DETHI AS STT, BD.CAUHOI, NOIDUNG, A, B, C, D, DAP_AN, ISNULL(CT.TRALOI, '') AS DACHON
	FROM CT_BAITHI CT
	INNER JOIN BODE BD ON BD.CAUHOI = CT.CAUHOI
	WHERE CT.MABT = @MABT
	ORDER BY CT.STT_DETHI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayDangKyChuaHoanTatTheoMaSV]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayDangKyChuaHoanTatTheoMaSV]
@MASV NCHAR(8)
AS
BEGIN
    SELECT 
		GVDK.MAGV,
        GVDK.MAMH,
		GVDK.MALOP,
        GVDK.TRINHDO, 
        GVDK.NGAYTHI, 
        GVDK.LAN,
        GVDK.SOCAUTHI, 
        GVDK.THOIGIAN
    FROM GIAOVIEN_DANGKY GVDK
    INNER JOIN SINHVIEN SV ON SV.MALOP = GVDK.MALOP
    LEFT JOIN BAITHI BT ON SV.MASV = BT.MASV 
                AND GVDK.MAMH = BT.MAMH 
                AND GVDK.LAN = BT.LAN
    WHERE 
        SV.MASV = @MASV 
        AND (BT.MASV IS NULL OR BT.TGCL <> 0)
		AND GVDK.NGAYTHI <= GETDATE()
    ORDER BY 
        GVDK.NGAYTHI ASC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayDangKyDaThiTheoMaSV]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayDangKyDaThiTheoMaSV]
@MASV NCHAR(8)
AS
BEGIN
	SELECT BT.MAMH, GVDK.TRINHDO, BT.LAN, BT.NGAYTHI, BT.DIEM, BT.MABT
	FROM BAITHI BT
	INNER JOIN SINHVIEN SV ON BT.MASV = SV.MASV
	INNER JOIN LOP L ON SV.MALOP = L.MALOP
	INNER JOIN GIAOVIEN_DANGKY GVDK ON GVDK.MALOP = SV.MALOP
			AND GVDK.MAMH = BT.MAMH 
			AND GVDK.LAN = BT.LAN
	WHERE BT.MASV = @MASV AND BT.TGCL = 0
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayDangKyTheoMAGV]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LayDangKyTheoMAGV]
    @MAGV CHAR(8)
AS
BEGIN
    SELECT *
    FROM GIAOVIEN_DANGKY
    WHERE MAGV = @MAGV;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_LayDangKyTheoMaSV]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayDangKyTheoMaSV]
@MASV NCHAR(8)
AS
BEGIN
    SELECT 
		GVDK.MAGV,
        GVDK.MAMH,
		GVDK.MALOP,
        GVDK.TRINHDO, 
        GVDK.NGAYTHI, 
        GVDK.LAN,
        GVDK.SOCAUTHI, 
        GVDK.THOIGIAN,
		BT.MABT
    FROM GIAOVIEN_DANGKY GVDK
    INNER JOIN SINHVIEN SV ON SV.MALOP = GVDK.MALOP
    LEFT JOIN BAITHI BT ON SV.MASV = BT.MASV 
                AND GVDK.MAMH = BT.MAMH 
                AND GVDK.LAN = BT.LAN
    WHERE 
        SV.MASV = @MASV 
        AND (BT.MASV IS NULL OR BT.TGCL <> 0)
		AND GVDK.NGAYTHI <= GETDATE()
    ORDER BY 
        GVDK.NGAYTHI ASC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayThongTinBaiThiTheoMaBT]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayThongTinBaiThiTheoMaBT]
@MABT INT
AS
BEGIN
	SELECT L.TENLOP, SV.HO + ' ' + SV.TEN AS HoTen, MH.TENMH, BT.NGAYTHI, BT.LAN, BT.DIEM
	FROM BAITHI BT
	INNER JOIN SINHVIEN SV ON SV.MASV = BT.MASV
	INNER JOIN LOP L ON SV.MALOP = L.MALOP
	INNER JOIN MONHOC MH ON MH.MAMH = BT.MAMH
	WHERE MABT = @MABT
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayThongTinGiangVien]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayThongTinGiangVien]
@TENLOGIN NVARCHAR (50)
AS
DECLARE @TENUSER NVARCHAR (50), @UID SMALLINT

SELECT @UID = UID, @TENUSER = NAME
FROM SYS.sysusers
WHERE SID = (SELECT sid
			FROM sys.server_principals
			WHERE name = @TENLOGIN)

SELECT MAGV = @TENUSER,
		HOTEN = (SELECT HO + ' ' + TEN FROM GIAOVIEN WHERE MAGV = @TENUSER),
		TENNHOM = NAME
		FROM SYS.sysusers
		WHERE UID = (SELECT GROUPUID
					FROM SYS.sysmembers
					WHERE MEMBERUID = @UID)
GO
/****** Object:  StoredProcedure [dbo].[SP_LayThongTinSinhVien]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayThongTinSinhVien]
    @username NVARCHAR(50),
    @password NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM SINHVIEN WHERE MASV = @username AND PASSWORD = @password)
    BEGIN
        SELECT MASV, HO + ' ' + TEN AS [HO TEN], MALOP
        FROM Sinhvien
        WHERE MASV = @username;
    END
	ELSE
    BEGIN
        SELECT -1 AS LoginStatus;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_DSDangKyThi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REPORT_DSDangKyThi]
    @FROMDATE DATETIME,
    @TODATE DATETIME
AS
BEGIN
	SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FROMDATE_STR NVARCHAR(20)
    DECLARE @TODATE_STR NVARCHAR(20)
    
    SET @FROMDATE_STR = CONVERT(NVARCHAR(20), @FROMDATE, 120)
    SET @TODATE_STR = CONVERT(NVARCHAR(20), @TODATE, 120)
    
    CREATE TABLE #DangKyThiReport (
        MaLop NVARCHAR(50),
        TenLop NVARCHAR(100),
        MaMH NVARCHAR(50),
        TenMH NVARCHAR(100),
        GiangVien NVARCHAR(100),
        SoCauThi INT,
        NgayThi DATE,
        Lan INT,
        DaThi NVARCHAR(1),
        GhiChu NVARCHAR(MAX)
    );

    INSERT INTO #DangKyThiReport (MaLop, TenLop, MaMH, TenMH, GiangVien, SoCauThi, NgayThi, Lan, DaThi, GhiChu)
    EXEC [dbo].[SP_DSDangKyThi] @FROMDATE, @TODATE;

	INSERT INTO #DangKyThiReport (MaLop, TenLop, MaMH, TenMH, GiangVien, SoCauThi, NgayThi, Lan, DaThi, GhiChu)
    EXEC LINK1.TTN.[dbo].[SP_DSDangKyThi] @FROMDATE, @TODATE;

    IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'Job_1')
    BEGIN
        EXEC msdb.dbo.sp_delete_job @job_name = N'Job_1'
    END

    EXEC msdb.dbo.sp_add_job @job_name = N'Job_1', @enabled = 1, @start_step_id = 1, @notify_level_eventlog = 2, @delete_level = 0
    EXEC msdb.dbo.sp_add_jobserver @job_name = N'Job_1', @server_name = @@SERVERNAME
    
    EXEC msdb.dbo.sp_add_jobstep 
        @job_name = N'Job_1', 
        @step_id = 1, 
        @step_name = N'Generate Report', 
        @subsystem = N'TSQL', 
        @command = 'SELECT * FROM #DangKyThiReport', 
        @database_name = N'TTN', 
        @on_success_action = 1, 
        @on_fail_action = 2

    EXEC msdb.dbo.sp_start_job @job_name = N'Job_1'
    
    SELECT * FROM #DangKyThiReport;
    
    DROP TABLE #DangKyThiReport;
	SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_InBangDiemMonHoc]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_InBangDiemMonHoc]
@MALOP NCHAR(15), 
@MAMH CHAR(5),
@LAN SMALLINT

AS
BEGIN

    IF EXISTS (SELECT 1 FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND MALOP = @MALOP AND LAN = @LAN)
    BEGIN

        SELECT 
            SV.MASV, 
            SV.HO + ' ' + SV.TEN AS HOTEN, 
            ISNULL(BD.DIEM, 0) AS DIEM, 
            dbo.FN_READ_POINT(ISNULL(BD.DIEM, 0)) AS DIEMCHU
        FROM 
			(SELECT MASV, HO, TEN, MALOP FROM SINHVIEN WHERE MALOP=@MALOP) SV
        LEFT JOIN (
			SELECT MASV, DIEM
			FROM BAITHI
			WHERE MAMH = @MAMH AND LAN = @LAN
		) BD ON SV.MASV = BD.MASV
        
    END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SinhVienDangKy]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SinhVienDangKy]
    @masv NVARCHAR(50),
    @Password NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM SINHVIEN WHERE MASV = @masv AND PASSWORD IS NOT NULL)
    BEGIN
        SELECT -1 AS Result, N'Tài khoản đã tồn tại.' AS Message;
        RETURN;
    END

    UPDATE SINHVIEN
	SET PASSWORD = @Password
    WHERE MASV = @masv

    SELECT 0 AS Result, N'Đăng ký thành công.' AS Message;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TaoBaiThi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TaoBaiThi] @MASV CHAR(8),
@MAMH CHAR(5),
@LAN SMALLINT,
@NGAYTHI DATETIME,
@TRINHDO NCHAR(1),
@SOCAU SMALLINT,
@TGCL INT
AS
BEGIN
	BEGIN TRAN
	SET NOCOUNT ON
	INSERT INTO BAITHI(MASV, MAMH, LAN, NGAYTHI, DIEM, TGCL) VALUES(@MASV, @MAMH, @LAN, @NGAYTHI, 0, @TGCL*60)
	SET NOCOUNT OFF
	DECLARE @MABT INT
	SELECT @MABT = MABT FROM BAITHI WHERE MAMH = @MAMH AND MASV = @MASV AND LAN = @LAN

	CREATE TABLE #CAUHOITHI (
		CAUHOI int primary key,
		NOIDUNG ntext,
		A ntext,
		B ntext,
		C ntext,
		D ntext,
		DAP_AN nchar(1),
		STT_DETHI SMALLINT IDENTITY(1,1)
	  );
	  
	SET NOCOUNT ON
	INSERT INTO #CAUHOITHI
	EXEC [dbo].[SP_TaoCauHoi] @MAMH, @TRINHDO, @SOCAU
	SET NOCOUNT OFF

	SET NOCOUNT ON
	INSERT INTO CT_BAITHI(MABT, CAUHOI, STT_DETHI)
	SELECT @MABT, CAUHOI, STT_DETHI
	FROM #CAUHOITHI
	DROP TABLE #CAUHOITHI
	COMMIT TRAN
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TaoCauHoi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TaoCauHoi] @MAMONHOC  CHAR(5),
@TRINHDO  NCHAR(1),
@SOCAU INT
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRANSACTION	
	CREATE TABLE #CAUHOITHI (
		CAUHOI int primary key,
		TRINHDO Nchar(1),
		NOIDUNG ntext,
		A ntext,
		B ntext,
		C ntext,
		D ntext,
		DAP_AN nchar(1),
		MAMH CHAR(5),
		MAGV CHAR(8)
	);
  
  -- Lấy thông tin câu hỏi tại mỗi site --
  select CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV 
  into #CungTrinhDoAtSiteTable from BODE  
  where MAMH = @MAMONHOC and TRINHDO = @TRINHDO and MAGV in 
  (Select MAGV from GIAOVIEN where MAKH in (select MAKH from KHOA)) 
  ORDER BY NEWID();
  
  select CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV 
  into #TrinhDoDuoiAtSiteTable from BODE  
  where MAMH = @MAMONHOC and TRINHDO = CHAR(ASCII(@TRINHDO)+1) and MAGV in 
  (Select MAGV from GIAOVIEN where MAKH in (select MAKH from KHOA)) 
  ORDER BY NEWID();
  
  DECLARE @countQuestionCungTrinhDoAtSite int = (select count(*) from #CungTrinhDoAtSiteTable);
  DECLARE @countQuestionTrinhDoDuoiAtSite int = (select count(*) from #TrinhDoDuoiAtSiteTable);
  
  -- INSERT CUNG TRINH DO TAI SITE HIEN TAI --
  INSERT INTO #CAUHOITHI(CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV)
  SELECT CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
  FROM #CungTrinhDoAtSiteTable

  -- NEU SO LUONG CAU HOI CUNG TRINH DO KHONG DU TOI THIEU 70% THI QUA SITE KHAC LAY THEM --
  IF @countQuestionCungTrinhDoAtSite < (@SOCAU * 70 / 100)
  BEGIN
    SELECT CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
    INTO #CungTrinhDoOtherSite
    FROM BODE
    WHERE MAMH = @MAMONHOC
    AND TRINHDO = @TRINHDO
    AND MAGV IN (
      SELECT MAGV
      FROM GIAOVIEN
      WHERE MAKH NOT IN (
        SELECT MAKH
        FROM KHOA
      )
    )

    INSERT INTO #CAUHOITHI(CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV)
    SELECT TOP (CEILING((@SOCAU * 70 / 100) - @countQuestionCungTrinhDoAtSite)) 
    CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
    FROM #CungTrinhDoOtherSite
    ORDER BY NEWID()
  END

  SET @countQuestionCungTrinhDoAtSite = (SELECT COUNT(*) FROM #CAUHOITHI);

  IF ((@SOCAU - @countQuestionCungTrinhDoAtSite) > 0) AND (@countQuestionTrinhDoDuoiAtSite > (@SOCAU - @countQuestionCungTrinhDoAtSite))
  BEGIN 
    INSERT INTO #CAUHOITHI(CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV)
    SELECT TOP (@SOCAU - @countQuestionCungTrinhDoAtSite) 
    CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
    FROM #TrinhDoDuoiAtSiteTable
	ORDER BY NEWID()
  END
  ELSE IF ((@SOCAU - @countQuestionCungTrinhDoAtSite) > 0) AND (@countQuestionTrinhDoDuoiAtSite < (@SOCAU - @countQuestionCungTrinhDoAtSite))
  BEGIN
    INSERT INTO #CAUHOITHI(CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV)
    SELECT CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
    FROM #TrinhDoDuoiAtSiteTable

    SELECT CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
    INTO #DuoiTrinhDoOtherSite
    FROM BODE
    WHERE MAMH = @MAMONHOC
    AND TRINHDO = CHAR(ASCII(@TRINHDO)+1)
    AND MAGV IN (
      SELECT MAGV
      FROM GIAOVIEN
      WHERE MAKH NOT IN (
        SELECT MAKH
        FROM KHOA
      )
    )
	ORDER BY NEWID()
    INSERT INTO #CAUHOITHI(CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV)
    SELECT TOP (@SOCAU - @countQuestionCungTrinhDoAtSite - @countQuestionTrinhDoDuoiAtSite) 
    CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
    FROM #DuoiTrinhDoOtherSite
  END

  COMMIT

  SELECT TOP (@SOCAU)
    CAUHOI,
    NOIDUNG as [NOIDUNG],
    A as [A],
    B as [B],
    C as [C],
    D as [D],
    DAP_AN
  FROM #CAUHOITHI 
  ORDER BY NEWID()

  DROP TABLE #CAUHOITHI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TaoMaCauHoi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_TaoMaCauHoi]
AS
BEGIN
    DECLARE @CAUHOI INT

    SET @CAUHOI = ISNULL((SELECT TOP 1 CAUHOI FROM BODE ORDER BY CAUHOI DESC), 0) + 1

    SELECT @CAUHOI AS NEWCAUHOI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TaoTaiKhoan]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_TaoTaiKhoan]
    @LGNAME VARCHAR(50),
    @PASS NVARCHAR(50),
    @USERNAME VARCHAR(50),
    @ROLE VARCHAR(50)
AS
BEGIN
    -- Begin transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- ALTER the login
        DECLARE @SQL NVARCHAR(MAX)
        SET @SQL = N'CREATE LOGIN [' + @LGNAME + '] WITH PASSWORD = N''' + @PASS + ''''
        EXEC sp_executesql @SQL

        -- ALTER the user and map to the login
        SET @SQL = N'CREATE USER [' + @USERNAME + '] FOR LOGIN [' + @LGNAME + ']'
        EXEC sp_executesql @SQL

        -- Add the user to the database role
        SET @SQL = N'ALTER ROLE [' + @ROLE + '] ADD MEMBER [' + @USERNAME + ']'
        EXEC sp_executesql @SQL

        -- Add the login to server roles based on the provided role
        IF @ROLE = 'Truong'
        BEGIN
            SET @SQL = N'ALTER SERVER ROLE [securityadmin] ADD MEMBER [' + @LGNAME + ']'
            EXEC sp_executesql @SQL

            SET @SQL = N'ALTER SERVER ROLE [processadmin] ADD MEMBER [' + @LGNAME + ']'
            EXEC sp_executesql @SQL

			SET @SQL = N'ALTER SERVER ROLE [sysadmin] ADD MEMBER [' + @LGNAME + ']'
            EXEC sp_executesql @SQL

			EXEC [dbo].[SP_CapQuyenJob] @LGNAME, @USERNAME
        END
		ELSE IF @ROLE = 'Coso'
		BEGIN
			SET @SQL = N'ALTER SERVER ROLE [securityadmin] ADD MEMBER [' + @LGNAME + ']'
            EXEC sp_executesql @SQL

            SET @SQL = N'ALTER SERVER ROLE [processadmin] ADD MEMBER [' + @LGNAME + ']'
            EXEC sp_executesql @SQL
		END
        ELSE IF @ROLE = 'Giangvien'
        BEGIN
            SET @SQL = N'ALTER SERVER ROLE [processadmin] ADD MEMBER [' + @LGNAME + ']'
            EXEC sp_executesql @SQL
        END

        -- Commit transaction if everything succeeds
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback transaction if any error occurs
        ROLLBACK TRANSACTION;

        -- Raise an error with details
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ThongTinBaiThi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ThongTinBaiThi] @MASV CHAR(8),
@MAMH CHAR(5),
@LAN SMALLINT,
@TRINHDO CHAR(1),
@SOCAU SMALLINT
AS
BEGIN
	DECLARE @TGCL INT
	DECLARE @STR NCHAR(255)
	IF NOT EXISTS(SELECT 1 FROM BAITHI WHERE MASV = @MASV AND MAMH = @MAMH AND LAN = @LAN)
	BEGIN
		DECLARE @NGAYTHI DATETIME = GETDATE()
		DECLARE @MALOP NCHAR(15)
		SELECT @MALOP = MALOP FROM SINHVIEN WHERE MASV = @MASV
		SELECT @TGCL = CAST(THOIGIAN AS int) FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND LAN = @LAN AND MALOP = @MALOP

		IF @TGCL IS NULL
		BEGIN
			RAISERROR(N'Không tìm thấy đăng ký hợp lệ', 16, 1)
			RETURN
		END
		
		EXEC [dbo].[SP_TaoBaiThi] @MASV, @MAMH, @LAN, @NGAYTHI, @TRINHDO, @SOCAU, @TGCL

	END

	SELECT 
		SV.MALOP AS N'MÃ LỚP',
		TENLOP AS N'LỚP',
		TEN AS N'HỌ TÊN',
		TENMH AS N'TÊN MÔN',
		NGAYTHI AS N'NGÀY THI',
		LAN	AS N'LẦN',
		TGCL AS N'THỜI GIAN CÒN LẠI',
		MABT AS N'Mã bài thi'
	FROM (
		SELECT * FROM BAITHI WHERE MASV = @MASV AND MAMH = @MAMH AND LAN = @LAN
	) AS BAITHI
	INNER JOIN (
		SELECT MASV, HO + TEN AS TEN, MALOP FROM SINHVIEN WHERE MASV = @MASV
	) AS SV ON BAITHI.MASV = SV.MASV
	INNER JOIN (
		SELECT MAMH, TENMH FROM MONHOC WHERE MAMH = @MAMH
	) AS MONHOC ON MONHOC.MAMH = BAITHI.MAMH
	INNER JOIN LOP AS LOP ON LOP.MALOP = SV.MALOP
	WHERE NGAYTHI <= GETDATE()

END
GO
/****** Object:  StoredProcedure [dbo].[SP_TinhDiem]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TinhDiem]
@MABT INT,
@SOCAU INT
AS
BEGIN
		DECLARE @SOCAUDUNG FLOAT
		DECLARE @DIEM FLOAT
		SELECT @SOCAUDUNG = ROUND(CAST(COUNT(*) AS float), 1)
		FROM CT_BAITHI
		INNER JOIN BODE ON BODE.CAUHOI = CT_BAITHI.CAUHOI
		WHERE MABT = @MABT AND CAST(TRALOI AS char(1)) = BODE.DAP_AN
		
		SET @DIEM = ROUND(10 * (@SOCAUDUNG/@SOCAU), 2)
		UPDATE BAITHI
		SET DIEM = @DIEM, TGCL = 0
		WHERE MABT = @MABT
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TraLoiCauHoi]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TraLoiCauHoi]
@MABT INT,
@CAUHOI INT,
@TRALOI NCHAR(1)
AS
BEGIN
		UPDATE CT_BAITHI
		SET TRALOI = @TRALOI
		WHERE MABT = @MABT AND CAUHOI = @CAUHOI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_BODE]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UPDATE_BODE]
@CAUHOI INT,
@TRINHDO CHAR(1),
@NOIDUNG NTEXT,
@A NTEXT,
@B NTEXT,
@C NTEXT,
@D NTEXT,
@DAP_AN CHAR(1)
AS
BEGIN
	DECLARE @isExisted int;
	EXEC @isExisted = [dbo].[SP_EXISTED_BODE] @CAUHOI
	IF @isExisted = 0
		BEGIN
			RAISERROR('Câu hỏi không tồn tại', 16, 1);
			RETURN 
		END
	UPDATE BODE
	SET TRINHDO=@TRINHDO, NOIDUNG=@NOIDUNG, A=@A, B=@B, C=@C, D=@D, DAP_AN=@DAP_AN
	WHERE CAUHOI = @CAUHOI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_GIAOVIEN]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UPDATE_GIAOVIEN]
@MAGV CHAR(8),
@HO NVARCHAR(50),
@TEN NVARCHAR(10),
@DIACHI NVARCHAR(50)
AS
BEGIN
	DECLARE @isExisted int;
	EXEC @isExisted = SP_EXISTED_GIAOVIEN @MAGV
	IF @isExisted = 0
		BEGIN
			RAISERROR('Không tìm thấy mã giáo viên.', 16, 1)
			RETURN
		END
	UPDATE GIAOVIEN
	SET HO = @HO, TEN = @TEN, DIACHI = @DIACHI
	WHERE MAGV = @MAGV
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_KHOA]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UPDATE_KHOA]
@MAKH CHAR(8),
@TENKH NVARCHAR(50)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM KHOA WHERE MAKH = @MAKH)
		BEGIN
			RAISERROR(N'Mã khoa này không tồn tại ở cơ sở này.', 16, 1);
			RETURN
		END
	IF EXISTS (SELECT * FROM LINK0.TTN.DBO.KHOA WHERE TENKH = @TENKH)
		BEGIN
			RAISERROR(N'Tên khoa đã tồn tại.',16,1);
			RETURN
		END
	UPDATE KHOA
	SET TENKH = @TENKH
	WHERE MAKH = @MAKH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_LOP]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UPDATE_LOP]
@MALOP CHAR(15),
@TENLOP NVARCHAR(50)
AS
BEGIN
	DECLARE @CurrentTENLOP NVARCHAR(50)

    SELECT @CurrentTENLOP = TENLOP
    FROM LOP
    WHERE MALOP = @MALOP

    IF @TENLOP != @CurrentTENLOP
    BEGIN
        IF EXISTS (SELECT * FROM LINK0.TTN.DBO.LOP WHERE TENLOP = @TENLOP)
        BEGIN
            RAISERROR(N'Tên lớp đã tồn tại.', 16, 1);
            RETURN;
        END
    END

	IF NOT EXISTS(SELECT 1 FROM LOP WHERE MALOP = @MALOP)
	BEGIN
		RAISERROR('Mã lớp không tồn tại ở cơ sở này', 16, 1);
		RETURN 
	END

	UPDATE LOP 
	SET TENLOP = @TENLOP
	WHERE MALOP = @MALOP
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_MONHOC]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UPDATE_MONHOC]
@MAMH CHAR(5),
@TENMH NVARCHAR(50)
AS
BEGIN
	DECLARE @isExisted int;
	DECLARE @CurrentTenMH NVARCHAR(50)

	EXEC @isExisted = [dbo].[SP_EXISTED_MONHOC] @MAMH
	IF @isExisted = 0
	  BEGIN
		  RAISERROR(N'Không tìm thấy môn học.',16,1);
		  RETURN
	  END

    SELECT @CurrentTenMH = TENMH
    FROM MONHOC
    WHERE MAMH = @MAMH

    IF @TENMH != @CurrentTenMH AND EXISTS (SELECT * FROM MONHOC WHERE TENMH = @TENMH)
        BEGIN
            RAISERROR(N'Tên môn học đã tồn tại.', 16, 1);
            RETURN;
        END
	
	UPDATE MONHOC
	SET TENMH=@TENMH WHERE MAMH=@MAMH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_SINHVIEN]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UPDATE_SINHVIEN]
@MASV CHAR(8),
@HO NVARCHAR(50),
@TEN NVARCHAR(10),
@NGAYSINH DATE,
@DIACHI NVARCHAR(100)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM SINHVIEN WHERE MASV = @MASV)
		BEGIN
			RAISERROR(N'Mã sinh viên này không tồn tại ở cơ sở này', 16, 1);
			RETURN
		END
	UPDATE SINHVIEN
	SET HO = @HO, TEN = @TEN, NGAYSINH = @NGAYSINH, DIACHI = @DIACHI
	WHERE MASV = @MASV
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateTime]    Script Date: 15/07/2024 7:23:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UpdateTime]
@MABT INT,
@TGCL INT
AS
BEGIN
		UPDATE BAITHI
		SET TGCL = @TGCL
		WHERE MABT = @MABT
END
GO
