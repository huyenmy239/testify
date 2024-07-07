USE [master]
GO
/****** Object:  Database [TTN]    Script Date: 05/07/2024 4:41:17 pm ******/
CREATE DATABASE [TTN]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TTN', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TTN.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TTN_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TTN_log.ldf' , SIZE = 335872KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [TTN] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TTN].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TTN] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TTN] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TTN] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TTN] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TTN] SET ARITHABORT OFF 
GO
ALTER DATABASE [TTN] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TTN] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TTN] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TTN] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TTN] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TTN] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TTN] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TTN] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TTN] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TTN] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TTN] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TTN] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TTN] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TTN] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TTN] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TTN] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TTN] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TTN] SET RECOVERY FULL 
GO
ALTER DATABASE [TTN] SET  MULTI_USER 
GO
ALTER DATABASE [TTN] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TTN] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TTN] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TTN] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TTN] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TTN] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'TTN', N'ON'
GO
ALTER DATABASE [TTN] SET QUERY_STORE = ON
GO
ALTER DATABASE [TTN] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [TTN]
GO
/****** Object:  User [HTKN]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE USER [HTKN] FOR LOGIN [HTKN] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [HTKN]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_READ_POINT]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  Table [dbo].[LOP]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOP](
	[MALOP] [nchar](15) NOT NULL,
	[TENLOP] [nvarchar](50) NOT NULL,
	[MAKH] [nchar](8) NOT NULL,
 CONSTRAINT [PK_LOP] PRIMARY KEY CLUSTERED 
(
	[MALOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SINHVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SINHVIEN](
	[MASV] [char](8) NOT NULL,
	[HO] [nvarchar](50) NOT NULL,
	[TEN] [nvarchar](10) NOT NULL,
	[NGAYSINH] [date] NOT NULL,
	[DIACHI] [nvarchar](100) NULL,
	[MALOP] [nchar](15) NOT NULL,
	[PASSWORD] [varchar](30) NULL,
 CONSTRAINT [PK_SINHVIEN] PRIMARY KEY CLUSTERED 
(
	[MASV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COSO]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COSO](
	[MACS] [nchar](3) NOT NULL,
	[TENCS] [nvarchar](50) NOT NULL,
	[DIACHI] [nvarchar](100) NULL,
 CONSTRAINT [PK_COSO] PRIMARY KEY CLUSTERED 
(
	[MACS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHOA]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHOA](
	[MAKH] [nchar](8) NOT NULL,
	[TENKH] [nvarchar](50) NOT NULL,
	[MACS] [nchar](3) NOT NULL,
 CONSTRAINT [PK_KHOA] PRIMARY KEY CLUSTERED 
(
	[MAKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_DSSINHVIENDANGKY]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  View [dbo].[V_DS_COSO]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_DS_COSO] AS

SELECT * FROM COSO
GO
/****** Object:  Table [dbo].[GIAOVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAOVIEN](
	[MAGV] [char](8) NOT NULL,
	[HO] [nvarchar](50) NOT NULL,
	[TEN] [nvarchar](10) NOT NULL,
	[DIACHI] [nvarchar](50) NULL,
	[MAKH] [nchar](8) NOT NULL,
 CONSTRAINT [PK_GIAOVIEN] PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_DanhSachGVChuaCoUsername]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  View [dbo].[V_DSPHANMANH]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  Table [dbo].[auth_group]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_group_permissions]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group_permissions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[group_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_permission]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[content_type_id] [int] NOT NULL,
	[codename] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[last_login] [datetimeoffset](7) NULL,
	[is_superuser] [bit] NOT NULL,
	[username] [nvarchar](150) NOT NULL,
	[first_name] [nvarchar](150) NOT NULL,
	[last_name] [nvarchar](150) NOT NULL,
	[email] [nvarchar](254) NOT NULL,
	[is_staff] [bit] NOT NULL,
	[is_active] [bit] NOT NULL,
	[date_joined] [datetimeoffset](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user_groups]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user_groups](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[group_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user_user_permissions]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user_user_permissions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BAITHI]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BAITHI](
	[MABT] [int] IDENTITY(1,1) NOT NULL,
	[MASV] [char](8) NOT NULL,
	[MAMH] [char](5) NOT NULL,
	[LAN] [smallint] NOT NULL,
	[NGAYTHI] [date] NOT NULL,
	[DIEM] [float] NOT NULL,
	[TGCL] [int] NOT NULL,
 CONSTRAINT [PK_BAITHI] PRIMARY KEY CLUSTERED 
(
	[MABT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BODE]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BODE](
	[CAUHOI] [int] IDENTITY(1,1) NOT NULL,
	[MAMH] [char](5) NOT NULL,
	[TRINHDO] [char](1) NOT NULL,
	[NOIDUNG] [ntext] NOT NULL,
	[A] [ntext] NOT NULL,
	[B] [ntext] NOT NULL,
	[C] [ntext] NOT NULL,
	[D] [ntext] NOT NULL,
	[DAP_AN] [char](1) NOT NULL,
	[MAGV] [char](8) NOT NULL,
 CONSTRAINT [PK_BODE] PRIMARY KEY CLUSTERED 
(
	[CAUHOI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_BAITHI]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_BAITHI](
	[MABT] [int] NOT NULL,
	[CAUHOI] [int] NOT NULL,
	[TRALOI] [char](1) NULL,
	[STT_DETHI] [smallint] NOT NULL,
 CONSTRAINT [PK_CT_BAITHI] PRIMARY KEY CLUSTERED 
(
	[MABT] ASC,
	[CAUHOI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_admin_log]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_admin_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[action_time] [datetimeoffset](7) NOT NULL,
	[object_id] [nvarchar](max) NULL,
	[object_repr] [nvarchar](200) NOT NULL,
	[action_flag] [smallint] NOT NULL,
	[change_message] [nvarchar](max) NOT NULL,
	[content_type_id] [int] NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_content_type]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_content_type](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[app_label] [nvarchar](100) NOT NULL,
	[model] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_migrations]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_migrations](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[app] [nvarchar](255) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[applied] [datetimeoffset](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_session]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_session](
	[session_key] [nvarchar](40) NOT NULL,
	[session_data] [nvarchar](max) NOT NULL,
	[expire_date] [datetimeoffset](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[session_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GIAOVIEN_DANGKY]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAOVIEN_DANGKY](
	[MAGV] [char](8) NOT NULL,
	[MAMH] [char](5) NOT NULL,
	[MALOP] [nchar](15) NOT NULL,
	[TRINHDO] [char](1) NOT NULL,
	[NGAYTHI] [datetime] NOT NULL,
	[LAN] [smallint] NOT NULL,
	[SOCAUTHI] [smallint] NOT NULL,
	[THOIGIAN] [smallint] NOT NULL,
 CONSTRAINT [PK_GIAOVIEN_DANGKY] PRIMARY KEY CLUSTERED 
(
	[MAMH] ASC,
	[MALOP] ASC,
	[LAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MONHOC]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MONHOC](
	[MAMH] [char](5) NOT NULL,
	[TENMH] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MONHOC] PRIMARY KEY CLUSTERED 
(
	[MAMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[auth_permission] ON 

INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (1, N'Can add log entry', 1, N'add_logentry')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (2, N'Can change log entry', 1, N'change_logentry')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (3, N'Can delete log entry', 1, N'delete_logentry')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (4, N'Can view log entry', 1, N'view_logentry')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (5, N'Can add permission', 2, N'add_permission')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (6, N'Can change permission', 2, N'change_permission')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (7, N'Can delete permission', 2, N'delete_permission')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (8, N'Can view permission', 2, N'view_permission')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (9, N'Can add group', 3, N'add_group')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (10, N'Can change group', 3, N'change_group')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (11, N'Can delete group', 3, N'delete_group')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (12, N'Can view group', 3, N'view_group')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (13, N'Can add user', 4, N'add_user')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (14, N'Can change user', 4, N'change_user')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (15, N'Can delete user', 4, N'delete_user')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (16, N'Can view user', 4, N'view_user')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (17, N'Can add content type', 5, N'add_contenttype')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (18, N'Can change content type', 5, N'change_contenttype')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (19, N'Can delete content type', 5, N'delete_contenttype')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (20, N'Can view content type', 5, N'view_contenttype')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (21, N'Can add session', 6, N'add_session')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (22, N'Can change session', 6, N'change_session')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (23, N'Can delete session', 6, N'delete_session')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (24, N'Can view session', 6, N'view_session')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (25, N'Can add baithi', 7, N'add_baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (26, N'Can change baithi', 7, N'change_baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (27, N'Can delete baithi', 7, N'delete_baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (28, N'Can view baithi', 7, N'view_baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (29, N'Can add bode', 8, N'add_bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (30, N'Can change bode', 8, N'change_bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (31, N'Can delete bode', 8, N'delete_bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (32, N'Can view bode', 8, N'view_bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (33, N'Can add coso', 9, N'add_coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (34, N'Can change coso', 9, N'change_coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (35, N'Can delete coso', 9, N'delete_coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (36, N'Can view coso', 9, N'view_coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (37, N'Can add giaovien', 10, N'add_giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (38, N'Can change giaovien', 10, N'change_giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (39, N'Can delete giaovien', 10, N'delete_giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (40, N'Can view giaovien', 10, N'view_giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (41, N'Can add monhoc', 11, N'add_monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (42, N'Can change monhoc', 11, N'change_monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (43, N'Can delete monhoc', 11, N'delete_monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (44, N'Can view monhoc', 11, N'view_monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (45, N'Can add khoa', 12, N'add_khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (46, N'Can change khoa', 12, N'change_khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (47, N'Can delete khoa', 12, N'delete_khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (48, N'Can view khoa', 12, N'view_khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (49, N'Can add lop', 13, N'add_lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (50, N'Can change lop', 13, N'change_lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (51, N'Can delete lop', 13, N'delete_lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (52, N'Can view lop', 13, N'view_lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (53, N'Can add msdynamicsnapshotjobs', 14, N'add_msdynamicsnapshotjobs')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (54, N'Can change msdynamicsnapshotjobs', 14, N'change_msdynamicsnapshotjobs')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (55, N'Can delete msdynamicsnapshotjobs', 14, N'delete_msdynamicsnapshotjobs')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (56, N'Can view msdynamicsnapshotjobs', 14, N'view_msdynamicsnapshotjobs')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (57, N'Can add msdynamicsnapshotviews', 15, N'add_msdynamicsnapshotviews')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (58, N'Can change msdynamicsnapshotviews', 15, N'change_msdynamicsnapshotviews')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (59, N'Can delete msdynamicsnapshotviews', 15, N'delete_msdynamicsnapshotviews')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (60, N'Can view msdynamicsnapshotviews', 15, N'view_msdynamicsnapshotviews')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (61, N'Can add msmerge agent parameters', 16, N'add_msmergeagentparameters')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (62, N'Can change msmerge agent parameters', 16, N'change_msmergeagentparameters')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (63, N'Can delete msmerge agent parameters', 16, N'delete_msmergeagentparameters')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (64, N'Can view msmerge agent parameters', 16, N'view_msmergeagentparameters')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (65, N'Can add msmerge altsyncpartners', 17, N'add_msmergealtsyncpartners')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (66, N'Can change msmerge altsyncpartners', 17, N'change_msmergealtsyncpartners')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (67, N'Can delete msmerge altsyncpartners', 17, N'delete_msmergealtsyncpartners')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (68, N'Can view msmerge altsyncpartners', 17, N'view_msmergealtsyncpartners')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (69, N'Can add msmerge articlehistory', 18, N'add_msmergearticlehistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (70, N'Can change msmerge articlehistory', 18, N'change_msmergearticlehistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (71, N'Can delete msmerge articlehistory', 18, N'delete_msmergearticlehistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (72, N'Can view msmerge articlehistory', 18, N'view_msmergearticlehistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (73, N'Can add msmerge conflicts info', 19, N'add_msmergeconflictsinfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (74, N'Can change msmerge conflicts info', 19, N'change_msmergeconflictsinfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (75, N'Can delete msmerge conflicts info', 19, N'delete_msmergeconflictsinfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (76, N'Can view msmerge conflicts info', 19, N'view_msmergeconflictsinfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (77, N'Can add msmerge conflict ttn cs1 baithi', 20, N'add_msmergeconflictttncs1baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (78, N'Can change msmerge conflict ttn cs1 baithi', 20, N'change_msmergeconflictttncs1baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (79, N'Can delete msmerge conflict ttn cs1 baithi', 20, N'delete_msmergeconflictttncs1baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (80, N'Can view msmerge conflict ttn cs1 baithi', 20, N'view_msmergeconflictttncs1baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (81, N'Can add msmerge conflict ttn cs1 bode', 21, N'add_msmergeconflictttncs1bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (82, N'Can change msmerge conflict ttn cs1 bode', 21, N'change_msmergeconflictttncs1bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (83, N'Can delete msmerge conflict ttn cs1 bode', 21, N'delete_msmergeconflictttncs1bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (84, N'Can view msmerge conflict ttn cs1 bode', 21, N'view_msmergeconflictttncs1bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (85, N'Can add msmerge conflict ttn cs1 coso', 22, N'add_msmergeconflictttncs1coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (86, N'Can change msmerge conflict ttn cs1 coso', 22, N'change_msmergeconflictttncs1coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (87, N'Can delete msmerge conflict ttn cs1 coso', 22, N'delete_msmergeconflictttncs1coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (88, N'Can view msmerge conflict ttn cs1 coso', 22, N'view_msmergeconflictttncs1coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (89, N'Can add msmerge conflict ttn cs1 ct baithi', 23, N'add_msmergeconflictttncs1ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (90, N'Can change msmerge conflict ttn cs1 ct baithi', 23, N'change_msmergeconflictttncs1ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (91, N'Can delete msmerge conflict ttn cs1 ct baithi', 23, N'delete_msmergeconflictttncs1ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (92, N'Can view msmerge conflict ttn cs1 ct baithi', 23, N'view_msmergeconflictttncs1ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (93, N'Can add msmerge conflict ttn cs1 giaovien', 24, N'add_msmergeconflictttncs1giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (94, N'Can change msmerge conflict ttn cs1 giaovien', 24, N'change_msmergeconflictttncs1giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (95, N'Can delete msmerge conflict ttn cs1 giaovien', 24, N'delete_msmergeconflictttncs1giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (96, N'Can view msmerge conflict ttn cs1 giaovien', 24, N'view_msmergeconflictttncs1giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (97, N'Can add msmerge conflict ttn cs1 giaovien dangky', 25, N'add_msmergeconflictttncs1giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (98, N'Can change msmerge conflict ttn cs1 giaovien dangky', 25, N'change_msmergeconflictttncs1giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (99, N'Can delete msmerge conflict ttn cs1 giaovien dangky', 25, N'delete_msmergeconflictttncs1giaoviendangky')
GO
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (100, N'Can view msmerge conflict ttn cs1 giaovien dangky', 25, N'view_msmergeconflictttncs1giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (101, N'Can add msmerge conflict ttn cs1 khoa', 26, N'add_msmergeconflictttncs1khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (102, N'Can change msmerge conflict ttn cs1 khoa', 26, N'change_msmergeconflictttncs1khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (103, N'Can delete msmerge conflict ttn cs1 khoa', 26, N'delete_msmergeconflictttncs1khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (104, N'Can view msmerge conflict ttn cs1 khoa', 26, N'view_msmergeconflictttncs1khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (105, N'Can add msmerge conflict ttn cs1 lop', 27, N'add_msmergeconflictttncs1lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (106, N'Can change msmerge conflict ttn cs1 lop', 27, N'change_msmergeconflictttncs1lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (107, N'Can delete msmerge conflict ttn cs1 lop', 27, N'delete_msmergeconflictttncs1lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (108, N'Can view msmerge conflict ttn cs1 lop', 27, N'view_msmergeconflictttncs1lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (109, N'Can add msmerge conflict ttn cs1 monhoc', 28, N'add_msmergeconflictttncs1monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (110, N'Can change msmerge conflict ttn cs1 monhoc', 28, N'change_msmergeconflictttncs1monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (111, N'Can delete msmerge conflict ttn cs1 monhoc', 28, N'delete_msmergeconflictttncs1monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (112, N'Can view msmerge conflict ttn cs1 monhoc', 28, N'view_msmergeconflictttncs1monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (113, N'Can add msmerge conflict ttn cs1 sinhvien', 29, N'add_msmergeconflictttncs1sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (114, N'Can change msmerge conflict ttn cs1 sinhvien', 29, N'change_msmergeconflictttncs1sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (115, N'Can delete msmerge conflict ttn cs1 sinhvien', 29, N'delete_msmergeconflictttncs1sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (116, N'Can view msmerge conflict ttn cs1 sinhvien', 29, N'view_msmergeconflictttncs1sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (117, N'Can add msmerge conflict ttn cs2 baithi', 30, N'add_msmergeconflictttncs2baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (118, N'Can change msmerge conflict ttn cs2 baithi', 30, N'change_msmergeconflictttncs2baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (119, N'Can delete msmerge conflict ttn cs2 baithi', 30, N'delete_msmergeconflictttncs2baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (120, N'Can view msmerge conflict ttn cs2 baithi', 30, N'view_msmergeconflictttncs2baithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (121, N'Can add msmerge conflict ttn cs2 bode', 31, N'add_msmergeconflictttncs2bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (122, N'Can change msmerge conflict ttn cs2 bode', 31, N'change_msmergeconflictttncs2bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (123, N'Can delete msmerge conflict ttn cs2 bode', 31, N'delete_msmergeconflictttncs2bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (124, N'Can view msmerge conflict ttn cs2 bode', 31, N'view_msmergeconflictttncs2bode')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (125, N'Can add msmerge conflict ttn cs2 coso', 32, N'add_msmergeconflictttncs2coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (126, N'Can change msmerge conflict ttn cs2 coso', 32, N'change_msmergeconflictttncs2coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (127, N'Can delete msmerge conflict ttn cs2 coso', 32, N'delete_msmergeconflictttncs2coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (128, N'Can view msmerge conflict ttn cs2 coso', 32, N'view_msmergeconflictttncs2coso')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (129, N'Can add msmerge conflict ttn cs2 ct baithi', 33, N'add_msmergeconflictttncs2ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (130, N'Can change msmerge conflict ttn cs2 ct baithi', 33, N'change_msmergeconflictttncs2ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (131, N'Can delete msmerge conflict ttn cs2 ct baithi', 33, N'delete_msmergeconflictttncs2ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (132, N'Can view msmerge conflict ttn cs2 ct baithi', 33, N'view_msmergeconflictttncs2ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (133, N'Can add msmerge conflict ttn cs2 giaovien', 34, N'add_msmergeconflictttncs2giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (134, N'Can change msmerge conflict ttn cs2 giaovien', 34, N'change_msmergeconflictttncs2giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (135, N'Can delete msmerge conflict ttn cs2 giaovien', 34, N'delete_msmergeconflictttncs2giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (136, N'Can view msmerge conflict ttn cs2 giaovien', 34, N'view_msmergeconflictttncs2giaovien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (137, N'Can add msmerge conflict ttn cs2 giaovien dangky', 35, N'add_msmergeconflictttncs2giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (138, N'Can change msmerge conflict ttn cs2 giaovien dangky', 35, N'change_msmergeconflictttncs2giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (139, N'Can delete msmerge conflict ttn cs2 giaovien dangky', 35, N'delete_msmergeconflictttncs2giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (140, N'Can view msmerge conflict ttn cs2 giaovien dangky', 35, N'view_msmergeconflictttncs2giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (141, N'Can add msmerge conflict ttn cs2 khoa', 36, N'add_msmergeconflictttncs2khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (142, N'Can change msmerge conflict ttn cs2 khoa', 36, N'change_msmergeconflictttncs2khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (143, N'Can delete msmerge conflict ttn cs2 khoa', 36, N'delete_msmergeconflictttncs2khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (144, N'Can view msmerge conflict ttn cs2 khoa', 36, N'view_msmergeconflictttncs2khoa')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (145, N'Can add msmerge conflict ttn cs2 lop', 37, N'add_msmergeconflictttncs2lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (146, N'Can change msmerge conflict ttn cs2 lop', 37, N'change_msmergeconflictttncs2lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (147, N'Can delete msmerge conflict ttn cs2 lop', 37, N'delete_msmergeconflictttncs2lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (148, N'Can view msmerge conflict ttn cs2 lop', 37, N'view_msmergeconflictttncs2lop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (149, N'Can add msmerge conflict ttn cs2 monhoc', 38, N'add_msmergeconflictttncs2monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (150, N'Can change msmerge conflict ttn cs2 monhoc', 38, N'change_msmergeconflictttncs2monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (151, N'Can delete msmerge conflict ttn cs2 monhoc', 38, N'delete_msmergeconflictttncs2monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (152, N'Can view msmerge conflict ttn cs2 monhoc', 38, N'view_msmergeconflictttncs2monhoc')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (153, N'Can add msmerge conflict ttn cs2 sinhvien', 39, N'add_msmergeconflictttncs2sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (154, N'Can change msmerge conflict ttn cs2 sinhvien', 39, N'change_msmergeconflictttncs2sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (155, N'Can delete msmerge conflict ttn cs2 sinhvien', 39, N'delete_msmergeconflictttncs2sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (156, N'Can view msmerge conflict ttn cs2 sinhvien', 39, N'view_msmergeconflictttncs2sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (157, N'Can add msmerge conflict ttn tc lop', 40, N'add_msmergeconflictttntclop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (158, N'Can change msmerge conflict ttn tc lop', 40, N'change_msmergeconflictttntclop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (159, N'Can delete msmerge conflict ttn tc lop', 40, N'delete_msmergeconflictttntclop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (160, N'Can view msmerge conflict ttn tc lop', 40, N'view_msmergeconflictttntclop')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (161, N'Can add msmerge conflict ttn tc sinhvien', 41, N'add_msmergeconflictttntcsinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (162, N'Can change msmerge conflict ttn tc sinhvien', 41, N'change_msmergeconflictttntcsinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (163, N'Can delete msmerge conflict ttn tc sinhvien', 41, N'delete_msmergeconflictttntcsinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (164, N'Can view msmerge conflict ttn tc sinhvien', 41, N'view_msmergeconflictttntcsinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (165, N'Can add msmerge contents', 42, N'add_msmergecontents')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (166, N'Can change msmerge contents', 42, N'change_msmergecontents')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (167, N'Can delete msmerge contents', 42, N'delete_msmergecontents')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (168, N'Can view msmerge contents', 42, N'view_msmergecontents')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (169, N'Can add msmerge current partition mappings', 43, N'add_msmergecurrentpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (170, N'Can change msmerge current partition mappings', 43, N'change_msmergecurrentpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (171, N'Can delete msmerge current partition mappings', 43, N'delete_msmergecurrentpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (172, N'Can view msmerge current partition mappings', 43, N'view_msmergecurrentpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (173, N'Can add msmerge partition groups', 44, N'add_msmergepartitiongroups')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (174, N'Can change msmerge partition groups', 44, N'change_msmergepartitiongroups')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (175, N'Can delete msmerge partition groups', 44, N'delete_msmergepartitiongroups')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (176, N'Can view msmerge partition groups', 44, N'view_msmergepartitiongroups')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (177, N'Can add msmerge errorlineage', 45, N'add_msmergeerrorlineage')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (178, N'Can change msmerge errorlineage', 45, N'change_msmergeerrorlineage')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (179, N'Can delete msmerge errorlineage', 45, N'delete_msmergeerrorlineage')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (180, N'Can view msmerge errorlineage', 45, N'view_msmergeerrorlineage')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (181, N'Can add msmerge generation partition mappings', 46, N'add_msmergegenerationpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (182, N'Can change msmerge generation partition mappings', 46, N'change_msmergegenerationpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (183, N'Can delete msmerge generation partition mappings', 46, N'delete_msmergegenerationpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (184, N'Can view msmerge generation partition mappings', 46, N'view_msmergegenerationpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (185, N'Can add msmerge genhistory', 47, N'add_msmergegenhistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (186, N'Can change msmerge genhistory', 47, N'change_msmergegenhistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (187, N'Can delete msmerge genhistory', 47, N'delete_msmergegenhistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (188, N'Can view msmerge genhistory', 47, N'view_msmergegenhistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (189, N'Can add msmerge history', 48, N'add_msmergehistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (190, N'Can change msmerge history', 48, N'change_msmergehistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (191, N'Can delete msmerge history', 48, N'delete_msmergehistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (192, N'Can view msmerge history', 48, N'view_msmergehistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (193, N'Can add msmerge identity range', 49, N'add_msmergeidentityrange')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (194, N'Can change msmerge identity range', 49, N'change_msmergeidentityrange')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (195, N'Can delete msmerge identity range', 49, N'delete_msmergeidentityrange')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (196, N'Can view msmerge identity range', 49, N'view_msmergeidentityrange')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (197, N'Can add msmerge log files', 50, N'add_msmergelogfiles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (198, N'Can change msmerge log files', 50, N'change_msmergelogfiles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (199, N'Can delete msmerge log files', 50, N'delete_msmergelogfiles')
GO
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (200, N'Can view msmerge log files', 50, N'view_msmergelogfiles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (201, N'Can add msmerge metadataaction request', 51, N'add_msmergemetadataactionrequest')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (202, N'Can change msmerge metadataaction request', 51, N'change_msmergemetadataactionrequest')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (203, N'Can delete msmerge metadataaction request', 51, N'delete_msmergemetadataactionrequest')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (204, N'Can view msmerge metadataaction request', 51, N'view_msmergemetadataactionrequest')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (205, N'Can add msmerge past partition mappings', 52, N'add_msmergepastpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (206, N'Can change msmerge past partition mappings', 52, N'change_msmergepastpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (207, N'Can delete msmerge past partition mappings', 52, N'delete_msmergepastpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (208, N'Can view msmerge past partition mappings', 52, N'view_msmergepastpartitionmappings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (209, N'Can add msmerge replinfo', 53, N'add_msmergereplinfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (210, N'Can change msmerge replinfo', 53, N'change_msmergereplinfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (211, N'Can delete msmerge replinfo', 53, N'delete_msmergereplinfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (212, N'Can view msmerge replinfo', 53, N'view_msmergereplinfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (213, N'Can add msmerge sessions', 54, N'add_msmergesessions')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (214, N'Can change msmerge sessions', 54, N'change_msmergesessions')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (215, N'Can delete msmerge sessions', 54, N'delete_msmergesessions')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (216, N'Can view msmerge sessions', 54, N'view_msmergesessions')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (217, N'Can add msmerge settingshistory', 55, N'add_msmergesettingshistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (218, N'Can change msmerge settingshistory', 55, N'change_msmergesettingshistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (219, N'Can delete msmerge settingshistory', 55, N'delete_msmergesettingshistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (220, N'Can view msmerge settingshistory', 55, N'view_msmergesettingshistory')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (221, N'Can add msmerge supportability settings', 56, N'add_msmergesupportabilitysettings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (222, N'Can change msmerge supportability settings', 56, N'change_msmergesupportabilitysettings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (223, N'Can delete msmerge supportability settings', 56, N'delete_msmergesupportabilitysettings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (224, N'Can view msmerge supportability settings', 56, N'view_msmergesupportabilitysettings')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (225, N'Can add msmerge tombstone', 57, N'add_msmergetombstone')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (226, N'Can change msmerge tombstone', 57, N'change_msmergetombstone')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (227, N'Can delete msmerge tombstone', 57, N'delete_msmergetombstone')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (228, N'Can view msmerge tombstone', 57, N'view_msmergetombstone')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (229, N'Can add msrepl errors', 58, N'add_msreplerrors')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (230, N'Can change msrepl errors', 58, N'change_msreplerrors')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (231, N'Can delete msrepl errors', 58, N'delete_msreplerrors')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (232, N'Can view msrepl errors', 58, N'view_msreplerrors')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (233, N'Can add sinhvien', 59, N'add_sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (234, N'Can change sinhvien', 59, N'change_sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (235, N'Can delete sinhvien', 59, N'delete_sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (236, N'Can view sinhvien', 59, N'view_sinhvien')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (237, N'Can add sysdiagrams', 60, N'add_sysdiagrams')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (238, N'Can change sysdiagrams', 60, N'change_sysdiagrams')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (239, N'Can delete sysdiagrams', 60, N'delete_sysdiagrams')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (240, N'Can view sysdiagrams', 60, N'view_sysdiagrams')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (241, N'Can add sysmergearticles', 61, N'add_sysmergearticles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (242, N'Can change sysmergearticles', 61, N'change_sysmergearticles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (243, N'Can delete sysmergearticles', 61, N'delete_sysmergearticles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (244, N'Can view sysmergearticles', 61, N'view_sysmergearticles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (245, N'Can add sysmergepartitioninfo', 62, N'add_sysmergepartitioninfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (246, N'Can change sysmergepartitioninfo', 62, N'change_sysmergepartitioninfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (247, N'Can delete sysmergepartitioninfo', 62, N'delete_sysmergepartitioninfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (248, N'Can view sysmergepartitioninfo', 62, N'view_sysmergepartitioninfo')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (249, N'Can add sysmergepublications', 63, N'add_sysmergepublications')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (250, N'Can change sysmergepublications', 63, N'change_sysmergepublications')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (251, N'Can delete sysmergepublications', 63, N'delete_sysmergepublications')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (252, N'Can view sysmergepublications', 63, N'view_sysmergepublications')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (253, N'Can add sysmergeschemaarticles', 64, N'add_sysmergeschemaarticles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (254, N'Can change sysmergeschemaarticles', 64, N'change_sysmergeschemaarticles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (255, N'Can delete sysmergeschemaarticles', 64, N'delete_sysmergeschemaarticles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (256, N'Can view sysmergeschemaarticles', 64, N'view_sysmergeschemaarticles')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (257, N'Can add sysmergeschemachange', 65, N'add_sysmergeschemachange')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (258, N'Can change sysmergeschemachange', 65, N'change_sysmergeschemachange')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (259, N'Can delete sysmergeschemachange', 65, N'delete_sysmergeschemachange')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (260, N'Can view sysmergeschemachange', 65, N'view_sysmergeschemachange')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (261, N'Can add sysmergesubscriptions', 66, N'add_sysmergesubscriptions')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (262, N'Can change sysmergesubscriptions', 66, N'change_sysmergesubscriptions')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (263, N'Can delete sysmergesubscriptions', 66, N'delete_sysmergesubscriptions')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (264, N'Can view sysmergesubscriptions', 66, N'view_sysmergesubscriptions')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (265, N'Can add sysmergesubsetfilters', 67, N'add_sysmergesubsetfilters')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (266, N'Can change sysmergesubsetfilters', 67, N'change_sysmergesubsetfilters')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (267, N'Can delete sysmergesubsetfilters', 67, N'delete_sysmergesubsetfilters')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (268, N'Can view sysmergesubsetfilters', 67, N'view_sysmergesubsetfilters')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (269, N'Can add sysreplservers', 68, N'add_sysreplservers')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (270, N'Can change sysreplservers', 68, N'change_sysreplservers')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (271, N'Can delete sysreplservers', 68, N'delete_sysreplservers')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (272, N'Can view sysreplservers', 68, N'view_sysreplservers')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (273, N'Can add ct baithi', 69, N'add_ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (274, N'Can change ct baithi', 69, N'change_ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (275, N'Can delete ct baithi', 69, N'delete_ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (276, N'Can view ct baithi', 69, N'view_ctbaithi')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (277, N'Can add giaovien dangky', 70, N'add_giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (278, N'Can change giaovien dangky', 70, N'change_giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (279, N'Can delete giaovien dangky', 70, N'delete_giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (280, N'Can view giaovien dangky', 70, N'view_giaoviendangky')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (281, N'Can add msmerge dynamic snapshots', 71, N'add_msmergedynamicsnapshots')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (282, N'Can change msmerge dynamic snapshots', 71, N'change_msmergedynamicsnapshots')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (283, N'Can delete msmerge dynamic snapshots', 71, N'delete_msmergedynamicsnapshots')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (284, N'Can view msmerge dynamic snapshots', 71, N'view_msmergedynamicsnapshots')
SET IDENTITY_INSERT [dbo].[auth_permission] OFF
GO
SET IDENTITY_INSERT [dbo].[BAITHI] ON 

INSERT [dbo].[BAITHI] ([MABT], [MASV], [MAMH], [LAN], [NGAYTHI], [DIEM], [TGCL]) VALUES (15, N'001     ', N'csdl ', 1, CAST(N'2024-07-03' AS Date), 0, 1800)
SET IDENTITY_INSERT [dbo].[BAITHI] OFF
GO
SET IDENTITY_INSERT [dbo].[BODE] ON 

INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (3, N'MMTCB', N'A', N'Để máy tính truyền dữ liệu cho một số máy khác trong mạng, ta dùng loại địa chỉ', N'Broadcast', N'Broadband', N'Multicast', N'Multiple access', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (4, N'MMTCB', N'A', N'thứ tự phân loại mạng theo chiều dài đường truyền', N'internet, lan, man, wan', N'internet, wan, man, lan', N'lan, wan, man, internet', N'man, lan, wan, internet', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (5, N'MMTCB', N'A', N'mạng man được sử dụng trong phạm vi:', N'quốc gia', N'lục địa', N'khu phố', N'thành phố', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (6, N'MMTCB', N'A', N'thuật ngữ man được viết tắt bởi:', N'middle area network', N'metropolitan area network', N'medium area network', N'multiple access network', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (7, N'MMTCB', N'A', N'mạng man không kết nối theo sơ đồ:', N'bus', N'ring', N'star', N'tree', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (8, N'MMTCB', N'A', N'kiến trúc mạng (network architechture) là:', N'tập các chức năng trong mạng', N'tập các cấp và các protocol trong mỗi cấp', N'tập các dịch vụ trong mạng', N'tập các protocol trong mạng', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (9, N'MMTCB', N'A', N'thuật ngữ nào không cùng nhóm:', N'simplex', N'multiplex', N'half duplex', N'full duplex', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (10, N'MMTCB', N'A', N'loại dịch vụ nào có thể nhận dữ liệu không đúng thứ tự khi truyền', N'point to point', N'có kết nối', N'không kết nối', N'broadcast', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (11, N'MMTCB', N'A', N'dịch vụ không xác nhận (unconfirmed) chỉ sử dụng 2 phép toán cơ bản:', N'response and confirm', N'confirm and request', N'request and indication', N'indication and response', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (12, N'MMTCB', N'A', N'Chọn câu sai trong các nguyên lý phân cấp của mô hình OSI', N'Mỗi cấp thực hiện 1 chức năng rõ ràng', N'Mỗi cấp được chọn sao cho thông tin trao đổi giữa các cấp tối thiểu', N'Mỗi cấp được tạo ra ứng với 1 mức trừu tượng hóa', N'Mỗi cấp phải cung cấp cùng 1 kiểu địa chỉ và dịch vụ', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (13, N'MMTCB', N'A', N'Chức năng của cấp vật lý(physical)', N'Qui định truyền 1 hay 2 chiều', N'Quản lý lỗi sai', N'Xác định thời gian truyền 1 bit dữ liệu', N'Quản lý địa chỉ vật lý', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (14, N'MMTCB', N'A', N'Chức năng câp liên kết dữ liệu (data link)', N'Quản lý lỗi sai', N'Mã hóa dữ liệu', N'Tìm đường đi cho dữ liệu', N'Chọn kênh truyền', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (15, N'MMTCB', N'A', N'Chức năng cấp mạng (network)', N'Quản lý lưu lượng đường truyền', N'Điều khiển hoạt động subnet', N'Nén dữ liệu', N'Chọn điện áp trên kênh truyền', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (16, N'MMTCB', N'A', N'Chức năng cấp vận tải (transport) ', N'Quản lý địa chỉ mạng', N'Chuyển đổi các dạng frame khác nhau', N'Thiết lập và hủy bỏ dữ liệu', N'Mã hóa và giải mã dữ liệu', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (17, N'MMTCB', N'A', N'Cáp xoắn đôi trong mạng LAN dùng đầu nối', N'AUI', N'BNC', N'RJ11', N'RJ45', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (18, N'MMTCB', N'A', N'T-connector dùng trong loại cáp', N'10Base-2', N'10Base-5', N'10Base-T', N'10Base-F', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (19, N'MMTCB', N'A', N'chọn câu sai trong các nguyên lý phân cấp của mô hình osi', N'mỗi cấp thực hiện 1 chức năng rõ ràng', N'mỗi cấp được chọn sao cho thông tin trao đổi giữa các cấp tối thiểu', N'mỗi cấp được tạo ra ứng với 1 mức trừu tượng hóa', N'mỗi cấp phải cung cấp cùng một kiểu địa chỉ và dịch vụ', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (20, N'AVCB ', N'A', N'The publishers suggested that the envelopes be sent to ...... by courier so that the film can be developed as soon as possible', N'they', N'their', N'theirs', N'them', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (21, N'AVCB ', N'A', N'Board members ..... carefully define their goals and objectives for the agency before the monthly meeting next week.', N'had', N'should', N'used ', N'have', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (22, N'AVCB ', N'A', N'For business relations to continue between our two firms, satisfactory agreement must be ...... reached and signer', N'yet', N'both', N'either ', N'as well as', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (23, N'AVCB ', N'A', N'The corporation, which underwent a major restructing seven years ago, has been growing steadily ......five years', N'for', N'on', N'from', N'since', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (24, N'AVCB ', N'A', N'Making advance arrangements for audiovisual equipment is....... recommended for all seminars.', N'sternly', N'strikingly', N'stringently', N'strongly', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (25, N'AVCB ', N'A', N'Two assistants will be required to ...... reporter''s names when they arrive at the press conference', N'remark', N'check', N'notify', N'ensure', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (26, N'AVCB ', N'A', N'The present government has an excellent ......to increase exports', N'popularity', N'regularity', N'celebrity', N'opportunity', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (27, N'AVCB ', N'A', N'While you are in the building, please wear your identification badge at all times so that you are ....... as a company employee.', N'recognize', N'recognizing', N'recognizable', N'recognizably', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (28, N'AVCB ', N'A', N'Our studies show that increases in worker productivity have not been adequately .......rewarded by significant increases in ......', N'compensation', N'commodity', N'compilation', N'complacency', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (29, N'AVCB ', N'A', N'Conservatives predict that government finaces will remain...... during the period of the investigation', N'authoritative', N'summarized', N'examined', N'stable', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (30, N'AVCB ', N'B', N'Battery-operated reading lamps......very well right now', N'sale', N'sold', N'are selling', N'were sold', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (31, N'AVCB ', N'B', N'In order to place a call outside the office, you have to .......nine first. ', N'tip', N'make', N'dial', N'number', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (32, N'AVCB ', N'B', N'We are pleased to inform...... that the missing order has been found.', N'you', N'your', N'yours', N'yourseld', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (33, N'AVCB ', N'B', N'Unfortunately, neither Mr.Sachs....... Ms Flynn will be able to attend the awards banquet this evening', N'but', N'and', N' nor', N'either', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (34, N'AVCB ', N'B', N'According to the manufacturer, the new generatir is capable of....... the amount of power consumed by our facility by nearly ten percent.', N'reduced', N'reducing', N'reduce', N'reduces', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (35, N'AVCB ', N'B', N'After the main course, choose from our wide....... of homemade deserts', N'varied', N'various', N'vary', N'variety', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (36, N'AVCB ', N'B', N'One of the most frequent complaints among airline passengers is that there is not ...... legroom', N'enough', N'many', N'very', N'plenty', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (37, N'AVCB ', N'B', N'Faculty members are planning to..... a party in honor of Dr.Walker, who will retire at the end of the semester', N'carry', N'do', N'hold', N'take', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (38, N'AVCB ', N'B', N'Many employees seem more ....... now about how to use the new telephone system than they did before they attended the workshop', N'confusion', N'confuse', N'confused', N'confusing', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (39, N'AVCB ', N'B', N'.........our production figures improve in the near future, we foresee having to hire more people between now and July', N'During', N'Only', N'Unless', N'Because', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (40, N'AVCB ', N'C', N'Though their performance was relatively unpolished, the actors held the audience''s ........for the duration of the play.', N'attentive', N'attentively', N'attention', N'attentiveness', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (41, N'AVCB ', N'C', N'Dr. Abernathy''s donation to Owstion College broke the record for the largest private gift...... give to the campus', N'always', N'rarely', N'once', N'ever', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (42, N'AVCB ', N'C', N'Savat Nation Park is ....... by train,bus, charter plane, and rental car.', N'accessible', N'accessing', N'accessibility', N'accesses', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (43, N'AVCB ', N'C', N'In Piazzo''s lastest architectural project, he hopes to......his flare for blending contemporary and traditional ideals.', N'demonstrate', N'appear', N'valve', N'position', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (44, N'AVCB ', N'C', N'Replacing the offic equipment that the company purchased only three years ago seems quite.....', N'waste', N'wasteful', N'wasting', N'wasted', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (45, N'AVCB ', N'C', N'On........, employees reach their peak performance level when they have been on the job for at least two years.', N'common', N'standard', N'average', N'general', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (46, N'AVCB ', N'C', N'We were........unaware of the problems with the air-conidtioning units in the hotel rooms until this week.', N'complete ', N'completely', N'completed', N'completing', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (47, N'AVCB ', N'C', N'If you send in an order ....... mail, we recommend that you phone our sales division directly to confirm the order.', N'near', N'by', N'for', N'on', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (48, N'AVCB ', N'C', N'A recent global survey suggests.......... demand for aluminum and tin will remain at its current level for the next five to ten years.', N'which', N'it ', N'that', N'both', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (49, N'AVCB ', N'C', N'Rates for the use of recreational facilities do not include ta and are subject to change without.........', N'signal', N'cash', N'report', N'notice', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (50, N'AVCB ', N'A', N'Aswering telephone calls is the..... of an operator', N'responsible', N'responsibly', N'responsive', N'responsibility', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (51, N'AVCB ', N'A', N'A free watch will be provided with every purchase of $20.00 or more a ........ period of time', N'limit', N'limits', N'limited', N'limiting', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (52, N'AVCB ', N'A', N'The president of the corporation has .......arrived in Copenhagen and will meet with the Minister of Trade on Monday morning', N'still', N'yet', N'already', N'soon', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (53, N'AVCB ', N'A', N'Because we value your business, we have .......for card members like you to receive one thousand  dollars of complimentary life insurance', N'arrange', N'arranged', N'arranges', N'arranging', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (54, N'AVCB ', N'A', N'Employees are........that due to the new government regulations. there is to be no smoking in the factory', N'reminded', N'respected', N'remembered', N'reacted', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (55, N'AVCB ', N'A', N'MS. Galera gave a long...... in honor of the retiring vice-president', N'speak', N'speaker', N'speaking', N'speech', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (56, N'AVCB ', N'A', N'Any person who is........ in volunteering his or her time for the campaign should send this office a letter of intent', N'interest', N'interested', N'interesting', N'interestingly', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (57, N'AVCB ', N'A', N'Mr.Gonzales was very concerned.........the upcoming board of directors meeting', N'to', N'about', N'at ', N'upon', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (58, N'AVCB ', N'A', N'The customers were told that no ........could be made on weekend nights because the restaurant was too busy', N'delays', N'cuisines', N'reservation', N'violations', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (59, N'AVCB ', N'A', N'The sales representive''s presentation was difficult to understand ........ he spoke very quickly', N'because', N'althought', N'so that', N'than', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (60, N'AVCB ', N'B', N'It has been predicted that an.......weak dollar will stimulate tourism in the United States', N'increased', N'increasingly', N'increases', N'increase', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (61, N'AVCB ', N'B', N'The firm is not liable for damage resulting from circumstances.........its control.', N'beyond', N'above', N'inside', N'around', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (62, N'AVCB ', N'B', N'Because of.......weather conditions, California has an advantage in the production of fruits and vegetables', N'favorite', N'favor', N'favorable', N'favorably', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (63, N'AVCB ', N'B', N'On international shipments, all duties and taxes are paid by the..........', N'recipient', N'receiving', N'receipt', N'receptive', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (64, N'AVCB ', N'B', N'Although the textbook gives a definitive answer,wise managers will look for........ own creative solutions', N'them', N'their', N'theirs', N'they', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (65, N'AVCB ', N'B', N'Initial ....... regarding the merger of the companies took place yesterday at the Plaza Conference Center.', N'negotiations', N'dedications', N'propositions', N'announcements', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (66, N'AVCB ', N'B', N'Please......... photocopies of all relevant docunments to this office ten days prior to your performance review date', N'emerge', N'substantiate', N'adapt', N'submit', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (67, N'AVCB ', N'B', N'The auditor''s results for the five year period under study were .........the accountant''s', N'same', N'same as', N'the same', N'the same as', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (68, N'AVCB ', N'B', N'.........has the marketing environment been more complex and subject to change', N'Totally', N'Negatively', N'Decidedly', N'Rarely', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (69, N'AVCB ', N'B', N'All full-time staff are eligible to participate in the revised health plan, which becomes effective the first ......... the month.', N'of', N'to', N'from', N'for', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (70, N'AVCB ', N'C', N'Contracts must be read........ before they are signed.', N'thoroughness', N'more thorough', N'thorough', N'thoroughly', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (71, N'AVCB ', N'C', N'Passengers should allow for...... travel time to the airport in rush hour traffic', N'addition', N'additive', N'additionally', N'additional', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (72, N'AVCB ', N'C', N'This fiscal year, the engineering team has worked well together on all phases ofproject.........', N'development', N'developed', N'develops', N'developer', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (73, N'AVCB ', N'C', N'Mr.Dupont had no ....... how long it would take to drive downtown', N'knowledge', N'thought', N'idea', N'willingness', N'C', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (74, N'AVCB ', N'C', N'Small company stocks usually benefit..........the so called January effect that cause the price of these stocks to rise between November and January', N'unless', N'from', N'to ', N'since', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (75, N'AVCB ', N'C', N'It has been suggested that employees ........to work in their current positions until the quarterly review is finished.', N'continuity', N'continue', N'continuing', N'continuous', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (76, N'AVCB ', N'C', N'It is admirable that Ms.Jin wishes to handle all transactions by........, but it might be better if several people shared the responsibility', N'she', N'herself', N'her', N'hers', N'B', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (77, N'AVCB ', N'C', N'This new highway construction project will help the company.........', N'diversity', N'clarify', N'intensify', N'modify', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (78, N'AVCB ', N'C', N'Ms.Patel has handed in an ........business plan to the director', N'anxious', N'evident', N'eager', N'outstanding', N'D', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (79, N'AVCB ', N'C', N'Recent changes in heating oil costs have affected..........production of turniture', N'Local', N'Locality', N'Locally', N'Location', N'A', N'TH234   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (80, N'MMTCB', N'A', N'Termiator là linh kiện dùng trong loại cáp mạng', N'Cáp quang', N'UTP và STP ', N'Xoắn đôi', N'Đồng trục', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (81, N'MMTCB', N'A', N'Mạng không dây dùng loại sóng nào không bị ảnh hưởng bởi khoảng cách địa lý', N'Sóng radio', N'Sống hồng ngoại', N'Sóng viba', N'Song cực ngắn', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (82, N'MMTCB', N'A', N'Đường truyền E1 gồm 32 kênh, trong đó sử dụng cho dữ liệu là:', N'32 kênh', N'31 kênh', N'30 kênh', N'24 kênh', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (83, N'MMTCB', N'A', N'Mạng máy tính thường sử dụng loại chuyển mach', N'Gói (packet switch)', N'Kênh (Circuit switch)', N'Thông báo(message switch)', N'Tất cả đều đúng', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (84, N'MMTCB', N'A', N'Cáp UTP hỗ trợ tôc độ truyền 100MBps là loại', N'Cat 3', N'Cat 4', N'Cat 5', N'Cat 6', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (85, N'MMTCB', N'A', N'Thiết bị nào làm việc trong cấp vật lý (physical) ', N'Terminator', N'Hub', N'Repeater', N'Tất cả đều đúng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (86, N'MMTCB', N'A', N'Phương pháp dồn kênh phân chia tần số gọi là', N'FDM', N'WDM', N'TDM', N'CSMA', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (87, N'MMTCB', N'A', N'Dịch vụ nào không sử dụng trong cấp data link', N'Xác nhận, có kết nối', N'Xác nhận, không kết nôi', N'Không xác nhận, có kết nối', N'Không xác nhận, không kết nối', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (88, N'MMTCB', N'A', N'Nguyên nhân gây sai sót khi gửi/nhận dữ liệu trên mạng', N'Mất đồng bộ trong khi truyền', N'Nhiễu từ môi trường', N'Lỗi phần cứng hoặc phần mềm', N'Tất cả đều đúng ', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (89, N'MMTCB', N'A', N'Để tránh sai sót khi truyền dữ liệu trong cấp data link', N'Đánh số thứ tự frame', N'Quản lý dữ liệu theo frame', N'Dùng vùng checksum', N'Tất cả đều đúng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (90, N'MMTCB', N'A', N'Quản lý lưu lượng đường truyền là chức năng của cấp', N'Presentation', N'Network', N'Data link', N'Physical', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (91, N'MMTCB', N'A', N'Hoạt động của protocol Stop and Wait', N'Chờ một khoảng thời gian time-out rồi gửi tiếp frame kế', N'Chờ 1 khoảng thời gian time-out rồi gửi lại frame trước', N'Chờ nhận được ACK của frame trước mới gửi tiếp frame kế', N'Không chờ mà gửi liên tiếp các frame kế nhau', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (92, N'MMTCB', N'A', N'Protocol nào tạo frame bằng phương pháp chèn kí tự', N'ADCCP', N'HDLC', N'SDLC', N'PPP', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (93, N'MMTCB', N'A', N'Phương pháp nào được dủng trong việc phát hiện lỗi', N'Timer', N'Ack', N'Checksum', N'Tất cả đều đúng', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (94, N'MMTCB', N'A', N'Kiểm soát lưu lượng (flow control) có nghĩa là', N'Thay đổi thứ tự truyền frame', N'Điều tiết tốc độ truyền frame', N'Thay đổi thời gian chờ time-out', N'Điều chỉnh kích thước frame', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (95, N'MMTCB', N'A', N'Khả năng nhận biết tình trạng đường truyền ( carrier sence) là', N'Xác định đường truyền tốt hay xấu', N'Có kết nối được hay không', N'Nhận biết có xung đột hay không', N'Đường truyền đang rảnh hay bận', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (96, N'MMTCB', N'A', N'Mạng nào không có khả năng nhận biết tình trạng đường truyền (carrier sence)', N'ALOHA', N'CSMA', N'CSMA/CD', N'Tất cả đều đúng ', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (97, N'MMTCB', N'A', N'Mạng nào có khả năng nhận biết xung đột (collision)', N'ALOHA', N'CSMA', N'CSMA/CD', N'Tất cả đều đúng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (98, N'MMTCB', N'A', N'Chuẩn mạng nào có khả năng pkhát hiện xung đột (collision) trong khi truyền', N'1-persistent CSMA', N'p-persistent CSMA', N'Non-persistent CSMA', N'CSMA/CD', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (99, N'MMTCB', N'A', N'Loại mạng cục bộ nào dùng chuẩn CSMA/CD', N'Token-ring', N'Token-bus', N'Ethernet', N'ArcNet', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (100, N'MMTCB', N'A', N'Mạng Ethernet được IEEE đưa vào chuẩn', N'IEEE 802.2', N'IEEE 802.3', N'IEEE 802.4', N'IEEE 802.5', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (101, N'MMTCB', N'A', N'Chuẩn nào không dùng trong mạng cục bộ (LAN )', N'IEEE 802.3', N'IEEE 802.4', N'IEEE 802.5', N'IEEE 802.6', N'D', N'TH123   ')
GO
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (102, N'MMTCB', N'A', N'Loại mạng nào dùng 1 máy tính làm Monitor để bảo trì mạng', N'Ethernet', N'Token-ring', N'Token-bus', N'Tất cả đều sai', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (103, N'MMTCB', N'A', N'Loại mạng nào không có độ ưu tiên', N'Ethernet', N'Token-ring', N'Token-bus', N'Tất cả đều sai', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (104, N'MMTCB', N'A', N'Loại mạng nào dùng 2 loại frame khác nhau trên đường truyền', N'Token-ring', N'Token-bus', N'Ethernet', N'Tất cả đều sai', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (105, N'MMTCB', N'A', N'Vùng dữ liệu trong mạng Ethernet chứa tối đa', N'185 bytes', N'1500 bytes', N'8182 bytes', N'Không giới hạn', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (106, N'MMTCB', N'A', N'Chọn câu sai:" Cầu nối (bridge) có thể kết nối các mạng có...."', N'Chiều dài frame khác nhau', N'Cấu trúc frame khác nhau', N'Tốc độ truyền khác nhau', N'Chuẩn khác nhau', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (107, N'MMTCB', N'A', N'Mạng nào có tốc độ truyền lớn hơn 100Mbps', N'Fast Ethernet', N'Gigabit Ethernet', N'Ethernet', N'Tất cả đều đúng', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (108, N'MMTCB', N'A', N'Mạng Ethernet sử dụng được loại cáp', N'Cáp quang', N'Xoắn đôi', N'Đồng trục', N'Tất cả đều đúgn', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (109, N'MMTCB', N'A', N'Khoảng cách đường truyền tối đa mạng FDDI có thể đạt', N'1Km', N'10Km', N'100Km', N'1000Km', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (110, N'MMTCB', N'A', N'Cấp network truyền nhận theo kiểu end-to-end vì nó quản lý dữ liệu', N'Giữa 2 đầu subnet', N'Giữa 2 máy tính trong mạng', N'Giữa 2 thiết bị trên đường truyền', N'Giữa 2 đầu đường truyền', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (111, N'MMTCB', N'A', N'Kiểu mạch ảo(virtual circuit) được dùng trong loại dịch vụ mạng', N'Có kết nối', N'Không kết nối', N'Truyền 1 chiều', N'Truyền 2 chiều', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (112, N'MMTCB', N'A', N'Kiểu datagram trong cấp network', N'Chỉ tìm đường 1 lần khi tạo kết nối', N'Phải tìm đường riêng cho từng packet', N'THông tin có sẵn trong packet, không cần tìm đường', N'Thông tin có sẵn trong router , không cần tìm đường', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (113, N'MMTCB', N'A', N'Kiểm soát tắc nghẽn (congestion) là nhiệm vụ của cấp', N'Physical', N'Transport', N'Data link', N'Network', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (114, N'MMTCB', N'A', N'Nguyên nhân dẫn đến tắt nghẻn (congestion) trên mạng', N'Tốc độ xử lý của router chậm', N'Buffers trong router nhỏ', N'Router có nhiều đường vào nhưng ít đường ra', N'Tất cả đều đúng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (115, N'MMTCB', N'A', N'Cấp appliation trong mô hình TCP/IP tương đương với cấp nào trong mô hình OSI', N'Session', N'Application', N'Presentation', N'Tất cả đều đúng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (116, N'MMTCB', N'A', N'Cấp nào trong mô hình mạng OSI tương đương với cấp Internet trong mô hình TCP/IP ', N'Network', N'Transport', N'Physical', N'Data link', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (117, N'MMTCB', N'A', N'Chất lượng dịch vụ mạng không được đánh giá trên chỉ tiêu nào?', N'Thời gian thiết lập kết nối ngắn', N'Tỉ lệ sai sót rất nhỏ', N'Tốc độ đường truyền cao', N'Khả năng phục hồi khi có sự cố', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (118, N'MMTCB', N'A', N'Kỹ thuật Multiplexing được dùng khi', N'Có nhiều kênh truyền hơn đường truyền', N'Có nhiều đường truyền hơn kênh truyền', N'Truyền dữ liệu số trên mạng điện thoại', N'Truyền dữ liệu tương tự trên mạng điện thọai', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (119, N'MMTCB', N'A', N'Dịch vụ truyền Email sử dụng protocol nào?', N'HTTP', N'NNTP', N'SMTP', N'FTP', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (120, N'MMTCB', N'A', N'Địa chỉ IP lớp B nằm trong phạm vi nào', N'192.0.0.0 - 223.0.0.0', N'127.0.0.0 - 191.0.0.0', N'128.0.0.0 - 191.0.0.0 ', N'1.0.0.0 - 126.0.0.0', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (121, N'MMTCB', N'A', N'Subnet Mask nào sau đây chỉ cho tối đa 2 địa chỉ host', N'255.255.255.252', N'255.255.255.254', N'255.255.255.248', N'255.255.255.240', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (122, N'MMTCB', N'A', N'Thành phần nào không thuộc socket', N'Port', N'Địa chỉ IP', N'Địa chỉ cấp MAC', N'Protocol cấp Transport', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (123, N'MMTCB', N'A', N'Mục đích của Subnet Mask trong địa chỉ IP là', N'Xác định host của địa chỉ IP', N'Xác định vùng network của địa chỉ IP', N'Lấy các bit trong vùng subnet làm địa chỉ host', N'Lấy các bit trong vùng địa chỉ host làm subnet', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (124, N'MMTCB', N'A', N'Bước đầu tiên cần thực hiện để truyền dữ liệu theo ALOHA là', N'Chờ 1 thời gian ngẫu nhiên', N'Gửi tín hiệu tạo kết nối', N'Kiểm tra tình trạng đường truyền', N'Lập tức truyền dữ liệu', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (125, N'MMTCB', N'A', N'Cầu nối trong suốt hoạt động trong cấp nào', N'Data link', N'Physical', N'Network', N'Transport', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (126, N'MMTCB', N'A', N'Tốc độ của đường truyền T1 là:', N'2048 Mbps', N'1544 Mbps', N'155 Mbps', N'56 Kbps', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (127, N'MMTCB', N'A', N'Khi một dịch vụ trả lời ACK cho biết dữ liệu đã nhận được, đó là', N'Dịch vụ có xác nhận', N'Dịch vụ không xác nhận', N'Dịch vụ có kết nối', N'Dịch vụ không kết nối', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (128, N'MMTCB', N'A', N'Loại frame nào được sử dụng trong mạng Token-ring', N'Monitor', N'Token', N'Data', N'Token và Data', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (129, N'MMTCB', N'A', N'Thuật ngữ OSI là viết tắt bởi', N'Organization for Standard Institude', N'Organization for Standard Internet', N'Open Standard Institude', N'Open System Interconnection', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (130, N'MMTCB', N'A', N'Trong mạng Token-ting, khi 1 máy nhận được Token', N'Nó phải truyền cho máy kế trong vòng', N'Nó được quyền truyền dữ liệu', N'Nó được quyền giữ lại Token', N'Tất cả đều sai', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (131, N'MMTCB', N'A', N'Trong mạng cục bộ, để xác định 1 máy trong mạng ta dùng địa chỉ', N'MAC', N'Socket', N'Domain', N'Port', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (132, N'MMTCB', N'A', N'Thứ tự các cấp trong mô hình OSI', N'Application,Session,Transport,Physical', N'Application, Transport, Network, Physical', N'Application, Presentation,Session,Network,Transport,Data link,Physical', N'Application,Presentation,Session,Transport,Network,Data link,Physical', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (133, N'MMTCB', N'A', N'Cấp vật lý (physical) không quản lý', N'Mức điện áp', N'Địa chỉ vật lý', N'Mạch giao tiếp vật lý', N'Truyền các bit dữ liêu', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (134, N'MMTCB', N'A', N'TCP sử dụng loại dịch vụ', N'Có kết nối, độ tin cậy cao', N'Có kết nối, độ tin cậy thấp', N'Không kết nối, độ tin cậy cao', N'Không kết nối, độ tin cậy thấp', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (135, N'MMTCB', N'A', N'Địa chỉ IP bao gồm', N'Địa chỉ Network và địa chỉ host', N'Địa chỉ physical và địa chỉ logical', N'Địa chỉ cấp MAC và và địa chỉ LLC', N'Địa chỉ hardware và địa chỉ software', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (136, N'MMTCB', N'A', N'Chức năng cấp mạng (network) là', N'Mã hóa và định dạng dữ liệu', N'Tìm đường và kiểm soát tắc nghẽn', N'Truy cập môi trường mạng', N'Kiểm soát lỗi và kiểm soát lưu lượng', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (137, N'MMTCB', N'A', N'Mạng CSMA/CD làm gì', N'Truyền Token trên mạng hình sao', N'Truyền Token trên mạng dạng Bus', N'Chia packet ra thành từng frame nhỏ và truỵền đi trên mạng', N'Truy cập đường truyền và truyền lại dữ liệu nếu xảy ra đụng độ', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (138, N'MMTCB', N'A', N'Tiền thân của mạng Internet là', N'Intranet', N'Ethernet', N'Arpanet', N'Token-bus', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (139, N'MMTCB', N'A', N'Khi 1 cầu nối ( bridge) nhận được 1 framechưa biết thông tin về địa chỉ máy nhận, nó sẽ', N'Xóa bỏ frame này', N'Gửi trả lại máy gốc', N'Gửi đến mọi ngõ ra còn lại', N'Giảm thời gian sống của frame đi 1 đơn vị và gửi đến mọi ngõ ra còn lại', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (140, N'MMTCB', N'A', N'Chức năng của cấp Network là', N'Tìm đường', N'Mã hóa dữ liệu', N'Tạo địa chỉ vật lý', N'Kiểm soát lưu lượng', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (141, N'MMTCB', N'B', N'Sự khác nhau giữa địa chỉ cấp Data link và Network là', N'Địa chỉ cấp Data link có kích thước nhỏ hơn địa chỉ cấp Network', N'Địa chỉ cấp Data link là đia chỉ Physic, địa chỉ cấp Network là địa chỉ Logic', N'Địa chỉ cấp Data Link là địa chỉ Logic, địa chỉ câp Network là địa chỉ Physic', N'Địa chỉ Data link cấu hình theo mạng, địa chỉ cấp Network xác định theo IEEE', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (142, N'MMTCB', N'B', N'Kỹ thuật nào không sử dụng được trong việc kiểm soát lưu lượng(flow control)', N'Ack', N'Buffer', N'Windowing', N'Multiplexing', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (143, N'MMTCB', N'B', N'Cấp cao nhất trong mô hình mạng OSI là', N'Transport', N'Physical', N'Network', N'Application', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (144, N'MMTCB', N'B', N'Tại sao mạng máy tình dùng mô hình phân cấp', N'Để mọi người sử dụng cùng 1 ứng dụng mạng', N'Để phân biệt giữa chuẩn mạng và ứng dụng mạng', N'Giảm độ phức tạp trong việc thiết kế và cài đặt', N'Các cấp khác không cần sửa đổi khi thay đổi 1 cấp mạng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (145, N'MMTCB', N'B', N'Router làm gì để giảm tăc nghẽn (congestion)', N'Nén dữ liệu', N'Lọc bớt dữ liệu theo địa chỉ vật lý', N'Lọc bớt dữ liệu theo địa chỉ logic', N'Cấm truyền dữ liệu broadcasr', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (146, N'MMTCB', N'B', N'Byte đầu của 1 IP có giá trị 222, địa chỉ này thuộc lớp địa chỉ nào', N'Lớp A', N'Lớp B', N'Lớp C', N'Lớp D', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (147, N'MMTCB', N'B', N'Chọn câu đúng đối với switch của mạng LAN', N'Là 1 cầu nối tốc độ cao', N'Nhận data từ 1 cổng và xuất ra mọi cổng còn lại', N'Nhận data từ 1 cổng và xuất ra  cổng đích tùy theo địa chỉ cấp IP', N'Nhận data từ 1 cổng và xuất ra 1 cổng đích tùy theo địa chỉ cấp MAC', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (148, N'MMTCB', N'B', N'Thuật ngữ nào cho biết loại mạng chỉ truyền được  chiều tại 1 thời điểm', N'Half duplex', N'Full duplex', N'Simplex', N'Monoplex', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (149, N'MMTCB', N'B', N'Protocol nghĩa là', N'Tập các chuẩn truyền dữ liệu', N'Tập các cấp mạng trong mô hình OSI', N'Tập các chức năng của từng cấp trong mạng', N'Tập các qui tắc và cấu trúc dữ liệu để truyền thông giữa các cấp mạng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (150, N'MMTCB', N'B', N'Truyền dữ liệu theo kiểu có kết nối không cần thực hiện việc', N'Hủy kết nối', N'Tạo kết nối', N'Truyền dữ liệu', N'Tìm đường cho từng gói tin', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (151, N'MMTCB', N'B', N'Byte đầu của địa chỉ IP lớp E nằm trong phạm vi', N'128 - 191', N'192 - 232 ', N'224 - 239 ', N'240 - 247', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (152, N'MMTCB', N'B', N'Khi truyền đi chuỗi "VIET NAM" nhưng nhận được chuỗi"MAN TEIV ". Cần phải hiệu chỉnh các protocol trong cấp nào để truyền chính xác', N'Session', N'Transport', N'Application', N'Presentation', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (153, N'MMTCB', N'B', N'Tên cáp UTP dùng torng mạng Fast Ethernet là', N'100BaseF', N'100Base2', N'100BaseT', N'100Base5', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (154, N'MMTCB', N'B', N'Tốc độ truyền của mạng Ethernet là', N'1 Mbps', N'10 Mbps', N'100 Mbps', N'1000 Mbps', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (155, N'MMTCB', N'B', N'Dịch vụ mạng thường được phân chia thành', N'Dịch vụ không kết nối và có kết nối', N'Dich vụ có xác nhận và không xác nhận', N'Dịch vụ có độ tin cậy cao và có độ tin cậy thấp', N'Tất cả đều đúng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (156, N'MMTCB', N'B', N'Đơn vị truyền dữ liệu trong cấp Network gọi là', N'Bit', N'Frame', N'Packet', N'Segment', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (157, N'MMTCB', N'B', N'Protocol nào trong mạng TCP/IP chuyển đổi địa chỉ vật lý thành địa chỉ IP', N'IP', N'ARP', N'ICMP', N'RARP', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (158, N'MMTCB', N'B', N'Đầu nới AUI dùng cho loại cáp nào?', N'Đồng trục', N'Xoắn đôi', N'Cáp quang', N'Tất cả đều đúng', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (159, N'MMTCB', N'B', N'Subnet mask chuẩn của địa chỉ IP lớp B là', N'255.0.0.0', N'255.255.0.0', N'255.255.255.0', N'255.255.255.255', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (160, N'MMTCB', N'B', N'Lý do nào khiến người ta chọn protocol TCP hơn là UDP', N'Không ACK', N'Dễ sử dụng', N'Độ tin cậy', N'Không kết nối', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (161, N'MMTCB', N'B', N'Nhược điểm của dịch vụ có kết nối so với không kết nối', N'Độ tin cậy', N'Thứ tự nhận dữ liệu không đúng', N'Đường truyền không thay đổi', N'Đường truyền thay đổi liên tục', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (162, N'MMTCB', N'B', N'Cấp Data link không thực hiện chức năng nào?', N'Kiểm soát lỗi', N'Địa chỉ vật lý', N'Kiểm soát lưu lượng', N'Thiết lập kết nối', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (163, N'MMTCB', N'B', N'Cầu nối (bridge)dựa vào thông tin nào để truyền tiếp hoặc hủy bỏ 1 frame', N'Điạ chỉ nguồn', N'Địa chỉ đích', N'Địa chỉ mạng', N'Tất cả đều đúng', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (164, N'MMTCB', N'B', N'Chuẩn nào sử dụng trong cấp presentation?', N'UTP và STP', N'SMTP và HTTP', N'ASCII và EBCDIC', N'TCP và UDP', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (165, N'MMTCB', N'B', N'Đơn vị truyền dữ liệu giữa các cấp trong mạng theo thứ tự', N'bit,frame,packet,data', N'bit,packet,frame,data', N'data,frame,packet,bit', N'data,bit,packet,frame', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (166, N'MMTCB', N'B', N'Mạng Ethernet do cơ quan nào phát minh', N'ANSI', N'ISO', N'IEEE', N'XEROX', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (167, N'MMTCB', N'B', N'Chiều dài loại cáp nào tối đa 100 m? ', N'10Base2', N'10Base5', N'10BaseT', N'10BaseF', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (168, N'MMTCB', N'B', N'Địa chỉ IP 100.150.200.250 có nghĩa là', N'Địa chỉ network 100, địa chỉ host 150.200.250', N'Địa chỉ network 100.150, địa chỉ host 200.250', N'Địa chỉ network 100.150.200, địa chỉ host 250', N'Tất cả đều sai', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (169, N'MMTCB', N'B', N'Switching hun khác hub thông thường ở chỗ nó làm', N'Giảm collision trên mạng', N'Tăng collision trên mạng', N'Giảm congestion trên mạng', N'Tăng congestion trên mạng', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (170, N'MMTCB', N'B', N'Loại cáp nào chỉ truyền dữ liệu 1 chiều', N'Cáp quang', N'Xoắn đôi', N'Đồng trục', N'Tất cả đều đúng', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (171, N'MMTCB', N'B', N'Thiết bị Modem dùng để', N'Tách và ghép tín hiệu', N'Nén và gải nén tín hiệu', N'Mã hóa và giải mã tín hiệu', N'Điều chế và giải điều chế tín hiệu', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (172, N'MMTCB', N'B', N'Việc cấp phát kênh truyền áp dụng cho loại mạng', N'Peer to peer', N'Point to point', N'Broadcast', N'Multiple Access', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (173, N'MMTCB', N'B', N'Mạng nào dùng phương pháp mã hóa Manchester Encoding', N'Ethernet', N'Token-ring', N'Token-bus', N'Tất cả đều đúng ', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (174, N'MMTCB', N'B', N'Phương pháp tìm đường có tính đến thời gian trễ', N'Tìm đường theo chiều sâu', N'Tìm đường theo chiều rộng', N'Tìm đường theo vector khoảng cách', N'Tìm đường theo trạng thái đường truyền', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (175, N'MMTCB', N'B', N'Chuẩn mạng nào khi có dữ liệu không truyền ngay mà chờ 1 thời gian ngẫu nhiên?', N'1-presistent CSMA', N'p-presistent CSMA', N'Non-presistent CSMA', N'CSMA/CD', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (176, N'MMTCB', N'B', N'Phương pháp chèn bit (bit stuffing) được dùng để', N'Phân biệt đầu và cuối frame', N'Bổ sung cho đủ kích thước frame tối thiểu', N'Phân cách nhiều bit 0 bằng bit 1', N'Biến đổi dạng dữ liệu 8 bit ra 16 bit', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (177, N'MMTCB', N'B', N'Để chống nhiễu trên đường truyền tốt nhất, nên dùng loại cáp:', N'Xoắn đôi', N'Đồng trục', N'Cáp quang', N'Mạng không dây', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (178, N'MMTCB', N'B', N'Phần mềm gửi/nhận thư điện tử thuộc cấp nào trong mô hình OSI', N'Data link', N'Network', N'Application', N'Presentation', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (179, N'MMTCB', N'B', N'Chức năng của thiết bị Hub trong mạng LAN', N'Mã hóa tín hiệu', N'Triệt tiêu tín hiệu', N'Phân chia tín hiệu', N'Điều chế tín hiếu', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (180, N'MMTCB', N'B', N'Switch là thiết bị mạng làm việc tương tự như', N'Hub', N'Repeater', N'Router', N'Bridge', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (181, N'MMTCB', N'C', N'Thiết bị nào làm việc trong cấp Network', N'Bridge', N'Repeater', N'Router', N'Gateway', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (182, N'MMTCB', N'C', N'Thiết bị nào cần có bộ nhớ làm buffer', N'Hub', N'Switch', N'Repeater', N'Router', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (183, N'MMTCB', N'C', N'Luật 5-4-3 cho phép tối đa', N'5 segment trong 1 mạng', N'5 repeater trong 1 mạng', N'5 máy tính trong 1 mạng', N'5 máy tính trong 1 segment', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (184, N'MMTCB', N'C', N'Thiết bị nào có thể thêm vào mạng LAN mà không sợ vi phạm luật 5-4-3', N'Router', N'Repeater', N'Máy tính', N'Tất cả đều đúng', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (185, N'MMTCB', N'C', N'Thêm thiết bị nào vào mạng có thể qui phạm luật 5-4-3', N'Router', N'Repeater', N'Bridge', N'Tất cả đều đúng', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (186, N'MMTCB', N'C', N'Mạng nào cóxảy ra xung đột (collision) trên đường truyền', N'Ethernet', N'Token-ring', N'Token-bus', N'Tất cả đều sai', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (187, N'MMTCB', N'C', N'Từ "Broad" trong tên cáp 10Broad36 viết tắt bởi', N'Broadcast', N'Broadbase', N'Broadband', N'Broadway', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (188, N'MMTCB', N'C', N'Protocol nào sử dụng trong cấp Network', N'IP', N'TCP', N'UDP', N'FTP', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (189, N'MMTCB', N'C', N'Protocol nào torng cấp Transport cung cấp dịch vụ không kết nối', N'IP', N'TCP', N'UDP', N'FTP', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (190, N'MMTCB', N'C', N'Protocol nào trong cấp Transport dùng kiểu dịch vụ có kết nối?', N'IP', N'TCP', N'UDP', N'FTP', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (191, N'MMTCB', N'C', N'Địa chỉ IP được chia làm mấy lớp', N'2', N'3', N'4', N'5', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (192, N'MMTCB', N'C', N'Chức năng nào không phải của cấp Network', N'Tìm đường', N'Địa chỉ logic', N'Kiểm soát tắc nghẽn', N'Chất lượng dịch vụ', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (193, N'MMTCB', N'C', N'Phương pháp chèn kí tự dùng để', N'Phân cách các frame', N'Phân biệt dữ liệu và ký tự điều khiển', N'Nhận diện đầu cuối frame', N'Bổ sung cho đủ kich thước frame tối thiểu', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (194, N'MMTCB', N'C', N'Kỹ thuật truyền nào mã hóa trực tiếp dữ liệu ra đường truyền không cần sóng mang', N'Broadcast', N'Digital', N'Baseband', N'Broadband', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (195, N'MMTCB', N'C', N'Sóng viba sử dụng băng tần', N'SHF', N'LF và MF', N'UHF và VHF', N'Tất cả đều đúng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (196, N'MMTCB', N'C', N'Sóng viba bị ảnh hưởng bời', N'Trời mưa', N'Sấm chớp', N'Giông bão', N'Ánh sáng mặt trời', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (197, N'MMTCB', N'C', N'Đường dây trung kế trong mạng điện thoại sử dụng', N'Tín hiệu số', N'Kỹ thuật dồn kênh', N'Cáp quang, cáp đồng và viba', N'Tất cả đêu đúng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (198, N'MMTCB', N'C', N'Cáp quang dùng công nghệ dồn kênh nào', N'TDM', N'FDM', N'WDM', N'CDMA', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (199, N'MMTCB', N'C', N'Nhược điểm của phương pháp chèn ký tự', N'Giảm tốc độ đường truyền', N'Tăng phí tổn đường truyền', N'Mất đồng bộ frame', N'Không nhận diện được frame', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (200, N'MMTCB', N'C', N'Mất đồng bộ frame xảy ra đối với phương pháp', N'Chèn bit', N'Đếm ký tự', N'Chèn ký tự', N'Tất cả đều đúng', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (201, N'MMTCB', N'C', N'Mạng nào dùng công nghệ Token-bus', N'FDDI', N'CDDI', N'Fast Ethernet', N'100VG-AnyLAN', N'D', N'TH123   ')
GO
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (202, N'MMTCB', N'C', N'Thiết bị nào tự trao đổi thông tin lẫn nhau để quản lý mạng', N'Hub', N'Bridge', N'Router', N'Repeater', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (203, N'MMTCB', N'C', N'Tần số sóng điện từ dùng trong mạng vô tuyến sắp theo thứ tự tăng dần', N'Radio,viba,hồng ngoại', N'Radio,hồng ngoại,viba', N'Hồng ngoại,viba,radio', N'Viba,radio,hồng ngoại', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (204, N'MMTCB', N'C', N'Đường dây hạ kế (local loop) trong mạch điện thoại dùng tín hiệu', N'Digital', N'Analog', N'Manchester', N'T1 hoặc E1', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (205, N'MMTCB', N'C', N'Để tránh nhận trùng dữ liệu người ta dùng phương pháp', N'Đánh số thứ tự các frame', N'Quy định kích thước frame cố định', N'Chờ nhận ACK mới gửi frame kế tiếp', N'So sánh và loại bỏ các frame giống nhau', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (206, N'MMTCB', N'C', N'Cơ chế Timer dùng để', N'Đo thời gian chơ frame', N'Tránh tình trạng mất frame', N'Chọn thời điểm truyền frame', N'Kiểm soát thòi gian truyền frame', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (207, N'MMTCB', N'C', N'Cấp nào trong mô hình OSI quan tâm tới topology mạng', N'Transport', N'Network', N'Data link', N'Physical', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (208, N'MMTCB', N'C', N'Loại mạng nào sử dụng trên WAN', N'Ethernet và Token-bus', N'ISDN và Frame relay', N'Token-ring và FDDI', N'SDLC và HDLC', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (209, N'MMTCB', N'C', N'Repeater nhiều port là tên gọi của', N'Hub', N'Host', N'Bridge', N'Router', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (210, N'MMTCB', N'C', N'Đơn vị đo tốc độ đường truyền', N'bps(bit per second)', N'Bps(Byte per second)', N'mps(meter per second)', N'hertz (ccle per second)', N'A', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (211, N'MMTCB', N'C', N'Repeater dùng để', N'Lọc bớt dữ liệu trên mạng', N'Tăng tốc độ lưu thông trên mạng', N'Tăng thời gian trễ trên mạng', N'Mở rộng chiều dài đường truyền', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (212, N'MMTCB', N'C', N'Cáp đồng trục (coaxial)', N'Có 4 đôi dây', N'Không cần repeater', N'Truyền tín hiệu ánh sáng', N'Chống nhiễu tốt hơn UTP', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (213, N'MMTCB', N'C', N'Câp Data link ', N'Truyền dữ liệu cho các cấp khác trong mạng', N'Cung cấp dịch vụ cho chương trình ứng dụng', N'Nhận tín hiệu yếu,lọc,khuếch đại và phát lại trên mạng', N'Bảo đảm đường truyền dữ liệu tin cậy giữa 2 đầu đường truyền', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (214, N'MMTCB', N'C', N'Địa chỉ IP còn gọi là', N'Địa chĩ vật lý', N'Địa chỉ luận lý', N'Địa chỉ thập phân', N'Địa chỉ thập lục phân', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (215, N'MMTCB', N'C', N'Cấp Presentation', N'Thiết lập, quản lý và kết thúc các ứng dụng', N'Hướng dẫn cách mô tả hình ảnh, âm thanh, tiếng nói', N'Cung cấp dịch vụ truyền dữ liệu từ nguồn đến đích', N'Hỗ trợ việc truyền thông trong các ứng dụng như web, mail...', N'C', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (216, N'MMTCB', N'C', N'Tập các luật để định dạng và truyền dữ liệu gọi là', N'Qui luật (rule)', N'Nghi thức (protocol)', N'Tiêu chuẩn (standard)', N'Mô hình (model)', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (217, N'MMTCB', N'C', N'Tại sao cần có tiêu chuẩn về mang', N'Định hướng phát triển phần cứng và phần mềm mới', N'LAN,MAN và WAN sử dụng các thiết bị khác nhau', N'Kết nối mạng giữa các quôc gia khác nhau', N'Tương thích về công nghệ để truyền thông được lẫn nhau', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (218, N'MMTCB', N'C', N'Dữ liệu truyền trên mạng bằng', N'Mã ASCII', N'Số nhị phân', N'Không và một', N'Xung điện áp', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (219, N'MMTCB', N'C', N'Mạng CSMA/CD', N'Kiểm tra để bảo đảm dữ liệu truyền đến đích', N'Kiểm tra đường truyền nếu rảnh mới truyền dữ liệu', N'Chờ 1 thời gian ngẫu nhiên rồi truyền  dữ liệu kế tiếp', N'Tất cả đều đúng', N'B', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (220, N'MMTCB', N'C', N'Địa chỉ MAC ', N'Gồm có 32 bit', N'Còn gọi là địa chỉ logic', N'Nằm trong cấp Network', N'Dùng để phân biệt các máy trong mạng', N'D', N'TH123   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (222, N'AVCB ', N'A', N'If we have some chances', N'HAD', N'HAVE', N'HAS', N'HAD HAD', N'A', N'TH101   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (224, N'AVCB ', N'A', N'Something will change', N'Had', N'Have', N'Has', N'Had had', N'B', N'TH111   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (225, N'AVCB ', N'A', N'Something has different choice', N'Had', N'Have', N'Has', N'Had had', N'A', N'TH101   ')
INSERT [dbo].[BODE] ([CAUHOI], [MAMH], [TRINHDO], [NOIDUNG], [A], [B], [C], [D], [DAP_AN], [MAGV]) VALUES (226, N'LTW  ', N'A', N'Lập trình không khó', N'J', N'K', N'D', N'P', N'A', N'TH101   ')
SET IDENTITY_INSERT [dbo].[BODE] OFF
GO
INSERT [dbo].[COSO] ([MACS], [TENCS], [DIACHI]) VALUES (N'CS1', N'Cơ sở 1 ', N'11 Nguyễn Đình Chiểu, Phường Đakao, Quận 1, TP. HCM')
INSERT [dbo].[COSO] ([MACS], [TENCS], [DIACHI]) VALUES (N'CS2', N'Cơ sở 2', N'Số 9 Man Thiện , quận 9, TP. HCM')
GO
SET IDENTITY_INSERT [dbo].[django_content_type] ON 

INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (1, N'admin', N'logentry')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (3, N'auth', N'group')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (2, N'auth', N'permission')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (4, N'auth', N'user')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (7, N'base', N'baithi')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (8, N'base', N'bode')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (9, N'base', N'coso')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (69, N'base', N'ctbaithi')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (10, N'base', N'giaovien')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (70, N'base', N'giaoviendangky')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (12, N'base', N'khoa')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (13, N'base', N'lop')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (11, N'base', N'monhoc')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (14, N'base', N'msdynamicsnapshotjobs')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (15, N'base', N'msdynamicsnapshotviews')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (16, N'base', N'msmergeagentparameters')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (17, N'base', N'msmergealtsyncpartners')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (18, N'base', N'msmergearticlehistory')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (19, N'base', N'msmergeconflictsinfo')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (20, N'base', N'msmergeconflictttncs1baithi')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (21, N'base', N'msmergeconflictttncs1bode')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (22, N'base', N'msmergeconflictttncs1coso')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (23, N'base', N'msmergeconflictttncs1ctbaithi')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (24, N'base', N'msmergeconflictttncs1giaovien')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (25, N'base', N'msmergeconflictttncs1giaoviendangky')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (26, N'base', N'msmergeconflictttncs1khoa')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (27, N'base', N'msmergeconflictttncs1lop')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (28, N'base', N'msmergeconflictttncs1monhoc')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (29, N'base', N'msmergeconflictttncs1sinhvien')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (30, N'base', N'msmergeconflictttncs2baithi')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (31, N'base', N'msmergeconflictttncs2bode')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (32, N'base', N'msmergeconflictttncs2coso')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (33, N'base', N'msmergeconflictttncs2ctbaithi')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (34, N'base', N'msmergeconflictttncs2giaovien')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (35, N'base', N'msmergeconflictttncs2giaoviendangky')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (36, N'base', N'msmergeconflictttncs2khoa')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (37, N'base', N'msmergeconflictttncs2lop')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (38, N'base', N'msmergeconflictttncs2monhoc')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (39, N'base', N'msmergeconflictttncs2sinhvien')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (40, N'base', N'msmergeconflictttntclop')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (41, N'base', N'msmergeconflictttntcsinhvien')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (42, N'base', N'msmergecontents')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (43, N'base', N'msmergecurrentpartitionmappings')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (71, N'base', N'msmergedynamicsnapshots')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (45, N'base', N'msmergeerrorlineage')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (46, N'base', N'msmergegenerationpartitionmappings')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (47, N'base', N'msmergegenhistory')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (48, N'base', N'msmergehistory')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (49, N'base', N'msmergeidentityrange')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (50, N'base', N'msmergelogfiles')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (51, N'base', N'msmergemetadataactionrequest')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (44, N'base', N'msmergepartitiongroups')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (52, N'base', N'msmergepastpartitionmappings')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (53, N'base', N'msmergereplinfo')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (54, N'base', N'msmergesessions')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (55, N'base', N'msmergesettingshistory')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (56, N'base', N'msmergesupportabilitysettings')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (57, N'base', N'msmergetombstone')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (58, N'base', N'msreplerrors')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (59, N'base', N'sinhvien')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (60, N'base', N'sysdiagrams')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (61, N'base', N'sysmergearticles')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (62, N'base', N'sysmergepartitioninfo')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (63, N'base', N'sysmergepublications')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (64, N'base', N'sysmergeschemaarticles')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (65, N'base', N'sysmergeschemachange')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (66, N'base', N'sysmergesubscriptions')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (67, N'base', N'sysmergesubsetfilters')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (68, N'base', N'sysreplservers')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (5, N'contenttypes', N'contenttype')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (6, N'sessions', N'session')
SET IDENTITY_INSERT [dbo].[django_content_type] OFF
GO
SET IDENTITY_INSERT [dbo].[django_migrations] ON 

INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (1, N'contenttypes', N'0001_initial', CAST(N'2024-06-24T21:05:53.8034570+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (2, N'auth', N'0001_initial', CAST(N'2024-06-24T21:05:54.7428820+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (3, N'admin', N'0001_initial', CAST(N'2024-06-24T21:05:54.7969910+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (4, N'admin', N'0002_logentry_remove_auto_add', CAST(N'2024-06-24T21:05:54.8071120+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (5, N'admin', N'0003_logentry_add_action_flag_choices', CAST(N'2024-06-24T21:05:54.8156210+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (6, N'contenttypes', N'0002_remove_content_type_name', CAST(N'2024-06-24T21:05:55.6459860+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (7, N'auth', N'0002_alter_permission_name_max_length', CAST(N'2024-06-24T21:05:55.6602560+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (8, N'auth', N'0003_alter_user_email_max_length', CAST(N'2024-06-24T21:05:55.6735230+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (9, N'auth', N'0004_alter_user_username_opts', CAST(N'2024-06-24T21:05:55.6829730+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (10, N'auth', N'0005_alter_user_last_login_null', CAST(N'2024-06-24T21:05:56.2983500+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (11, N'auth', N'0006_require_contenttypes_0002', CAST(N'2024-06-24T21:05:56.3447020+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (12, N'auth', N'0007_alter_validators_add_error_messages', CAST(N'2024-06-24T21:05:56.3534110+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (13, N'auth', N'0008_alter_user_username_max_length', CAST(N'2024-06-24T21:05:56.4443650+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (14, N'auth', N'0009_alter_user_last_name_max_length', CAST(N'2024-06-24T21:05:56.4568950+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (15, N'auth', N'0010_alter_group_name_max_length', CAST(N'2024-06-24T21:05:57.0812670+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (16, N'auth', N'0011_update_proxy_permissions', CAST(N'2024-06-24T21:05:57.0900910+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (17, N'auth', N'0012_alter_user_first_name_max_length', CAST(N'2024-06-24T21:05:57.1029780+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (18, N'base', N'0001_initial', CAST(N'2024-06-24T21:05:57.1605080+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (19, N'sessions', N'0001_initial', CAST(N'2024-06-24T21:05:57.2023140+00:00' AS DateTimeOffset))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (20, N'base', N'0002_delete_msdynamicsnapshotjobs_and_more', CAST(N'2024-06-25T22:57:11.1174950+00:00' AS DateTimeOffset))
SET IDENTITY_INSERT [dbo].[django_migrations] OFF
GO
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'zmtfsihxlbxyl1gpxmjdnnqo5j5196ii', N'.eJxtUE1PhDAQ_StNz2hadi96M0qE7C6JC2xixDQVykeEQtpSDxv-u9NFxcPOZaZv3rx5nTPWrWxsKyRrZTXg-zdMCEUusIf3-URIwdEJMiV-jFAaXiASh9BOQ7JFa-B3D2uhrFA_WvAqBlkybYFcTEoJadjCgOYhCvL8kCQv-yQ4noIjof9Yv2bSkF7wXRRk6OnhEQxEQex2q2mQtVv5wbVgRvRjx40A3Z63ki3t28b03ap6M2m3-Yxdlrx37NE2QBi51l-DKgHwN3eEbPC8erky9Vmaq1MeVkPnCGaxByq1ZV2rjROAz_jutq7ueW2B9wd52Ah5gdzRKa8yFD9nr_lERbGN0c4Vlb_cH7p4nudv-n6H9A:1sOvif:57LJR_W6N205Kb8Z_aM8GJPS1WsUPCZe5hbuwemJnFs', CAST(N'2024-07-17T08:52:05.4377990+00:00' AS DateTimeOffset))
GO
INSERT [dbo].[GIAOVIEN] ([MAGV], [HO], [TEN], [DIACHI], [MAKH]) VALUES (N'TH101   ', N'KIEU DAC', N'THIEN', N'9,3A, Q.BINH TAN', N'CNTT    ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HO], [TEN], [DIACHI], [MAKH]) VALUES (N'TH111   ', N'TRẦN ANH', N'LONG', N'Tăng Nhơn Phú A', N'NG      ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HO], [TEN], [DIACHI], [MAKH]) VALUES (N'TH113   ', N'NGUYỄN ANH', N'HÙNG', N'Quận 12', N'KT      ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HO], [TEN], [DIACHI], [MAKH]) VALUES (N'TH121   ', N'LƯU NGUYỄN KỲ', N'THƯ', N'Quận 1', N'CNTT    ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HO], [TEN], [DIACHI], [MAKH]) VALUES (N'TH123   ', N'PHAN VAN ', N'HAI', N'15/72 LE VAN THO F8 GO VAP', N'CNTT    ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HO], [TEN], [DIACHI], [MAKH]) VALUES (N'TH234   ', N'DAO VAN ', N'TUYET', N'14/7 BUI DINH TUY TAN BINH', N'CNTT    ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HO], [TEN], [DIACHI], [MAKH]) VALUES (N'TH657   ', N'PHAN HONG', N'NGOC', N'HIEP PHU, QUAN 9, THU DUC', N'VT      ')
GO
INSERT [dbo].[GIAOVIEN_DANGKY] ([MAGV], [MAMH], [MALOP], [TRINHDO], [NGAYTHI], [LAN], [SOCAUTHI], [THOIGIAN]) VALUES (N'TH111   ', N'AVCB ', N'D18CQCN01      ', N'A', CAST(N'2024-06-29T10:25:00.000' AS DateTime), 1, 15, 15)
INSERT [dbo].[GIAOVIEN_DANGKY] ([MAGV], [MAMH], [MALOP], [TRINHDO], [NGAYTHI], [LAN], [SOCAUTHI], [THOIGIAN]) VALUES (N'TH234   ', N'AVCB ', N'TH04           ', N'A', CAST(N'2024-07-12T08:30:00.000' AS DateTime), 1, 12, 30)
INSERT [dbo].[GIAOVIEN_DANGKY] ([MAGV], [MAMH], [MALOP], [TRINHDO], [NGAYTHI], [LAN], [SOCAUTHI], [THOIGIAN]) VALUES (N'TH101   ', N'AVCB ', N'TH04           ', N'A', CAST(N'2024-07-02T15:23:00.000' AS DateTime), 2, 10, 1)
INSERT [dbo].[GIAOVIEN_DANGKY] ([MAGV], [MAMH], [MALOP], [TRINHDO], [NGAYTHI], [LAN], [SOCAUTHI], [THOIGIAN]) VALUES (N'TH101   ', N'AVCB ', N'VT04           ', N'A', CAST(N'2024-06-30T00:00:00.000' AS DateTime), 1, 12, 15)
INSERT [dbo].[GIAOVIEN_DANGKY] ([MAGV], [MAMH], [MALOP], [TRINHDO], [NGAYTHI], [LAN], [SOCAUTHI], [THOIGIAN]) VALUES (N'TH101   ', N'CSDL ', N'TH04           ', N'C', CAST(N'2023-12-12T08:00:00.000' AS DateTime), 1, 12, 30)
INSERT [dbo].[GIAOVIEN_DANGKY] ([MAGV], [MAMH], [MALOP], [TRINHDO], [NGAYTHI], [LAN], [SOCAUTHI], [THOIGIAN]) VALUES (N'TH101   ', N'CSDL ', N'VT04           ', N'C', CAST(N'2024-12-12T13:00:00.000' AS DateTime), 1, 12, 30)
INSERT [dbo].[GIAOVIEN_DANGKY] ([MAGV], [MAMH], [MALOP], [TRINHDO], [NGAYTHI], [LAN], [SOCAUTHI], [THOIGIAN]) VALUES (N'TH101   ', N'DSTT ', N'TH04           ', N'A', CAST(N'2024-07-16T00:00:00.000' AS DateTime), 1, 12, 30)
GO
INSERT [dbo].[KHOA] ([MAKH], [TENKH], [MACS]) VALUES (N'CNTC    ', N'Công Nghệ Tài Chính', N'CS2')
INSERT [dbo].[KHOA] ([MAKH], [TENKH], [MACS]) VALUES (N'CNTT    ', N'Công Nghệ Thông Tin 2', N'CS1')
INSERT [dbo].[KHOA] ([MAKH], [TENKH], [MACS]) VALUES (N'DT      ', N'Điện Tử', N'CS2')
INSERT [dbo].[KHOA] ([MAKH], [TENKH], [MACS]) VALUES (N'KT      ', N'Kinh Tế', N'CS1')
INSERT [dbo].[KHOA] ([MAKH], [TENKH], [MACS]) VALUES (N'NG      ', N'Ngoại Giao', N'CS1')
INSERT [dbo].[KHOA] ([MAKH], [TENKH], [MACS]) VALUES (N'VT      ', N'Viễn Thông', N'CS2')
GO
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'D18CQCN01      ', N'Cntt Khóa 2018 - 1', N'CNTT    ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'D19CQKTDN      ', N'Kế Toán Doanh Nghiệp 1', N'KT      ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'D21CQCN02N     ', N'Công Nghệ Thông Tin 2 - 2021', N'CNTT    ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'D21CQVT01      ', N'Viễn Thông 1 Khóa 2021', N'VT      ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'TH04           ', N'TIN HOC 2004', N'CNTT    ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'TH05           ', N'TIN HOC 2005', N'CNTT    ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'TH06           ', N'TIN HOC 2006', N'CNTT    ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'TH07           ', N'TIN HOC 2007', N'CNTT    ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'TH08           ', N'TIN HOC 2008', N'CNTT    ')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH]) VALUES (N'VT04           ', N'VIỄN THÔNG 2004', N'VT      ')
GO
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'AVCB ', N'ANH VĂN CĂN BẢN')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'CTDL ', N'CẤU TRÚC DỮ LIỆU VÀ GIẢI THUẬT')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'CTPT ', N'CẤU TRÚC PHÂN TÁN')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'CSDL ', N'CƠ SỞ DỮ LIỆU')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'CNTC ', N'CÔNG NGHỆ TÀI CHÍNH')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'CNTT ', N'CÔNG NGHỆ TRUYỀN THÔNG')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'DSTT ', N'ĐẠI SỐ TUYẾN TÍNH')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'HTTT ', N'HỆ THỐNG THÔNG TIN')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'KHMT ', N'KHOA HỌC')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'LTW  ', N'LẬP TRÌNH WEB')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'MMTCB', N'MẠNG MÁY TÍNH CĂN BẢN')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'MMT  ', N'MẠNG MÁY TÍNH VÀ TRUYỀN THÔNG')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'TK   ', N'THỐNG KÊ')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'TTCS ', N'THỰC TẬP CƠ SỞ')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'TCC  ', N'TOÁN CHÍNH TRỊ')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'TRR  ', N'TOÁN RỜI RẠC')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'XSTK ', N'XÁC SUẤT THỐNG KÊ')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH]) VALUES (N'XLA  ', N'XỬ LÝ ẢNH')
GO
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'001     ', N'LÊ VĂN ', N'THÀNH', CAST(N'1985-03-06' AS Date), N'23/5 PHUNG KHAC KHOAN F3 Q3', N'TH04           ', N'123456')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'002     ', N'DAO TRONG', N'KHAI', CAST(N'1979-08-19' AS Date), N'15/72 LE VAN THO F8 GOVAP', N'TH04           ', N'112233')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'003     ', N'CAO TUAN', N'KHA', CAST(N'1985-12-06' AS Date), N'12/5 LE QUANG DINH F5 GO VAP', N'TH04           ', N'321321')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'004     ', N'HA THANH ', N'BINH', CAST(N'1984-03-24' AS Date), N'23/4 HOANG HOA THAM', N'TH04           ', N'239003')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'005     ', N'NGUYEN THÚY ', N'VÂN', CAST(N'1987-11-06' AS Date), N'7 HUYNH THUC KHANG', N'TH05           ', N'123123')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'006     ', N'NGUYEN NGOC ', N'YEN', CAST(N'1980-11-23' AS Date), N'3/5 AN DUONG VUONG', N'TH05           ', N'123456789')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'007     ', N'NGUYEN THUY ', N'DUNG', CAST(N'1988-05-23' AS Date), N'8 HUYNH VAN BANH f1 q binh thanh', N'TH05           ', N'mie2392003')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'008     ', N'TRINH', N'PHONG', CAST(N'1985-12-10' AS Date), N'', N'TH06           ', N'123456')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'009     ', N'TRAN THANH', N'HUNG', CAST(N'1985-03-28' AS Date), N'', N'TH05           ', N'2390023')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'011     ', N'PHAN HONG', N'NGOC', CAST(N'1986-01-17' AS Date), N'PHAN VAN HAN BINH THANH', N'VT04           ', N'bacha123456789')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'012     ', N'TRAN MINH', N'HUNG', CAST(N'2003-12-12' AS Date), NULL, N'VT04           ', N'123132')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'013     ', N'NGUYEN MINH', N'HOANG', CAST(N'2003-12-12' AS Date), N'QUAN 9', N'VT04           ', NULL)
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'014     ', N'TRẦN VĂN', N'HƯNG', CAST(N'2003-12-12' AS Date), N'Tăng Nhơn Phú A', N'TH04           ', NULL)
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [NGAYSINH], [DIACHI], [MALOP], [PASSWORD]) VALUES (N'015     ', N'NGUYỄN THỊ HUYỀN', N'MY', CAST(N'2003-10-18' AS Date), N'Tăng Nhơn Phú A, Quận 9', N'D18CQCN01      ', NULL)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [auth_group_name_a6ea08ec_uniq]    Script Date: 05/07/2024 4:41:18 pm ******/
ALTER TABLE [dbo].[auth_group] ADD  CONSTRAINT [auth_group_name_a6ea08ec_uniq] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_group_id_b120cbf9]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [auth_group_permissions_group_id_b120cbf9] ON [dbo].[auth_group_permissions]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_group_id_permission_id_0cd325b0_uniq]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [auth_group_permissions_group_id_permission_id_0cd325b0_uniq] ON [dbo].[auth_group_permissions]
(
	[group_id] ASC,
	[permission_id] ASC
)
WHERE ([group_id] IS NOT NULL AND [permission_id] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_permission_id_84c5c92e]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [auth_group_permissions_permission_id_84c5c92e] ON [dbo].[auth_group_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_permission_content_type_id_2f476e4b]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [auth_permission_content_type_id_2f476e4b] ON [dbo].[auth_permission]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [auth_permission_content_type_id_codename_01ab375a_uniq]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [auth_permission_content_type_id_codename_01ab375a_uniq] ON [dbo].[auth_permission]
(
	[content_type_id] ASC,
	[codename] ASC
)
WHERE ([content_type_id] IS NOT NULL AND [codename] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [auth_user_username_6821ab7c_uniq]    Script Date: 05/07/2024 4:41:18 pm ******/
ALTER TABLE [dbo].[auth_user] ADD  CONSTRAINT [auth_user_username_6821ab7c_uniq] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_group_id_97559544]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [auth_user_groups_group_id_97559544] ON [dbo].[auth_user_groups]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_user_id_6a12ed8b]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [auth_user_groups_user_id_6a12ed8b] ON [dbo].[auth_user_groups]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_user_id_group_id_94350c0c_uniq]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [auth_user_groups_user_id_group_id_94350c0c_uniq] ON [dbo].[auth_user_groups]
(
	[user_id] ASC,
	[group_id] ASC
)
WHERE ([user_id] IS NOT NULL AND [group_id] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_permission_id_1fbb5f2c]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [auth_user_user_permissions_permission_id_1fbb5f2c] ON [dbo].[auth_user_user_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_user_id_a95ead1b]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [auth_user_user_permissions_user_id_a95ead1b] ON [dbo].[auth_user_user_permissions]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_user_id_permission_id_14a6b632_uniq]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [auth_user_user_permissions_user_id_permission_id_14a6b632_uniq] ON [dbo].[auth_user_user_permissions]
(
	[user_id] ASC,
	[permission_id] ASC
)
WHERE ([user_id] IS NOT NULL AND [permission_id] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_BAITHI]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_BAITHI] ON [dbo].[BAITHI]
(
	[MASV] ASC,
	[MAMH] ASC,
	[LAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_BAITHI]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_BAITHI] ON [dbo].[BAITHI]
