# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.

import pyodbc
from datetime import datetime
from django.db import models
from typing import Dict, Any


class DatabaseModel:
    def __init__(self, server, database, login, pw):
        self.server = server
        self.database = database
        self.co_so = []
        self.server_list = []
        self.login = login
        self.pw = pw

    def find_driver(self):
        for d in pyodbc.drivers():
            if "ODBC" in d:
                return d

    def connect_to_database(self):
        DRIVER = "{" + self.find_driver() + "}"
        try:
            con = pyodbc.connect(
                f"Driver={DRIVER};"
                f"Server={self.server};"
                f"Database={self.database};"
                # "Trusted_Connection=yes;"
                f"UID={self.login};"
                f"PWD={self.pw};"
            )
        except pyodbc.Error as e:
            print(f"Error: {e}")
        else:
            return con

    def load_info(self):
        con = self.connect_to_database()
        cur = con.cursor()

        try:
            v_sql = "SELECT * FROM V_DSPHANMANH"
            cur.execute(v_sql)

            rows = cur.fetchall()
            for row in rows:
                self.co_so.append(row[0])
                self.server_list.append(row[1])

        except Exception as e:
            print("Error:", e)

        finally:
            cur.close()
            con.close()


class Coso:
    def __init__(self, macs: str, tencs: str, diachi: str):
        self.macs = macs
        self.tencs = tencs
        self.diachi = diachi


class Khoa:
    def __init__(self, makh: str, tenkh: str, coso: Dict):
        self.makh = makh
        self.tenkh = tenkh
        self.coso = coso


class Lop:
    def __init__(self, malop: str, tenlop: str, khoa: Dict):
        self.malop = malop
        self.tenlop = tenlop
        self.khoa = khoa


class Giangvien:
    def __init__(self, magv: str, ho: str, ten: str, diachi: str, khoa: Dict):
        self.magv = magv
        self.ho = ho
        self.ten = ten
        self.diachi = diachi
        self.khoa = khoa


class Sinhvien:
    def __init__(self, masv: str, ho: str, ten: str, ngaysinh: str, diachi: str, lop: Dict):
        self.masv = masv
        self.ho = ho
        self.ten = ten
        self.ngaysinh = ngaysinh
        self.diachi = diachi
        self.lop = lop


class Mon:
    def __init__(self, mamh: str, tenmh: str):
        self.mamh = mamh
        self.tenmh = tenmh


class Bode:
    def __init__(self, cauhoi: int, monhoc: Dict, trinhdo: str, noidung: str, a: str, b: str, c: str, d: str, dapan: str, gv: Dict):
        self.cauhoi = cauhoi
        self.monhoc = monhoc
        self.trinhdo = trinhdo
        self.noidung = noidung
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.dapan = dapan
        self.gv = gv


class Dangky:
    def __init__(self, gv: Dict, monhoc: Dict, lop: Dict, trinhdo: str, ngaythi: datetime, lan: int, socauthi: int, thoigian: int):
        self.gv = gv
        self.monhoc = monhoc
        self.lop = lop
        self.trinhdo = trinhdo
        self.ngaythi = ngaythi
        self.lan = lan
        self.socauthi = socauthi
        self.thoigian = thoigian


class DangkySV:
    def __init__(self, gv: Dict, monhoc: Dict, lop: Dict, trinhdo: str, ngaythi: datetime, lan: int, socauthi: int, thoigian: int, mabt: int):
        self.gv = gv
        self.monhoc = monhoc
        self.lop = lop
        self.trinhdo = trinhdo
        self.ngaythi = ngaythi
        self.lan = lan
        self.socauthi = socauthi
        self.thoigian = thoigian
        self.mabt = mabt


class Dotthi:
    def __init__(self, monhoc: Dict, trinhdo: str, lan: int, ngaythi: datetime, diem: float, mabt: int):
        self.monhoc = monhoc
        self.trinhdo = trinhdo
        self.lan = lan
        self.ngaythi = ngaythi
        self.diem = diem
        self.mabt = mabt

# class Baithi(models.Model):
#     mabt = models.CharField(db_column='MABT', primary_key=True, max_length=10, db_collation='SQL_Latin1_General_CP1_CI_AS')  # Field name made lowercase.
#     masv = models.ForeignKey('Sinhvien', models.DO_NOTHING, db_column='MASV')  # Field name made lowercase.
#     mamh = models.ForeignKey('Monhoc', models.DO_NOTHING, db_column='MAMH')  # Field name made lowercase.
#     lan = models.SmallIntegerField(db_column='LAN')  # Field name made lowercase.
#     ngaythi = models.DateField(db_column='NGAYTHI')  # Field name made lowercase.
#     diem = models.FloatField(db_column='DIEM', blank=True, null=True)  # Field name made lowercase.
#     rowguid = models.CharField(unique=True, max_length=36)

#     class Meta:
#         managed = False
#         db_table = 'BAITHI'




# class CtBaithi(models.Model):
#     mabt = models.OneToOneField(Baithi, models.DO_NOTHING, db_column='MABT', primary_key=True)  # Field name made lowercase. The composite primary key (MABT, CAUHOI) found, that is not supported. The first column is selected.
#     cauhoi = models.ForeignKey(Bode, models.DO_NOTHING, db_column='CAUHOI')  # Field name made lowercase.
#     traloi = models.TextField(db_column='TRALOI', db_collation='SQL_Latin1_General_CP1_CI_AS')  # Field name made lowercase.
#     stt_dethi = models.SmallIntegerField(db_column='STT_DETHI')  # Field name made lowercase.
#     rowguid = models.CharField(unique=True, max_length=36)

#     class Meta:
#         managed = False
#         db_table = 'CT_BAITHI'
#         unique_together = (('mabt', 'cauhoi'),)




# class GiaovienDangky(models.Model):
#     magv = models.ForeignKey(Giaovien, models.DO_NOTHING, db_column='MAGV', blank=True, null=True)  # Field name made lowercase.
#     mamh = models.OneToOneField('Monhoc', models.DO_NOTHING, db_column='MAMH', primary_key=True)  # Field name made lowercase. The composite primary key (MAMH, MALOP, LAN) found, that is not supported. The first column is selected.
#     # malop = models.ForeignKey('Lop', models.DO_NOTHING, db_column='MALOP')  # Field name made lowercase.
#     trinhdo = models.CharField(db_column='TRINHDO', max_length=1, db_collation='SQL_Latin1_General_CP1_CI_AS', blank=True, null=True)  # Field name made lowercase.
#     ngaythi = models.DateTimeField(db_column='NGAYTHI', blank=True, null=True)  # Field name made lowercase.
#     lan = models.SmallIntegerField(db_column='LAN')  # Field name made lowercase.
#     socauthi = models.SmallIntegerField(db_column='SOCAUTHI', blank=True, null=True)  # Field name made lowercase.
#     thoigian = models.SmallIntegerField(db_column='THOIGIAN', blank=True, null=True)  # Field name made lowercase.
#     rowguid = models.CharField(unique=True, max_length=36)

#     class Meta:
#         managed = False
#         db_table = 'GIAOVIEN_DANGKY'
#         unique_together = (('mamh', 'malop', 'lan'),)
