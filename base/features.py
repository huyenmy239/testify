from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import HttpResponse
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import *
from .views import DATABASE, DB_CONNECTION
from datetime import datetime

db_alias = "default"

def login_sv(request):
    if request.method == 'POST':
        coso = request.POST.get('sv_coso')
        if "1" in coso:
            db_alias = DB_CONNECTION["servers"][1]
        else:
            db_alias = DB_CONNECTION["servers"][2]

        request.session['current_server'] = db_alias
        print(f"Current: {request.session.get('current_server')}")
        
        username = request.POST.get('sinhvienUsername')
        password = request.POST.get('sinhvienPassword')

        cur, con = None, None
        try:
            db = DatabaseModel(server=request.session['current_server'], database=DATABASE, login="lvt", pw="239003")
            con = db.connect_to_database()
            cur = con.cursor()
            cur.execute("EXEC SP_LayThongTinSinhVien ?, ?", (username, password))
            result = cur.fetchall()[0]
            print(f"Result: {result}")
            if result[0] == -1:
                messages.error(request, "Sai thông tin đăng nhập hoặc mật khẩu.")
                return redirect("login-register")  
            request.session['current_info'] = [result[0], result[1], result[2]]
            request.session['current_user'] = {"username": "lvt", "password": "239003", "role": "sinhvien"}

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
            return redirect("login-register")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        request.session["base_template"] = "main_SV.html"
        return redirect("danhsachthi")

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect("login-register")


def register_sv(request):
    if request.method == 'POST':

        print(f"Current: {request.session.get('current_server')}")
        
        temp_username = request.POST.get('masinhvien').split("|")

        username = temp_username[0].strip()
        sv_coso = temp_username[1].strip()
        print(f"Coso: {sv_coso} user: {username}")
        password = request.POST.get('dangkyPassword')

        if "1" in sv_coso:
            db_alias = DB_CONNECTION["servers"][1]
        else:
            db_alias = DB_CONNECTION["servers"][2]

        request.session['current_server'] = db_alias

        cur, con = None, None
        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login="lvt", pw="239003")
            con = db.connect_to_database()
            cur = con.cursor()
            cur.execute("EXEC SP_SinhVienDangKy ?, ?", (username, password))
            con.commit()          

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
            return redirect("login-register")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        messages.success(request, "Đăng ký thành công.")
        return redirect("login-register")

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect("login-register")


def login_gv(request):
    if request.method == 'POST':
        coso = request.POST.get('gv_coso')
        if "1" in coso:
            db_alias = DB_CONNECTION["servers"][1]
            cur_sv = DB_CONNECTION["servers"][1]
            next_sv = DB_CONNECTION["servers"][2]
        else:
            db_alias = DB_CONNECTION["servers"][2]
            cur_sv = DB_CONNECTION["servers"][2]
            next_sv = DB_CONNECTION["servers"][1]

        request.session['current_server'] = db_alias
        
        username = request.POST.get('giangvienUsername')
        password = request.POST.get('giangvienPassword')

        con, cur = None, None

        result = ""
        gv_list = {}

        try:
            db = DatabaseModel(server=cur_sv, database=DATABASE, login=username, pw=password)
            con = db.connect_to_database()
            if not con:
                messages.error(request, "Sai thông tin đăng nhập hoặc mật khẩu.")
                return redirect("login-register")
            
            cur = con.cursor()
            cur.execute(f"EXEC SP_LayThongTinGiangVien '{username}'")
            result = cur.fetchall()[0]

            if result[2] == "Truong" or result[2] == "Coso":
                cur.execute(f"SELECT * FROM V_DanhSachGVChuaCoUsername")
                gv_rows = cur.fetchall()
                gv_list_cur = {}
                for row in gv_rows:
                    gv_list_cur[row[0]] = {"magv": row[0], "tengv": f"{row[1]} {row[2]}"}

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
            return redirect("login-register")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        if result[2] == "Truong":

            try:
                db = DatabaseModel(server=next_sv, database=DATABASE, login=username, pw=password)
                con = db.connect_to_database()
                cur = con.cursor()

                cur.execute(f"SELECT * FROM V_DanhSachGVChuaCoUsername")
                gv_rows = cur.fetchall()
                gv_list_next = {}
                for row in gv_rows:
                    gv_list_next[row[0]] = {"magv": row[0], "tengv": f"{row[1]} {row[2]}"}

            except pyodbc.Error as e:
                messages.error(request, e.__str__().split("]")[4].split("(")[0])
                return redirect("login-register")
            finally:
                if cur is not None:
                    cur.close()
                if con is not None:
                    con.close()

            gv_list = {k: gv_list_cur[k] for k in gv_list_cur if k in gv_list_next and gv_list_cur[k] == gv_list_next[k]}
        elif result[2] == "Coso":
            gv_list = gv_list_cur
        request.session['current_info'] = [result[0], result[1], result[2]]
        request.session['current_user'] = {"username": username, "password": password, "role": ""}

        if result[2] == "Truong":
            request.session["base_template"] = "main_Truong.html"
            request.session['current_user']['role'] = "truong"
        elif result[2] == "Coso":
            request.session["base_template"] = "main_CS.html"
            request.session['current_user']['role'] = "coso"
        else:
            request.session["base_template"] = "main_GV.html"
            request.session['current_user']['role'] = "giangvien"
            return redirect("cauhoi")

        request.session['gv_list'] = gv_list
        return redirect("coso")

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect("login-register")