(
	[MASV] ASC,
	[MAMH] ASC,
	[LAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_COSO]    Script Date: 05/07/2024 4:41:18 pm ******/
ALTER TABLE [dbo].[COSO] ADD  CONSTRAINT [UK_COSO] UNIQUE NONCLUSTERED 
(
	[TENCS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CT_BAITHI]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [IX_CT_BAITHI] ON [dbo].[CT_BAITHI]
(
	[MABT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [django_admin_log_content_type_id_c4bce8eb]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [django_admin_log_content_type_id_c4bce8eb] ON [dbo].[django_admin_log]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [django_admin_log_user_id_c564eba6]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [django_admin_log_user_id_c564eba6] ON [dbo].[django_admin_log]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [django_content_type_app_label_model_76bd3d3b_uniq]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE UNIQUE NONCLUSTERED INDEX [django_content_type_app_label_model_76bd3d3b_uniq] ON [dbo].[django_content_type]
(
	[app_label] ASC,
	[model] ASC
)
WHERE ([app_label] IS NOT NULL AND [model] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [django_session_expire_date_a5c62663]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [django_session_expire_date_a5c62663] ON [dbo].[django_session]
(
	[expire_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_TENLOP]    Script Date: 05/07/2024 4:41:18 pm ******/
ALTER TABLE [dbo].[LOP] ADD  CONSTRAINT [UK_TENLOP] UNIQUE NONCLUSTERED 
(
	[TENLOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_TENMH]    Script Date: 05/07/2024 4:41:18 pm ******/
ALTER TABLE [dbo].[MONHOC] ADD  CONSTRAINT [UK_TENMH] UNIQUE NONCLUSTERED 
(
	[TENMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MALOP]    Script Date: 05/07/2024 4:41:18 pm ******/
CREATE NONCLUSTERED INDEX [IX_MALOP] ON [dbo].[SINHVIEN]
(
	[MALOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BAITHI] ADD  CONSTRAINT [DF_BAITHI_NGAYTHI]  DEFAULT (getdate()) FOR [NGAYTHI]
GO
ALTER TABLE [dbo].[BAITHI] ADD  CONSTRAINT [DF_BAITHI_DIEM]  DEFAULT ((0)) FOR [DIEM]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] ADD  CONSTRAINT [DF_GIAOVIEN_DANGKY_NGAYTHI]  DEFAULT (getdate()) FOR [NGAYTHI]
GO
ALTER TABLE [dbo].[auth_group_permissions]  WITH CHECK ADD  CONSTRAINT [auth_group_permissions_group_id_b120cbf9_fk_auth_group_id] FOREIGN KEY([group_id])
REFERENCES [dbo].[auth_group] ([id])
GO
ALTER TABLE [dbo].[auth_group_permissions] CHECK CONSTRAINT [auth_group_permissions_group_id_b120cbf9_fk_auth_group_id]
GO
ALTER TABLE [dbo].[auth_group_permissions]  WITH CHECK ADD  CONSTRAINT [auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id] FOREIGN KEY([permission_id])
REFERENCES [dbo].[auth_permission] ([id])
GO
ALTER TABLE [dbo].[auth_group_permissions] CHECK CONSTRAINT [auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id]
GO
ALTER TABLE [dbo].[auth_permission]  WITH CHECK ADD  CONSTRAINT [auth_permission_content_type_id_2f476e4b_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[auth_permission] CHECK CONSTRAINT [auth_permission_content_type_id_2f476e4b_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[auth_user_groups]  WITH CHECK ADD  CONSTRAINT [auth_user_groups_group_id_97559544_fk_auth_group_id] FOREIGN KEY([group_id])
REFERENCES [dbo].[auth_group] ([id])
GO
ALTER TABLE [dbo].[auth_user_groups] CHECK CONSTRAINT [auth_user_groups_group_id_97559544_fk_auth_group_id]
GO
ALTER TABLE [dbo].[auth_user_groups]  WITH CHECK ADD  CONSTRAINT [auth_user_groups_user_id_6a12ed8b_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[auth_user_groups] CHECK CONSTRAINT [auth_user_groups_user_id_6a12ed8b_fk_auth_user_id]
GO
ALTER TABLE [dbo].[auth_user_user_permissions]  WITH CHECK ADD  CONSTRAINT [auth_user_user_permissions_permission_id_1fbb5f2c_fk_auth_permission_id] FOREIGN KEY([permission_id])
REFERENCES [dbo].[auth_permission] ([id])
GO
ALTER TABLE [dbo].[auth_user_user_permissions] CHECK CONSTRAINT [auth_user_user_permissions_permission_id_1fbb5f2c_fk_auth_permission_id]
GO
ALTER TABLE [dbo].[auth_user_user_permissions]  WITH CHECK ADD  CONSTRAINT [auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[auth_user_user_permissions] CHECK CONSTRAINT [auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id]
GO
ALTER TABLE [dbo].[BAITHI]  WITH CHECK ADD  CONSTRAINT [FK_BAITHI_MONHOC] FOREIGN KEY([MAMH])
REFERENCES [dbo].[MONHOC] ([MAMH])
GO
ALTER TABLE [dbo].[BAITHI] CHECK CONSTRAINT [FK_BAITHI_MONHOC]
GO
ALTER TABLE [dbo].[BAITHI]  WITH CHECK ADD  CONSTRAINT [FK_BAITHI_SINHVIEN] FOREIGN KEY([MASV])
REFERENCES [dbo].[SINHVIEN] ([MASV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[BAITHI] CHECK CONSTRAINT [FK_BAITHI_SINHVIEN]
GO
ALTER TABLE [dbo].[BODE]  WITH CHECK ADD  CONSTRAINT [FK_BODE_MONHOC] FOREIGN KEY([MAMH])
REFERENCES [dbo].[MONHOC] ([MAMH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[BODE] CHECK CONSTRAINT [FK_BODE_MONHOC]
GO
ALTER TABLE [dbo].[CT_BAITHI]  WITH CHECK ADD  CONSTRAINT [FK_CT_BAITHI_BAITHI] FOREIGN KEY([MABT])
REFERENCES [dbo].[BAITHI] ([MABT])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CT_BAITHI] CHECK CONSTRAINT [FK_CT_BAITHI_BAITHI]
GO
ALTER TABLE [dbo].[CT_BAITHI]  WITH CHECK ADD  CONSTRAINT [FK_CT_BAITHI_BODE] FOREIGN KEY([CAUHOI])
REFERENCES [dbo].[BODE] ([CAUHOI])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CT_BAITHI] CHECK CONSTRAINT [FK_CT_BAITHI_BODE]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_content_type_id_c4bce8eb_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_content_type_id_c4bce8eb_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_user_id_c564eba6_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_user_id_c564eba6_fk_auth_user_id]
GO
ALTER TABLE [dbo].[GIAOVIEN]  WITH CHECK ADD  CONSTRAINT [FK_GIAOVIEN_KHOA] FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHOA] ([MAKH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GIAOVIEN] CHECK CONSTRAINT [FK_GIAOVIEN_KHOA]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [FK_GIAOVIEN_DANGKY_GIAOVIEN1] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [FK_GIAOVIEN_DANGKY_GIAOVIEN1]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [FK_GIAOVIEN_DANGKY_LOP] FOREIGN KEY([MALOP])
REFERENCES [dbo].[LOP] ([MALOP])
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [FK_GIAOVIEN_DANGKY_LOP]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [FK_GIAOVIEN_DANGKY_MONHOC1] FOREIGN KEY([MAMH])
REFERENCES [dbo].[MONHOC] ([MAMH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [FK_GIAOVIEN_DANGKY_MONHOC1]
GO
ALTER TABLE [dbo].[KHOA]  WITH CHECK ADD  CONSTRAINT [FK_KHOA_COSO] FOREIGN KEY([MACS])
REFERENCES [dbo].[COSO] ([MACS])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[KHOA] CHECK CONSTRAINT [FK_KHOA_COSO]
GO
ALTER TABLE [dbo].[LOP]  WITH CHECK ADD  CONSTRAINT [FK_LOP_KHOA] FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHOA] ([MAKH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[LOP] CHECK CONSTRAINT [FK_LOP_KHOA]
GO
ALTER TABLE [dbo].[SINHVIEN]  WITH CHECK ADD  CONSTRAINT [FK_SINHVIEN_LOP] FOREIGN KEY([MALOP])
REFERENCES [dbo].[LOP] ([MALOP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SINHVIEN] CHECK CONSTRAINT [FK_SINHVIEN_LOP]
GO
ALTER TABLE [dbo].[BAITHI]  WITH CHECK ADD  CONSTRAINT [CK_BAITHI] CHECK  (([DIEM]>=(0) AND [DIEM]<=(10)))
GO
ALTER TABLE [dbo].[BAITHI] CHECK CONSTRAINT [CK_BAITHI]
GO
ALTER TABLE [dbo].[BODE]  WITH NOCHECK ADD  CONSTRAINT [CK_BODE] CHECK  (([TRINHDO]='A' OR [TRINHDO]='B' OR [TRINHDO]='C'))
GO
ALTER TABLE [dbo].[BODE] CHECK CONSTRAINT [CK_BODE]
GO
ALTER TABLE [dbo].[BODE]  WITH NOCHECK ADD  CONSTRAINT [CK_DAPAN] CHECK  (([DAP_AN]='D' OR ([DAP_AN]='C' OR ([DAP_AN]='B' OR [DAP_AN]='A'))))
GO
ALTER TABLE [dbo].[BODE] CHECK CONSTRAINT [CK_DAPAN]
GO
ALTER TABLE [dbo].[CT_BAITHI]  WITH CHECK ADD  CONSTRAINT [CK_CT_BAITHI] CHECK  (([TRALOI]='D' OR [TRALOI]='C' OR [TRALOI]='B' OR [TRALOI]='A'))
GO
ALTER TABLE [dbo].[CT_BAITHI] CHECK CONSTRAINT [CK_CT_BAITHI]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_action_flag_a8637d59_check] CHECK  (([action_flag]>=(0)))
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_action_flag_a8637d59_check]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [CK_LAN] CHECK  (([LAN]>=(1) AND [LAN]<=(2)))
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [CK_LAN]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [CK_SOCAUTHI] CHECK  (([SOCAUTHI]>=(10) AND [SOCAUTHI]<=(500)))
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [CK_SOCAUTHI]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [CK_THOIGIAN] CHECK  (([THOIGIAN]>=(1) AND [THOIGIAN]<=(60)))
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [CK_THOIGIAN]
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY]  WITH CHECK ADD  CONSTRAINT [CK_TRINHDO] CHECK  (([TRINHDO]='C' OR ([TRINHDO]='B' OR [TRINHDO]='A')))
GO
ALTER TABLE [dbo].[GIAOVIEN_DANGKY] CHECK CONSTRAINT [CK_TRINHDO]
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_BODE]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DELETE_BODE]
@CAUHOI INT
AS
BEGIN
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
	DELETE FROM BODE WHERE CAUHOI = @CAUHOI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_DANGKYTHI]    Script Date: 05/07/2024 4:41:18 pm ******/
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
	IF EXISTS (SELECT 1 FROM BAITHI BT
				INNER JOIN SINHVIEN SV ON BT.MASV = SV.MASV
				INNER JOIN LOP ON LOP.MALOP = SV.MALOP
				INNER JOIN GIAOVIEN_DANGKY DK ON DK.MALOP = SV.MALOP AND BT.MAMH = DK.MAMH AND BT.LAN = DK.LAN
				WHERE SV.MALOP = @MALOP AND DK.MAMH = @MAMH AND DK.LAN = @LAN)
	BEGIN
		RAISERROR('Không thể xóa đăng ký vì đã có sinh viên làm bài thi.', 16, 1)
		RETURN
	END

	DELETE FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND MALOP = @MALOP AND LAN = @LAN
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_GIAOVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DELETE_KHOA]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DELETE_LOP]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DELETE_MONHOC]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DELETE_SINHVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_BODE]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_GIAOVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_KHOA]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_LOP]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_MONHOC]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_EXISTED_SINHVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERT_BODE]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_INSERT_BODE]
@MAMH CHAR(5),
@TRINHDO CHAR(1),
@NOIDUNG NTEXT,
@A NTEXT,
@B NTEXT,
@C NTEXT,
@D NTEXT,
@DAP_AN CHAR(1),
@MAGV CHAR(8)
AS
BEGIN
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
	INSERT INTO BODE(MAMH, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAGV)
	VALUES(@MAMH, @TRINHDO, @NOIDUNG, @A, @B, @C, @D, @DAP_AN, @MAGV)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_DANGKYTHI]    Script Date: 05/07/2024 4:41:18 pm ******/
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
	IF @countQuestionCungTrinhDo < (@SOCAUTHI * 70 / 100)
		BEGIN
			SET @ErrorMessage = N'Không đủ câu hỏi để thi. Thiếu ' + CAST(ROUND(@SOCAUTHI * 70 / 100,0) - @countQuestionCungTrinhDo AS NVARCHAR(10)) + N' câu hỏi cùng trình độ.';
			RAISERROR(@ErrorMessage, 16, 1);
			RETURN
		END
	IF @countQuestionCungTrinhDo + @countQuestionTrinhDoDuoi < @SOCAUTHI
		BEGIN
			SET @ErrorMessage = N'Không đủ câu hỏi để thi. Thiếu ' + CAST(@SOCAUTHI - (@countQuestionCungTrinhDo + @countQuestionTrinhDoDuoi) AS NVARCHAR(10)) + N' câu.';
			RAISERROR(@ErrorMessage, 16, 1);
			RETURN
		END

	INSERT INTO GIAOVIEN_DANGKY (MAGV, MAMH, MALOP, TRINHDO, NGAYTHI, LAN, SOCAUTHI, THOIGIAN)
	VALUES (@MAGV, @MAMH, @MALOP, @TRINHDO, @NGAYTHI, @LAN, @SOCAUTHI, @THOIGIAN)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_GIAOVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERT_KHOA]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERT_LOP]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERT_MONHOC]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERT_SINHVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LAY_CAU_HOI]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LAY_CAU_HOI]
