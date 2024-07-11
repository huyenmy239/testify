from django.shortcuts import render
from django.contrib import messages
from django.http import HttpResponse
from .models import *

DATABASE = "TTN"
SERVER_LIST = ["MIE"]
# Password for all instances
PASSWORD = "239003"
temp = DatabaseModel(
    server=SERVER_LIST[0], database=DATABASE, login="sa", pw=PASSWORD)
temp.load_info()
DB_CONNECTION = {
    "servers": SERVER_LIST + temp.server_list,
    "coso": temp.co_so
}

CURRENT_DB = DatabaseModel


# Create your views here.

def login_register(request):
    if request.session.get("current-info"):
        del request.session['current-info']
    danhsach_cs = DB_CONNECTION["coso"][0:-1]

    danhsach_sv = []

    try:
        db = DatabaseModel(
            server=DB_CONNECTION["servers"][0], database=DATABASE, login="sa", pw=PASSWORD)

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_DSSINHVIENDANGKY")
                danhsach_sv = cur.fetchall()

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    context = {"danhsach_cs": danhsach_cs, "danhsach_sv": danhsach_sv}
    return render(request, 'login_register.html', context)


def coso_table(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    coso = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM COSO")
                rows = cur.fetchall()

                coso = [Coso(macs=row[0], tencs=row[1], diachi=row[2])
                        for row in rows]

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"coso": coso, "thongtin": info}
    return render(request, 'base/coso.html', context)


def khoa_table(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    coso = {}
    khoa = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_COSOTABLE")
                coso_rows = cur.fetchall()

                cur.execute("SELECT * FROM V_KHOATABLE")
                khoa_rows = cur.fetchall()

                coso = {row[0]: {"macs": row[0], "tencs": row[1],
                                 "diachi": row[2]} for row in coso_rows}

                khoa = [Khoa(makh=row[0], tenkh=row[1], coso=coso[row[2]])
                        for row in khoa_rows]

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"khoa": khoa, "thongtin": info}
    return render(request, 'base/khoa.html', context)


def lop_table(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    khoa = {}
    lop = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_LOPTABLE")
                lop_rows = cur.fetchall()

                cur.execute("SELECT * FROM V_KHOATABLE")
                khoa_rows = cur.fetchall()

                khoa = {row[0]: {"makh": row[0], "tenkh": row[1],
                                 "macs": row[2]} for row in khoa_rows}

                lop = [Lop(malop=row[0], tenlop=row[1], khoa=khoa[row[2]])
                       for row in lop_rows]

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"lop": lop, "thongtin": info, "khoa_list": khoa}
    return render(request, 'base/lop.html', context)


def gv_table(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    khoa = {}
    gv = []
    khoa_list = {}

    try:
        db1 = DatabaseModel(
            server=DB_CONNECTION["servers"][0], database=DATABASE, login="sa", pw=PASSWORD)
        with db1.connect_to_database() as con1:
            with con1.cursor() as cur1:
                cur1.execute("SELECT * FROM V_KHOATABLE")
                khoa_rows = cur1.fetchall()
                khoa = {row[0]: {"makh": row[0], "tenkh": row[1],
                                 "macs": row[2]} for row in khoa_rows}

        db2 = DatabaseModel(server=db_alias, database=DATABASE, login=login.get(
            'username'), pw=login.get('password'))
        with db2.connect_to_database() as con2:
            with con2.cursor() as cur2:
                cur2.execute("SELECT * FROM V_GIAOVIENTABLE")
                gv_rows = cur2.fetchall()
                gv = [Giangvien(magv=row[0], ho=row[1], ten=row[2],
                                diachi=row[3], khoa=khoa[row[4]]) for row in gv_rows]

                cur2.execute("SELECT * FROM V_KHOATABLE")
                khoa_rows = cur2.fetchall()
                khoa_list = {
                    row[0]: {"makh": row[0], "tenkh": row[1], "macs": row[2]} for row in khoa_rows}

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"giangvien": gv, "thongtin": info, "khoa_list": khoa_list}
    return render(request, 'base/giangvien.html', context)