def register_truong(request):
    login = request.session.get('current_user')
    if request.method == 'POST':
        
        username = request.POST.get('username')
        password = request.POST.get('password')
        magv = request.POST.get('magv').split('-')[0].strip().upper()
        tengv = request.POST.get('magv').split('-')[1].strip().upper()

        role = "Truong"

        con, cur = None, None

        # Tạo login ở server 1
        try:
            db = DatabaseModel(server=DB_CONNECTION["servers"][1], database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            
            cur = con.cursor()
            query = f"EXEC SP_TaoTaiKhoan '{username}', '{password}', '{magv}', '{role}'"
            cur.execute(query)
            con.commit()

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
            return redirect("coso")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        # Tạo login ở server 2
        try:
            db = DatabaseModel(server=DB_CONNECTION["servers"][2], database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            
            cur = con.cursor()
            query = f"EXEC SP_TaoTaiKhoan '{username}', '{password}', '{magv}', '{role}'"
            cur.execute(query)
            con.commit()

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
            return redirect("coso")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        
        messages.success(request, f"Tạo tài khoản cho Giảng viên {tengv} với vai trò 'Trường' thành công.")
        
        # Xóa item trong Ds Giảng viên chưa có login
        del_key = {}
        for key, val in request.session['gv_list'].items():
            if magv in key:
                print(f"{key}: {val}")
                del_key = key
                break
        request.session['gv_list'].pop(del_key)
        request.session.modified = True

        return redirect("coso")

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect("coso")


def register_coso(request):
    login = request.session.get('current_user')
    db_alias = request.session.get('current_server')
    if request.method == 'POST':
        
        username = request.POST.get('username')
        password = request.POST.get('password')
        magv = request.POST.get('magv').split('-')[0].strip().upper()
        tengv = request.POST.get('magv').split('-')[1].strip().upper()

        role = "Coso"

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            
            cur = con.cursor()
            query = f"EXEC SP_TaoTaiKhoan '{username}', '{password}', '{magv}', '{role}'"
            cur.execute(query)
            con.commit()

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
            return redirect("coso")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        
        messages.success(request, f"Tạo tài khoản cho Giảng viên {tengv} với vai trò 'Cơ sở' thành công.")

        del_key = {}
        for key, val in request.session['gv_list'].items():
            if magv in key:
                print(f"{key}: {val}")
                del_key = key
                break
        request.session['gv_list'].pop(del_key)
        request.session.modified = True

        return redirect("coso")

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect("coso")


def register_giangvien(request):
    login = request.session.get('current_user')
    db_alias = request.session.get('current_server')
    if request.method == 'POST':
        
        username = request.POST.get('username')
        password = request.POST.get('password')
        magv = request.POST.get('magv').split('-')[0].strip().upper()
        tengv = request.POST.get('magv').split('-')[1].strip().upper()

        role = "Giangvien"

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            
            cur = con.cursor()
            query = f"EXEC SP_TaoTaiKhoan '{username}', '{password}', '{magv}', '{role}'"
            cur.execute(query)
            con.commit()

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
            return redirect("coso")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        
        messages.success(request, f"Tạo tài khoản cho Giảng viên {tengv} với vai trò 'Giảng viên' thành công.")

        del_key = {}
        for key, val in request.session['gv_list'].items():
            if magv in key:
                print(f"{key}: {val}")
                del_key = key
                break
        request.session['gv_list'].pop(del_key)
        request.session.modified = True

        return redirect("coso")

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect("coso")


@csrf_exempt
def add_Khoa(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        makh = request.POST.get('addMakh').strip().upper()
        tenkh = request.POST.get('addTenkh').strip().title()

        if "1" in db_alias:
            coso = "CS1"
        else:
            coso = "CS2"

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_INSERT_KHOA '{makh}', N'{tenkh}', '{coso}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thêm Khoa thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('khoa')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('khoa')


@csrf_exempt
def update_Khoa(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        makh = request.POST.get('editMakh').strip().upper()
        tenkh = request.POST.get('editTenkh').strip().title()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_UPDATE_KHOA '{makh}', N'{tenkh}'"
            print(f"Query: {query}")
            cur.execute(query)
            con.commit()

            messages.success(request, "Thay đổi thông tin Khoa thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('khoa')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('khoa')


@csrf_exempt
def delete_Khoa(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        makh = request.POST.get('deleteMakh').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_DELETE_KHOA '{makh}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Xóa Khoa thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('khoa')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('khoa')


@csrf_exempt
def add_Lop(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        malop = request.POST.get('addMalop').strip().upper()
        tenlop = request.POST.get('addTenlop').strip().title()
        makh = request.POST.get('addKhoa')

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_INSERT_LOP '{malop}', N'{tenlop}', '{makh}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thêm Lớp thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('lop')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('lop')


def update_Lop(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        malop = request.POST.get('editMalop').strip().upper()
        tenlop = request.POST.get('editTenlop').strip().title()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_UPDATE_LOP '{malop}', N'{tenlop}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thay đổi thông tin Lớp thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('lop')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('lop')


def delete_Lop(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        malop = request.POST.get('deleteMalop').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_DELETE_LOP '{malop}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Xóa Lớp thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('lop')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('lop')


@csrf_exempt
def add_Giangvien(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        magv = request.POST.get('addMagv').strip().upper()
        ho = request.POST.get('addHo').strip().upper()
        ten = request.POST.get('addTen').strip().upper()
        diachi = request.POST.get('addDiachi').strip().title()
        makh = request.POST.get('addKhoa')

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_INSERT_GIAOVIEN '{magv}', N'{ho}', N'{ten}', N'{diachi}', '{makh}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thêm Giảng viên thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('giangvien')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('giangvien')


@csrf_exempt
def update_Giangvien(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        magv = request.POST.get('editMagv').strip().upper()
        ho = request.POST.get('editHo').strip().upper()
        ten = request.POST.get('editTen').strip().upper()
        diachi = request.POST.get('editDiachi').strip().title()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_UPDATE_GIAOVIEN '{magv}', N'{ho}', N'{ten}', N'{diachi}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thay đổi thông tin Giảng viên thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('giangvien')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('giangvien')


@csrf_exempt
def delete_Giangvien(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        magv = request.POST.get('deleteMagv').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_DELETE_GIAOVIEN '{magv}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Xóa Giảng viên thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('giangvien')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('giangvien')


@csrf_exempt
def add_Sinhvien(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        masv = request.POST.get('addMasv').strip().upper()
        ho = request.POST.get('addHo').strip().upper()
        ten = request.POST.get('addTen').strip().upper()
        ngaysinh = request.POST.get('addNgaysinh')
        diachi = request.POST.get('addDiachi').strip().title()
        malop = request.POST.get('addLop')

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_INSERT_SINHVIEN '{masv}', N'{ho}', N'{ten}', '{ngaysinh}', N'{diachi}', '{malop}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thêm Sinh viên thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('sinhvien')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('sinhvien')


@csrf_exempt
def update_Sinhvien(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        masv = request.POST.get('editMasv').strip()
        ho = request.POST.get('editHo').strip().upper()
        ten = request.POST.get('editTen').strip().upper()
        ngaysinh = request.POST.get('editNgaysinh')
        diachi = request.POST.get('editDiachi').strip().title()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_UPDATE_SINHVIEN '{masv}', N'{ho}', N'{ten}', '{ngaysinh}', N'{diachi}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thay đổi thông tin Sinh viên thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('sinhvien')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('sinhvien')


@csrf_exempt
def delete_Sinhvien(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        masv = request.POST.get('deleteMasv').strip()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_DELETE_SINHVIEN '{masv}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Xóa Sinh viên thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('sinhvien')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('sinhvien')


@csrf_exempt
def add_Monhoc(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        mamh = request.POST.get('addMamh').strip().upper()
        tenmh = request.POST.get('addTenmh').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_INSERT_MONHOC '{mamh}', N'{tenmh}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thêm Môn học thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('monhoc')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('monhoc')


@csrf_exempt
def update_Monhoc(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        mamh = request.POST.get('editMamh').strip().upper()
        tenmh = request.POST.get('editTenmh').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_UPDATE_MONHOC '{mamh}', N'{tenmh}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thay đổi thông tin Môn học thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('monhoc')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('monhoc')


@csrf_exempt
def delete_Monhoc(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        mamh = request.POST.get('deleteMamh').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_DELETE_MONHOC '{mamh}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Xóa Môn học thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('monhoc')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('monhoc')


@csrf_exempt
def add_Bode(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')
    role = request.session.get('current_user', {}).get('role')

    if request.method == 'POST':
        mamh = request.POST.get('addMonhoc').strip().upper()
        trinhdo = request.POST.get('addTrinhdo').strip().upper()
        noidung = request.POST.get('addNoidung').strip().capitalize()
        a = request.POST.get('addA').strip().lower()
        b = request.POST.get('addB').strip().lower()
        c = request.POST.get('addC').strip().lower()
        d = request.POST.get('addD').strip().lower()
        dapan = request.POST.get('addDapan').strip().upper()

        if role == "coso":
            magv = request.POST.get('addGiaovien').strip().upper()
        else:
            magv = request.session.get('current_info')[0]

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()

            query = f"EXEC SP_INSERT_BODE '{mamh}', N'{trinhdo}', N'{noidung}', N'{a}', N'{b}', N'{c}', N'{d}', N'{dapan}', '{magv}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thêm Câu hỏi thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        
        if role == "coso":
            return redirect('bode')
        else:
            return redirect('cauhoi')
    
    return HttpResponse("Yêu cầu không hợp lệ")


@csrf_exempt
def update_Bode(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')
    role = request.session.get('current_user', {}).get('role')

    if request.method == 'POST':
        cauhoi = request.POST.get('editCauhoi').strip().upper()
        trinhdo = request.POST.get('editTrinhdo').strip().upper()
        noidung = request.POST.get('editNoidung').strip().capitalize()
        a = request.POST.get('editA').strip().lower()
        b = request.POST.get('editB').strip().lower()
        c = request.POST.get('editC').strip().lower()
        d = request.POST.get('editD').strip().lower()
        dapan = request.POST.get('editDapan').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_UPDATE_BODE '{cauhoi}', N'{trinhdo}', N'{noidung}', N'{a}', N'{b}', N'{c}', N'{d}', N'{dapan}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Thay đổi nội dung Câu hỏi thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        if role == "coso":
            return redirect('bode')
        else:
            return redirect('cauhoi')
    
    return HttpResponse("Yêu cầu không hợp lệ")


@csrf_exempt
def delete_Bode(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')
    role = request.session.get('current_user', {}).get('role')

    if request.method == 'POST':
        cauhoi = request.POST.get('deleteCauhoi').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_DELETE_BODE '{cauhoi}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Xóa Câu hỏi thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        if role == "coso":
            return redirect('bode')
        else:
            return redirect('cauhoi')
    
    return HttpResponse("Yêu cầu không hợp lệ")


@csrf_exempt
def add_Dangky(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        magv = request.POST.get('addGiangvien').strip().upper()
        mamh = request.POST.get('addMonhoc').strip().upper()
        malop = request.POST.get('addLop').strip().upper()
        trinhdo = request.POST.get('addTrinhdo').strip().upper()
        ngaythi_str = request.POST.get('addNgaythi').strip().upper()
        ngaythi = datetime.strptime(ngaythi_str, '%Y-%m-%dT%H:%M')
        socauthi = int(request.POST.get('addSocauthi').strip())
        thoigian = int(request.POST.get('addThoigian').strip())

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()

            query = f"EXEC SP_INSERT_DANGKYTHI '{magv}', '{mamh}', '{malop}', N'{trinhdo}', '{ngaythi}', '{socauthi}', '{thoigian}'"
            cur.execute(query)
            con.commit()

            messages.success(request, "Đăng ký thi thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('dangkythi')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('dangkythi')


@csrf_exempt
def delete_Dangky(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        malop = request.POST.get('deleteLop').strip().upper()
        mamh = request.POST.get('deleteMon').strip().upper()
        lan = int(request.POST.get('deleteLan').strip().upper())

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_DELETE_DANGKYTHI '{malop}', '{mamh}', {lan}"
            print(f"Query: {query}")
            cur.execute(query)
            con.commit()

            messages.success(request, "Xóa Đăng ký thành công.")

        except pyodbc.Error as e:
            messages.error(request, e.__str__().split("]")[4].split("(")[0])
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect('dangkythi')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('dangkythi')






























# import time
def get_list_questions(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        
        masv = request.POST.get('MaSV').strip()
        mamh = request.POST.get('mamh').strip()
        lan = int(request.POST.get('lan'))
        trinhdo = request.POST.get('trinhdo')
        socau = int(request.POST.get('socau'))
        cur, con = None, None
        print(f"Masv: {masv}, mamh: {mamh}, lan: {lan}, trinhdo: {trinhdo}, socau: {socau}")
        tt_baithi = {}
        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            print("Connect database thành công!")
            cur.execute(f"EXEC SP_ThongTinBaiThi '{masv}', '{mamh}', {lan}, N'{trinhdo}', {socau}")
            res = cur.fetchall()[0]
            print(f"Result sau SP_ThongTin: {res}")
            con.commit()
            tt_baithi = {"malop": res[0], "lop": res[1], "hoten": res[2], "tenmh": res[3],
                         "ngaythi": res[4], "lan": res[5], "tgcl": res[6], "mabt": res[7]}

        except pyodbc.Error as e:
            print(f"Error connecting to database: {e}")
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            cur.execute(f"EXEC SP_LayCauHoi '{tt_baithi['mabt']}'")
            res = cur.fetchall()
            
            questions = []
            for row in res:
                questions.append({"stt": row[0], "noidung": row[1], "a": row[2], "b": row[3],
                                  "c": row[4], "d": row[5], "traloi": row[6]})
                
        except pyodbc.Error as e:
            print(f"Error connecting to database: {e}")
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        print(f"Danh sách câu hỏi: {questions}")
        # context = {"questions": questions, "time": tt_baithi['tgcl']}
        return JsonResponse({"questions": questions, "time": tt_baithi['tgcl']})

def update_time(request):
    if request.method == 'POST':
        # coso = request.POST.get('sv_coso')
        # if "1" in coso:
        #     db_alias = DB_CONNECTION["servers"][1]
        # else:
        #     db_alias = DB_CONNECTION["servers"][2]
            
        # request.session['current_server'] = db_alias
        # print(f"Current: {request.session.get('current_server')}")

        # maBT = request.POST.get('maBT')
        # timer = request.POST.get('time')
        
        # cur, con = None, None
        # try:
        #     db = DatabaseModel(server=request.session['current_server'], database=DATABASE, login="sa", pw="239003")
        #     con = db.connect_to_database()
        #     cur = con.cursor()
        #     cur.execute(f"EXEC SP_UPDATE_TIME '{maBT}', \"{timer}\"")
        # except pyodbc.Error as e:
        #     print(f"Error connecting to database: {e}")
        #     return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
        # finally:
        #     if cur is not None:
        #         cur.close()
        #     if con is not None:
        #         con.close()
        # HttpResponse("Update left time successfully!")
        return JsonResponse({'test' :' test'})
                
def update_answer(request):
    if request.method == 'POST':
        coso = request.POST.get('sv_coso')
        if "1" in coso:
            db_alias = DB_CONNECTION["servers"][1]
        else:
            db_alias = DB_CONNECTION["servers"][2]
            
        request.session['current_server'] = db_alias
        print(f"Current: {request.session.get('current_server')}")

        maBT = request.POST.get('maBT')
        cau_hoi = request.POST.get('cauhoi')
        cau_tra_loi = request.POST.get('selectedOption')
        
        cur, con = None, None
        try:
            db = DatabaseModel(server=request.session['current_server'], database=DATABASE, login="sa", pw="239003")
            con = db.connect_to_database()
            cur = con.cursor()
            cur.execute(f"EXEC SP_TRA_LOI_CAU_HOI '{maBT}', '{cau_hoi}', '{cau_tra_loi}'")
        except pyodbc.Error as e:
            print(f"Error connecting to database: {e}")
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        HttpResponse("Update the answer successfully!")


def exam_scores_list(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')
    if request.method == 'POST':
        malop = request.POST.get("className")
        mamh = request.POST.get("subjectName")
        lan = request.POST.get("examAttempt")

        ds = []
        cur, con = None, None
        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_REPORT_InBangDiemMonHoc '{malop}', '{mamh}', {lan}"
            cur.execute(query)

            ds_rows = cur.fetchall()
            for row in ds_rows:
                ds.append({"masv": row[0], "hoten": row[1], "diem": row[2], "diemchu": row[3]})
            print(f"Danh sách: {ds}")

        except pyodbc.Error as e:
            # messages.error(request, e.__str__().split("]")[4].split("(")[0])
            messages.error(request, e)
            return redirect("cauhoi")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        return JsonResponse({'ds': ds})

    messages.error(request, "Yêu cầu không hợp lệ.")
    return HttpResponse(status=405)


def exam_registration_list(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')
    if request.method == 'POST':
        
        fDateStr = request.POST.get('fromDate').strip()
        tDateStr = request.POST.get('toDate').strip()
        
        from_date = datetime.strptime(fDateStr, '%Y-%m-%d').date()
        to_date = datetime.strptime(tDateStr, '%Y-%m-%d').date()
        formatted_fDate = from_date.strftime('%m/%d/%Y')
        formatted_tDate = to_date.strftime('%m/%d/%Y')
        
        cur, con = None, None
        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_REPORT_DSDangKyThi '{from_date}', '{from_date}'"
            print(f"Query: {query}")
            cur.execute(query)
            res = cur.fetchall()

            report_list = []
            for row in res:
                report_list.append({"malop": row[0], "tenlop": row[1], "mamh": row[2], "tenmh": row[3], "tengv": row[4],
                                    "socauthi": row[5], "ngaythi": row[6], "lan": row[7], "dathi": row[8], "ghichu": row[9]})

            print(f"Report: {report_list}")

        except pyodbc.Error as e:
            # messages.error(request, e.__str__().split("]")[4].split("(")[0])
            messages.error(request, e)
            return redirect("cauhoi")
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        
        response = {
            'from_date': formatted_fDate,
            'to_date': formatted_tDate,
            'report_data': report_list,
        }
        return JsonResponse(response)
    
    return JsonResponse({'error': 'Invalid request method'}, status=400)