@MAMONHOC  NCHAR(5),
@TRINHDO  NCHAR(1),
@SOCAU INT
AS
BEGIN TRANSACTION
BEGIN
	/*
	Có thể dùng đoạn lên sau để thay thế cho 2 đoạn lệnh Declare bên dưới
	Đoạn lệnh này chỉ được viết và chưa được test
	DECLARE @countQuestionRequired int (
		SELECT COUNT(*)
		FROM BODE
		WHERE MAMH = @MAMONHOC
		AND (TRINHDO = @TRINHDO OR TRINHDO = CHAR(ASCII(@TRINHDO)+1))
	)
*/
  DECLARE @countQuestionCungTrinhDo int = (
		SELECT COUNT(*)
		FROM BODE
		WHERE MAMH = @MAMONHOC
		AND TRINHDO = @TRINHDO
	);
	DECLARE @countQuestionTrinhDoDuoi int = (
		SELECT COUNT(*)
		FROM BODE
		WHERE MAMH = @MAMONHOC
		AND TRINHDO = CHAR(ASCII(@TRINHDO)+1)
	);
	-- Kiểm tra số lượng câu hỏi trong hệ thống có đủ để tạo ra một bài thi không --
	IF ((@countQuestionCungTrinhDo + @countQuestionTrinhDoDuoi < @SOCAU) OR
		(@countQuestionCungTrinhDo < (@SOCAU * 70 / 100)))
		BEGIN
			RAISERROR(N'Không đủ câu hỏi để thi', 16, 1);
			ROLLBACK
			RETURN
		END
	
  CREATE TABLE #CAUHOITHI (
    CAUHOI int primary key,
    TRINHDO char(1),
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
	select CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV into #CungTrinhDoAtSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = @TRINHDO and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from KHOA)) ORDER BY NEWID();
	select CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV into #TrinhDoDuoiAtSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = CHAR(ASCII(@TRINHDO)+1) and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from KHOA)) ORDER BY NEWID();
	DECLARE @countQuestionCungTrinhDoAtSite int = (select count(*) from #CungTrinhDoAtSiteTable);
	DECLARE @countQuestionTrinhDoDuoiAtSite int = (select count(*) from #TrinhDoDuoiAtSiteTable);
	
	-- INSERT CUNG TRINH DO TAI SITE HIEN TAI --
	INSERT INTO #CAUHOITHI
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
			ORDER BY NEWID()

			INSERT INTO #CAUHOITHI
			SELECT TOP (ROUND((@SOCAU * 70 / 100) - @countQuestionCungTrinhDoAtSite,0)) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #CungTrinhDoOtherSite
		END

	SET @countQuestionCungTrinhDoAtSite = (SELECT COUNT(*) FROM #CAUHOITHI);

	IF ((@SOCAU - @countQuestionCungTrinhDoAtSite) > 0) AND (@countQuestionTrinhDoDuoiAtSite > (@SOCAU - @countQuestionCungTrinhDoAtSite))
		BEGIN
			INSERT INTO #CAUHOITHI
			SELECT TOP (@SOCAU - @countQuestionCungTrinhDoAtSite) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #TrinhDoDuoiAtSiteTable
		END
	ELSE IF ((@SOCAU - @countQuestionCungTrinhDoAtSite) > 0) AND (@countQuestionTrinhDoDuoiAtSite < (@SOCAU - @countQuestionCungTrinhDoAtSite))
		BEGIN
			INSERT INTO #CAUHOITHI
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
			ORDER BY NEWID();

			INSERT INTO #CAUHOITHI
			SELECT TOP (@SOCAU - @countQuestionCungTrinhDoAtSite - @countQuestionTrinhDoDuoiAtSite) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #DuoiTrinhDoOtherSite
		END
	SELECT TOP (@SOCAU)
		CAUHOI,
		CAST(NOIDUNG as nvarchar(max)) as [NOIDUNG],
		TRINHDO,
		CAST(A as nvarchar(max)) as [A],
		CAST(B as nvarchar(max)) as [B],
		CAST(C as nvarchar(max)) as [C],
		CAST(D as nvarchar(max)) as [D],
		DAP_AN  
	FROM #CAUHOITHI 
	ORDER BY NEWID()

DROP TABLE #CAUHOITHI
COMMIT
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayBaiThiDaDangKyTheoMaLop]    Script Date: 05/07/2024 4:41:18 pm ******/
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
    AND NGAYTHI > @current_time;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_LayCauHoi]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LayCauHoi]