def sv_table(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    lop = {}
    sv = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_LOPTABLE")
                lop_rows = cur.fetchall()

                cur.execute("SELECT * FROM V_SINHVIENTABLE")
                sv_rows = cur.fetchall()

                for row in lop_rows:
                    lop[row[0]] = {"malop": row[0],
                                   "tenlop": row[1], "makh": row[2]}

                for row in sv_rows:
                    sv_object = Sinhvien(
                        masv=row[0], ho=row[1], ten=row[2], ngaysinh=row[3], diachi=row[4], lop=lop[row[5]])
                    sv.append(sv_object)

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"sinhvien": sv, "thongtin": info, "lop_list": lop}
    return render(request, 'base/sinhvien.html', context)


def mon_table(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    mon = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_MONHOCTABLE")
                rows = cur.fetchall()

                for row in rows:
                    mon_object = Mon(mamh=row[0], tenmh=row[1])
                    mon.append(mon_object)

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"monhoc": mon, "thongtin": info}
    return render(request, 'base/monhoc.html', context)


def bode_table(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    gv = {}
    mon = {}
    bode = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_GIAOVIENTABLE")
                gv_rows = cur.fetchall()

                for row in gv_rows:
                    gv[row[0]] = {"magv": row[0], "ho": row[1],
                                  "ten": row[2], "diachi": row[3], "makh": row[4]}

                cur.execute("SELECT * FROM V_MONHOCTABLE")
                mon_rows = cur.fetchall()

                for row in mon_rows:
                    mon[row[0]] = {"mamon": row[0], "tenmh": row[1]}

                cur.execute("SELECT * FROM V_BODETABLE")
                bode_rows = cur.fetchall()

                for row in bode_rows:
                    bode_object = Bode(cauhoi=row[0], monhoc=mon[row[1]], trinhdo=row[2], noidung=row[3],
                                       a=row[4], b=row[5], c=row[6], d=row[7], dapan=row[8], gv=gv[row[9]])
                    bode.append(bode_object)

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"bode": bode, "thongtin": info, "gv": gv, "mon": mon}
    return render(request, 'base/bode.html', context)


def bode_table_gv(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    mon = {}
    lop = {}
    gv = {}
    bode = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_MONHOCTABLE")
                mon_rows = cur.fetchall()
                for row in mon_rows:
                    mon[row[0]] = {"mamon": row[0], "tenmh": row[1]}

                cur.execute("SELECT * FROM V_LOPTABLE")
                lop_rows = cur.fetchall()
                for row in lop_rows:
                    lop[row[0]] = {"malop": row[0], "tenlop": row[1]}

                magv = request.session.get("current_info")[0]
                tengv = request.session.get("current_info")[1]
                gv[magv] = {"magv": magv, "tengv": tengv}

                cur.execute(f"EXEC SP_LayCauHoiTheoMAGV '{magv}'")
                bode_rows = cur.fetchall()

                for row in bode_rows:
                    bode_object = Bode(cauhoi=row[0], monhoc=mon[row[1]], trinhdo=row[2], noidung=row[3],
                                       a=row[4], b=row[5], c=row[6], d=row[7], dapan=row[8], gv=gv[magv]["tengv"])
                    bode.append(bode_object)

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"bode": bode, "thongtin": info,
               "mon": mon, "gv": gv, "lop": lop}
    return render(request, 'base/bode.html', context)


def dangky_table(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    gv = {}
    lop = {}
    mon = {}
    dangky = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_GIAOVIENTABLE")
                gv_rows = cur.fetchall()

                for row in gv_rows:
                    gv[row[0]] = {"magv": row[0], "ho": row[1],
                                  "ten": row[2], "diachi": row[3], "makh": row[4]}

                cur.execute("SELECT * FROM V_LOPTABLE")
                lop_rows = cur.fetchall()

                for row in lop_rows:
                    lop[row[0]] = {"malop": row[0],
                                   "tenlop": row[1], "makh": row[2]}

                cur.execute("SELECT * FROM V_MONHOCTABLE")
                mon_rows = cur.fetchall()

                for row in mon_rows:
                    mon[row[0]] = {"mamon": row[0], "tenmh": row[1]}

                cur.execute("SELECT * FROM V_GVDKTABLE")
                dangky_rows = cur.fetchall()

                for row in dangky_rows:
                    dangky_object = Dangky(gv=gv[row[0]], monhoc=mon[row[1]], lop=lop[row[2]], trinhdo=row[3],
                                           ngaythi=row[4], lan=row[5], socauthi=row[6], thoigian=row[7])
                    dangky.append(dangky_object)

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"dangky": dangky, "thongtin": info,
               "mon": mon, "gv": gv, "lop": lop}
    return render(request, 'base/dangkythi.html', context)


