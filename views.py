from django.shortcuts import render
from django.db import connection, connections
from django.contrib import messages
from django.http import HttpResponse
from .models import *

DATABASE = "TTN"
SERVER_LIST = ["MIE"]
temp = DatabaseModel(server=SERVER_LIST[0], database=DATABASE, login="sa", pw="239003")
temp.load_info()
DB_CONNECTION = {
    "servers": SERVER_LIST + temp.server_list,
    "coso": temp.co_so
}

CURRENT_DB = DatabaseModel

# Create your views here.

def login_register(request):
    danhsach_cs = DB_CONNECTION["coso"][0:-1]

    con, cur = None, None
    try:
        db = DatabaseModel(server=DB_CONNECTION["servers"][0], database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM V_DSSINHVIENDANGKY")
        danhsach_sv = cur.fetchall()
    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if cur is not None:
            cur.close()
        if con is not None:
            con.close()

    context = {"danhsach_cs": danhsach_cs, "danhsach_sv": danhsach_sv}
    return render(request, 'login_register.html', context)
        

def coso_table(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM COSO")
        rows = cur.fetchall()
        
        coso = []
        for row in rows:
            coso_object = Coso(macs=row[0], tencs=row[1], diachi=row[2])
            coso.append(coso_object)

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"coso": coso, "thongtin": info}

    return render(request, 'base/coso.html', context)


def khoa_table(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM COSO")
        coso_rows = cur.fetchall()
        cur.execute("SELECT * FROM KHOA")
        khoa_rows = cur.fetchall()
        
        coso = {}
        for row in coso_rows:
            coso[row[0]] = {"tencs": row[1], "diachi": row[2]}


        khoa = []
        for row in khoa_rows:
            khoa_object = Khoa(makh=row[0], tenkh=row[1], coso=coso[row[2]])
            khoa.append(khoa_object)


    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()


    info = request.session.get('current_info')

    context = {"khoa": khoa, "thongtin": info}
    return render(request, 'base/khoa.html', context)


def lop_table(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM LOP")
        lop_rows = cur.fetchall()
        cur.execute("SELECT * FROM KHOA")
        khoa_rows = cur.fetchall()
        
        khoa = {}
        for row in khoa_rows:
            khoa[row[0]] = {"tenkh": row[1], "macs": row[2]}


        lop = []
        for row in lop_rows:
            lop_object = Lop(malop=row[0], tenlop=row[1], khoa=khoa[row[2]])
            lop.append(lop_object)


    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"lop": lop, "thongtin": info}
    return render(request, 'base/lop.html', context)


def gv_table(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=DB_CONNECTION["servers"][0], database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM KHOA")
        khoa_rows = cur.fetchall()

        khoa = {}
        for row in khoa_rows:
            khoa[row[0]] = {"tenkh": row[1], "macs": row[2]}

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()
    
    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM GIAOVIEN")
        gv_rows = cur.fetchall()

        gv = []
        for row in gv_rows:
            gv_object = Giangvien(magv=row[0], ho=row[1], ten=row[2], diachi=row[3], khoa=khoa[row[4]])
            gv.append(gv_object)

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"giangvien": gv, "thongtin": info}
    return render(request, 'base/giangvien.html', context)


def sv_table(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM LOP")
        lop_rows = cur.fetchall()
        cur.execute("SELECT * FROM SINHVIEN")
        sv_rows = cur.fetchall()
        
        lop = {}
        for row in lop_rows:
            lop[row[0]] = {"tenlop": row[1], "makh": row[2]}


        sv = []
        for row in sv_rows:
            sv_object = Sinhvien(masv=row[0], ho=row[1], ten=row[2], ngaysinh=row[3], diachi=row[4], lop=lop[row[5]])
            sv.append(sv_object)


    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"sinhvien": sv, "thongtin": info}
    return render(request, 'base/sinhvien.html', context)


def mon_table(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM MONHOC")
        rows = cur.fetchall()
        
        mon = []
        for row in rows:
            mon_object = Mon(mamh=row[0], tenmh=row[1])
            mon.append(mon_object)

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"monhoc": mon, "thongtin": info}
    return render(request, 'base/monhoc.html', context)


def bode_table(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=DB_CONNECTION["servers"][0], database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM GIAOVIEN")
        gv_rows = cur.fetchall()

        gv = {}
        for row in gv_rows:
            gv[row[0]] = {"ho": row[1], "ten": row[2], "diachi": row[3], "makh": row[4]}

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()
    
    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM MONHOC")
        mon_rows = cur.fetchall()

        mon = {}
        for row in mon_rows:
            mon[row[0]] = {"tenmh": row[1]}

        
        cur.execute("SELECT * FROM BODE")
        bode_rows = cur.fetchall()

        bode = []
        for row in bode_rows:
            bode_object = Bode(cauhoi=row[0], monhoc=mon[row[1]], trinhdo=row[2], noidung=row[3],
                               a=row[4], b=row[5], c=row[6], d=row[7], dapan=row[8], gv=gv[row[9]])
            bode.append(bode_object)

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"bode": bode, "thongtin": info}
    return render(request, 'base/bode.html', context)


def bode_table_gv(request):
    db_alias = request.session.get('current_server')
    
    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM MONHOC")
        mon_rows = cur.fetchall()

        mon = {}
        for row in mon_rows:
            mon[row[0]] = {"tenmh": row[1]}

        magv = request.session.get("current_info")[0]
        tengv = request.session.get("current_info")[1]
        gv = {magv: {"tengv": tengv}}
        cur.execute(f"EXEC SP_LayCauHoiTheoMAGV '{magv}'")

        bode_rows = cur.fetchall()

        bode = []
        for row in bode_rows:
            bode_object = Bode(cauhoi=row[0], monhoc=mon[row[1]], trinhdo=row[2], noidung=row[3],
                               a=row[4], b=row[5], c=row[6], d=row[7], dapan=row[8], gv=gv)
            bode.append(bode_object)

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"bode": bode, "thongtin": info}
    return render(request, 'base/bode.html', context)


def dangky_table(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=DB_CONNECTION["servers"][0], database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM GIAOVIEN")
        gv_rows = cur.fetchall()

        gv = {}
        for row in gv_rows:
            gv[row[0]] = {"ho": row[1], "ten": row[2], "diachi": row[3], "makh": row[4]}

        cur.execute("SELECT * FROM LOP")
        lop_rows = cur.fetchall()

        lop = {}
        for row in lop_rows:
            lop[row[0]] = {"tenlop": row[1], "makh": row[2]}

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()
    
    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM MONHOC")
        mon_rows = cur.fetchall()

        mon = {}
        for row in mon_rows:
            mon[row[0]] = {"tenmh": row[1]}


        cur.execute("SELECT * FROM GIAOVIEN_DANGKY")
        dangky_rows = cur.fetchall()

        dangky = []
        for row in dangky_rows:
            dangky_object = Dangky(gv=gv[row[0]], monhoc=mon[row[1]], lop=lop[row[2]], trinhdo=row[3],
                                   ngaythi=row[4], lan=row[5], socauthi=row[6], thoigian=row[7])
            dangky.append(dangky_object)

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"dangky": dangky, "thongtin": info}
    return render(request, 'base/dangkythi.html', context)


def dangky_table_gv(request):
    db_alias = request.session.get('current_server')

    try:
        db = DatabaseModel(server=DB_CONNECTION["servers"][0], database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM LOP")
        lop_rows = cur.fetchall()

        lop = {}
        for row in lop_rows:
            lop[row[0]] = {"tenlop": row[1], "makh": row[2]}

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()
    
    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
        con = db.connect_to_database()
        cur = con.cursor()
        cur.execute("SELECT * FROM MONHOC")
        mon_rows = cur.fetchall()

        mon = {}
        for row in mon_rows:
            mon[row[0]] = {"tenmh": row[1]}

        magv = request.session.get("current_info")[0]
        tengv = request.session.get("current_info")[1]
        gv = {magv: {"tengv": tengv}}
        cur.execute(f"EXEC SP_LayDangKyTheoMAGV '{magv}'")

        dangky_rows = cur.fetchall()

        dangky = []
        for row in dangky_rows:
            dangky_object = Dangky(gv=gv, monhoc=mon[row[1]], lop=lop[row[2]], trinhdo=row[3],
                                   ngaythi=row[4], lan=row[5], socauthi=row[6], thoigian=row[7])
            dangky.append(dangky_object)

    except pyodbc.Error as e:
        print(f"Error connecting to database: {e}")
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'con' in locals():
            con.close()

    info = request.session.get('current_info')

    context = {"dangky": dangky, "thongtin": info}
    return render(request, 'base/dangkythi.html', context)