@MABT NCHAR(10)
AS
BEGIN
	SELECT 
		CT.STT_DETHI,
		NOIDUNG,
		A, B, C, D,
		TRALOI
	FROM CT_BAITHI CT
	INNER JOIN BODE ON CT.CAUHOI = BODE.CAUHOI
	WHERE MABT = @MABT
	ORDER BY STT_DETHI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayCauHoiTheoMAGV]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LayDangKyHetHieuLucTheoMaSV]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayDangKyHetHieuLucTheoMaSV]
@MASV NCHAR(8)
AS
BEGIN
	SELECT MAGV, MAMH, SV.MALOP, TRINHDO, NGAYTHI, LAN, SOCAUTHI, THOIGIAN
	FROM GIAOVIEN_DANGKY GVDK
	INNER JOIN ( 
		SELECT MASV, MALOP
		FROM SINHVIEN
		WHERE MASV = @MASV 
	) SV ON SV.MALOP = GVDK.MALOP
	WHERE NGAYTHI < GETDATE()
		OR EXISTS (
			SELECT 1
			FROM BAITHI
			WHERE LAN = GVDK.LAN
				AND MAMH = GVDK.MAMH
				AND MASV = @MASV
		)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayDangKyTheoMAGV]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LayDangKyTheoMaSV]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_LayDangKyTheoMaSV]