def dangky_table_gv(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    mon = {}
    lop = {}
    dangky = []
    input_mon = []
    input_lop = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))
        with db.connect_to_database() as con:
            with con.cursor() as cur:
                cur.execute("SELECT * FROM V_MONHOCTABLE")
                mon_rows = cur.fetchall()

                for row in mon_rows:
                    mon[row[0]] = {"mamon": row[0], "tenmh": row[1]}

                cur.execute("SELECT * FROM V_LOPTABLE")
                lop_rows = cur.fetchall()

                for row in lop_rows:
                    lop[row[0]] = {"malop": row[0],
                                   "tenlop": row[1], "makh": row[2]}

                magv = request.session.get("current_info")[0]
                tengv = request.session.get("current_info")[1]
                gv = {magv: {"magv": magv, "tengv": tengv}}

                cur.execute(f"EXEC SP_LayDangKyTheoMAGV '{magv}'")
                dangky_rows = cur.fetchall()

                for row in dangky_rows:
                    dangky_object = Dangky(gv=gv[magv], monhoc=mon[row[1]], lop=lop[row[2]], trinhdo=row[3],
                                           ngaythi=row[4], lan=row[5], socauthi=row[6], thoigian=row[7])
                    input_mon.append(mon[row[1]]["tenmh"])
                    input_lop.append(lop[row[2]]["tenlop"])
                    dangky.append(dangky_object)

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    input_mon = list(dict.fromkeys(input_mon))
    input_lop = list(dict.fromkeys(input_lop))

    info = request.session.get('current_info')

    context = {"dangky": dangky, "thongtin": info, "lop": lop,
               "mon": mon, "input_mon": input_mon, "input_lop": input_lop}
    return render(request, 'base/dangkythi.html', context)


def dangky_table_sv(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    mon = {}
    lop = {}
    gv = {}
    dangky = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE,
                           login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:

                cur.execute("SELECT * FROM V_MONHOCTABLE")
                mon_rows = cur.fetchall()

                for row in mon_rows:
                    mon[row[0]] = {"mamon": row[0], "tenmh": row[1]}

                cur.execute("SELECT * FROM V_LOPTABLE")
                lop_rows = cur.fetchall()

                for row in lop_rows:
                    lop[row[0]] = {"malop": row[0],
                                   "tenlop": row[1], "makh": row[2]}

                cur.execute("SELECT * FROM V_GIAOVIENTABLE")
                gv_rows = cur.fetchall()

                for row in gv_rows:
                    gv[row[0]] = {"magv": row[0], "ho": row[1],
                                  "ten": row[2], "diachi": row[3], "makh": row[4]}

                masv = request.session.get("current_info")[0]

                cur.execute(f"EXEC SP_LayDangKyTheoMASV '{masv}'")
                dangky_rows = cur.fetchall()

                for row in dangky_rows:
                    dangky_object = DangkySV(gv=gv[row[0]], monhoc=mon[row[1]], lop=lop[row[2]], trinhdo=row[3],
                                        ngaythi=row[4], lan=row[5], socauthi=row[6], thoigian=row[7], mabt=row[8])
                    dangky.append(dangky_object)

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"dangky": dangky, "thongtin": info}
    return render(request, 'base/dangkythi.html', context)


def dathi_table_sv(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    mon = {}
    dangky = []

    try:
        db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))

        with db.connect_to_database() as con:
            with con.cursor() as cur:

                cur.execute("SELECT * FROM V_MONHOCTABLE")
                mon_rows = cur.fetchall()

                for row in mon_rows:
                    mon[row[0]] = {"mamon": row[0], "tenmh": row[1]}

                masv = request.session.get("current_info")[0]

                cur.execute(f"EXEC SP_LayDangKyDaThiTheoMaSV '{masv}'")
                dangky_rows = cur.fetchall()

                for row in dangky_rows:
                    dangky_object = Dotthi(monhoc=mon[row[0]], trinhdo=row[1], lan=row[2],
                                           ngaythi=row[3], diem=row[4], mabt=row[5])
                    dangky.append(dangky_object)

    except pyodbc.Error as e:
        return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)

    info = request.session.get('current_info')

    context = {"dangky": dangky, "thongtin": info}
    return render(request, 'base/baithi.html', context)