@MASV NCHAR(8)
AS
BEGIN
	SELECT MAGV, MAMH, SV.MALOP, TRINHDO, NGAYTHI, LAN, SOCAUTHI, THOIGIAN
	FROM GIAOVIEN_DANGKY GVDK
	INNER JOIN ( 
		SELECT MASV, MALOP
		FROM SINHVIEN
		WHERE MASV = @MASV 
	) SV ON SV.MALOP = GVDK.MALOP
	WHERE NGAYTHI <= GETDATE()
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LayThongTinGiangVien]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LayThongTinSinhVien]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_REPORT_DSDangKyThi]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_REPORT_DSDangKyThi]
@FROMDATE DATE,
@TODATE DATE
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
		'' AS GHICHU
	FROM (SELECT MAGV, TRIM(GIAOVIEN.HO) + ' ' + TRIM(GIAOVIEN.TEN) AS TEN FROM GIAOVIEN) AS GV
	INNER JOIN (
		SELECT MAGV, MAMH, MALOP, NGAYTHI, SOCAUTHI, LAN 
		FROM GIAOVIEN_DANGKY 
		WHERE NGAYTHI BETWEEN @FROMDATE AND @TODATE
	) AS GVDK ON GVDK.MAGV = GV.MAGV
	INNER JOIN MONHOC ON MONHOC.MAMH = GVDK.MAMH
	INNER JOIN LOP ON LOP.MALOP = GVDK.MALOP
	LEFT JOIN (
		SELECT MAMH, SV.MALOP, LAN, 'X' AS DATHI
		FROM BAITHI 
		INNER JOIN (
			SELECT MASV, MALOP
			FROM SINHVIEN
		) AS SV ON SV.MASV = BAITHI.MASV
		INNER JOIN (
			SELECT MALOP
			FROM LOP
		) LOP ON SV.MALOP = LOP.MALOP
		WHERE NGAYTHI <= GETDATE() 
		GROUP BY SV.MALOP, BAITHI.MAMH, BAITHI.LAN
	) AS BT ON BT.MAMH = GVDK.MAMH AND BT.LAN = GVDK.LAN AND BT.MALOP = GVDK.MALOP
	ORDER BY NGAYTHI ASC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_InBangDiemMonHoc]    Script Date: 05/07/2024 4:41:18 pm ******/
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
            SINHVIEN SV
        LEFT JOIN 
            BAITHI BD ON SV.MASV = BD.MASV AND BD.MAMH = @MAMH AND BD.LAN = @LAN
        WHERE 
            SV.MALOP = @MALOP
        ORDER BY 
            SV.MASV;
    END
    ELSE
    BEGIN
        SELECT 
            CAST(NULL AS NCHAR(15)) AS MASV, 
            CAST(NULL AS NVARCHAR(255)) AS HOTEN, 
            CAST(NULL AS FLOAT) AS DIEM, 
            CAST(NULL AS NVARCHAR(10)) AS DIEMCHU
        WHERE 1 = 0;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SinhVienDangKy]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TAO_CAU_HOI]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TAO_CAU_HOI]
@MAMONHOC  NCHAR(5),
@TRINHDO  NCHAR(1),
@SOCAU INT
AS
BEGIN TRANSACTION
BEGIN
  CREATE TABLE #CAUHOITHI (
    CAUHOI int primary key,
    TRINHDO char(1),
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
	select CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV into #CungTrinhDoAtSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = @TRINHDO and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from KHOA)) ORDER BY NEWID();
	select CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, 
	MAMH, MAGV into #TrinhDoDuoiAtSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = CHAR(ASCII(@TRINHDO)+1) and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from KHOA)) ORDER BY NEWID();
	DECLARE @countQuestionCungTrinhDoAtSite int = (select count(*) from #CungTrinhDoAtSiteTable);
	DECLARE @countQuestionTrinhDoDuoiAtSite int = (select count(*) from #TrinhDoDuoiAtSiteTable);
	
	-- INSERT CUNG TRINH DO TAI SITE HIEN TAI --
	INSERT INTO #CAUHOITHI
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
			ORDER BY NEWID()

			INSERT INTO #CAUHOITHI
			SELECT TOP (ROUND((@SOCAU * 70 / 100) - @countQuestionCungTrinhDoAtSite,0)) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #CungTrinhDoOtherSite
		END

	SET @countQuestionCungTrinhDoAtSite = (SELECT COUNT(*) FROM #CAUHOITHI);

	IF ((@SOCAU - @countQuestionCungTrinhDoAtSite) > 0) AND (@countQuestionTrinhDoDuoiAtSite > (@SOCAU - @countQuestionCungTrinhDoAtSite))
		BEGIN
			INSERT INTO #CAUHOITHI
			SELECT TOP (@SOCAU - @countQuestionCungTrinhDoAtSite) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #TrinhDoDuoiAtSiteTable
		END
	ELSE IF ((@SOCAU - @countQuestionCungTrinhDoAtSite) > 0) AND (@countQuestionTrinhDoDuoiAtSite < (@SOCAU - @countQuestionCungTrinhDoAtSite))
		BEGIN
			INSERT INTO #CAUHOITHI
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
			ORDER BY NEWID();

			INSERT INTO #CAUHOITHI
			SELECT TOP (@SOCAU - @countQuestionCungTrinhDoAtSite - @countQuestionTrinhDoDuoiAtSite) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #DuoiTrinhDoOtherSite
		END
	SELECT TOP (@SOCAU)
		CAUHOI,
		CAST(NOIDUNG as nvarchar(max)) as [NOIDUNG],
		CAST(A as nvarchar(max)) as [A],
		CAST(B as nvarchar(max)) as [B],
		CAST(C as nvarchar(max)) as [C],
		CAST(D as nvarchar(max)) as [D],
		DAP_AN  
	FROM #CAUHOITHI 
	ORDER BY NEWID()

DROP TABLE #CAUHOITHI
COMMIT
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TaoBaiThi]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_TaoBaiThi]
@MASV CHAR(8),
@MAMH CHAR(5),
@LAN SMALLINT,
@NGAYTHI DATETIME,
@TRINHDO CHAR(1),
@SOCAU SMALLINT,
@TGCL INT
AS
BEGIN TRAN
BEGIN
	DECLARE @MABT INT
	INSERT INTO BAITHI(MASV, MAMH, LAN, NGAYTHI, DIEM, TGCL) VALUES(@MASV, @MAMH, @LAN, @NGAYTHI, 0, @TGCL*60) 
	SET @MABT = (SELECT MABT FROM BAITHI WHERE MAMH = @MAMH AND MASV = @MASV AND LAN = @LAN)

	CREATE TABLE #CAUHOITHI (
		CAUHOI int primary key,
		NOIDUNG ntext,
		A ntext,
		B ntext,
		C ntext,
		D ntext,
		DAP_AN nchar(1),
		STT_DETHI INT IDENTITY(1,1)
	)
	
	INSERT INTO #CAUHOITHI
	EXEC [dbo].[SP_TaoCauHoi] @MAMH, @TRINHDO, @SOCAU
	
	INSERT INTO CT_BAITHI(MABT, CAUHOI, TRALOI, STT_DETHI)
	SELECT @MABT, CAUHOI, '' , STT_DETHI
	FROM #CAUHOITHI
	
	COMMIT TRAN
	DROP TABLE #CAUHOITHI
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TaoCauHoi]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TaoCauHoi]
@MAMONHOC  NCHAR(5),
@TRINHDO  NCHAR(1),
@SOCAU INT
AS
BEGIN TRANSACTION
BEGIN
  CREATE TABLE #CAUHOITHI (
    CAUHOI int primary key,
    TRINHDO char(1),
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
	into #CungTrinhDoAtSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = @TRINHDO and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from KHOA)) ORDER BY NEWID();
	select CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV 
	into #TrinhDoDuoiAtSiteTable from BODE  where MAMH = @maMonHoc and TRINHDO = CHAR(ASCII(@TRINHDO)+1) and MAGV in (Select MAGV from GIAOVIEN where MAKH in(select MAKH from KHOA)) ORDER BY NEWID();
	DECLARE @countQuestionCungTrinhDoAtSite int = (select count(*) from #CungTrinhDoAtSiteTable);
	DECLARE @countQuestionTrinhDoDuoiAtSite int = (select count(*) from #TrinhDoDuoiAtSiteTable);
	
	-- INSERT CUNG TRINH DO TAI SITE HIEN TAI --
	INSERT INTO #CAUHOITHI
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
			ORDER BY NEWID()

			INSERT INTO #CAUHOITHI
			SELECT TOP (ROUND((@SOCAU * 70 / 100) - @countQuestionCungTrinhDoAtSite,0)) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #CungTrinhDoOtherSite
		END

	SET @countQuestionCungTrinhDoAtSite = (SELECT COUNT(*) FROM #CAUHOITHI);

	IF ((@SOCAU - @countQuestionCungTrinhDoAtSite) > 0) AND (@countQuestionTrinhDoDuoiAtSite > (@SOCAU - @countQuestionCungTrinhDoAtSite))
		BEGIN
			INSERT INTO #CAUHOITHI
			SELECT TOP (@SOCAU - @countQuestionCungTrinhDoAtSite) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #TrinhDoDuoiAtSiteTable
		END
	ELSE IF ((@SOCAU - @countQuestionCungTrinhDoAtSite) > 0) AND (@countQuestionTrinhDoDuoiAtSite < (@SOCAU - @countQuestionCungTrinhDoAtSite))
		BEGIN
			INSERT INTO #CAUHOITHI
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
			ORDER BY NEWID();

			INSERT INTO #CAUHOITHI
			SELECT TOP (@SOCAU - @countQuestionCungTrinhDoAtSite - @countQuestionTrinhDoDuoiAtSite) 
				CAUHOI, TRINHDO, NOIDUNG, A, B, C, D, DAP_AN, MAMH, MAGV
			FROM #DuoiTrinhDoOtherSite
		END
	SELECT TOP (@SOCAU)
		CAUHOI,
		CAST(NOIDUNG as nvarchar(max)) as [NOIDUNG],
		CAST(A as nvarchar(max)) as [A],
		CAST(B as nvarchar(max)) as [B],
		CAST(C as nvarchar(max)) as [C],
		CAST(D as nvarchar(max)) as [D],
		DAP_AN  
	FROM #CAUHOITHI 
	ORDER BY NEWID()

DROP TABLE #CAUHOITHI
COMMIT
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TaoMaCauHoi]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TaoTaiKhoan]    Script Date: 05/07/2024 4:41:18 pm ******/
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
        -- Create the login
        DECLARE @SQL NVARCHAR(MAX)
        SET @SQL = N'CREATE LOGIN [' + @LGNAME + '] WITH PASSWORD = N''' + @PASS + ''''
        EXEC sp_executesql @SQL

        -- Create the user and map to the login
        SET @SQL = N'CREATE USER [' + @USERNAME + '] FOR LOGIN [' + @LGNAME + ']'
        EXEC sp_executesql @SQL

        -- Add the user to the database role
        SET @SQL = N'ALTER ROLE [' + @ROLE + '] ADD MEMBER [' + @USERNAME + ']'
        EXEC sp_executesql @SQL

        -- Add the login to server roles based on the provided role
        IF @ROLE = 'Truong' OR @ROLE = 'Coso'
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
/****** Object:  StoredProcedure [dbo].[SP_ThayDoiTenKhoa]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ThayDoiTenKhoa]
    @makhoa CHAR(5),
    @tenkhoa NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (
		SELECT 1
        FROM KHOA
        WHERE MAKH = @makhoa
	)
	BEGIN
        RAISERROR ('Mã khoa không tồn tại.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM KHOA
        WHERE TENKH = @tenkhoa
            AND MAKH != @makhoa
    )
    BEGIN
        RAISERROR ('Tên khoa đã tồn tại.', 16, 1);
        RETURN;
    END;

    UPDATE KHOA
    SET TENKH = @tenkhoa
    WHERE MAKH = @makhoa;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_ThayDoiTenMonHoc]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ThayDoiTenMonHoc]
    @mamon CHAR(5),
    @tenmon NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (
		SELECT 1
        FROM MONHOC
        WHERE MAMH = @mamon
	)
	BEGIN
        RAISERROR ('Mã môn học không tồn tại.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM MONHOC
        WHERE TENMH = @tenmon
            AND MAMH != @mamon
    )
    BEGIN
        RAISERROR ('Tên môn học đã tồn tại.', 16, 1);
        RETURN;
    END;

    UPDATE MONHOC
    SET TENMH = @tenmon
    WHERE MAMH = @mamon;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_ThemGiangVien]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ThemGiangVien]
    @magv CHAR(8),
    @ho NVARCHAR(50),
    @ten NVARCHAR(10),
    @diachi NVARCHAR(50),
    @makhoa CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Giaovien (MAGV, HO, TEN, DIACHI, MAKH) VALUES (@magv, @ho, @ten, @diachi, @makhoa);
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_ThemKhoa]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ThemKhoa] 
    @makhoa NVARCHAR(255),
    @tenkhoa NVARCHAR(255),
    @macs NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Khoa WHERE MAKH = @makhoa)
    BEGIN
        RAISERROR ('Mã khoa đã tồn tại', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Khoa WHERE TENKH = @tenkhoa)
    BEGIN
        RAISERROR ('Tên khoa đã tồn tại', 16, 1);
        RETURN;
    END

    INSERT INTO Khoa (MAKH, TENKH, MACS) VALUES (@makhoa, @tenkhoa, @macs);
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_ThemMonHoc]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ThemMonHoc] 
    @mamon NVARCHAR(255),
    @tenmon NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mamon_count INT;
    DECLARE @tenmon_count INT;

    SELECT @mamon_count = COUNT(*) FROM Monhoc WHERE MAMH = @mamon;

    SELECT @tenmon_count = COUNT(*) FROM Monhoc WHERE TENMH = @tenmon;

    IF @mamon_count > 0
    BEGIN
        RAISERROR ('Mã môn học đã tồn tại', 16, 1);
        RETURN;
    END

    IF @tenmon_count > 0
    BEGIN
        RAISERROR ('Tên môn học đã tồn tại', 16, 1);
        RETURN;
    END

    INSERT INTO Monhoc (MAMH, TENMH) VALUES (@mamon, @tenmon);
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_ThongTinBaiThi]    Script Date: 05/07/2024 4:41:18 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ThongTinBaiThi]
@MASV CHAR(8),
@MAMH CHAR(5),
@LAN SMALLINT,
@TRINHDO CHAR(1),
@SOCAU SMALLINT
AS
BEGIN
	DECLARE @TGCL INT
	DECLARE @MABT INT
	DECLARE @STR NCHAR(255)
	IF NOT EXISTS(SELECT 1 FROM BAITHI WHERE MASV = @MASV AND MAMH = @MAMH AND LAN = @LAN)
	BEGIN
		DECLARE @NGAYTHI DATE = GETDATE()

		SELECT @TGCL = THOIGIAN FROM GIAOVIEN_DANGKY WHERE MAMH = @MAMH AND LAN = @LAN AND MALOP IN (SELECT MALOP FROM SINHVIEN WHERE MASV = @MASV)

		EXEC [dbo].[SP_TaoBaiThi] @MASV, @MAMH, @LAN, @NGAYTHI, @TRINHDO, @SOCAU, @TGCL
	END

	SELECT @MABT = MABT FROM BAITHI WHERE MASV = @MASV AND MAMH = @MAMH AND LAN = @LAN

	SELECT 
		SV.MALOP AS N'MÃ LỚP',
		TENLOP AS N'LỚP',
		TEN AS N'HỌ TÊN',
		TENMH AS N'TÊN MÔN',
		NGAYTHI AS N'NGÀY THI',
		LAN	AS N'LẦN',
		TGCL AS N'THỜI GIAN CÒN LẠI',
		@MABT AS N'Mã bài thi'
	FROM (
		SELECT * FROM BAITHI WHERE MABT = @MABT
	) AS BAITHI
	INNER JOIN (
		SELECT MASV, HO + TEN AS TEN, MALOP FROM SINHVIEN WHERE MASV = @MASV
	) AS SV ON BAITHI.MASV = SV.MASV
	INNER JOIN (
		SELECT MAMH, TENMH FROM MONHOC WHERE MAMH = @MAMH
	) AS MONHOC ON MONHOC.MAMH = BAITHI.MAMH
	INNER JOIN (
		SELECT MALOP, TENLOP FROM LOP
	) AS LOP ON LOP.MALOP = SV.MALOP
	WHERE NGAYTHI <= GETDATE()
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_BODE]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_GIAOVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_KHOA]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_LOP]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_MONHOC]    Script Date: 05/07/2024 4:41:18 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_SINHVIEN]    Script Date: 05/07/2024 4:41:18 pm ******/
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
USE [master]
GO
ALTER DATABASE [TTN] SET  READ_WRITE 
GO
