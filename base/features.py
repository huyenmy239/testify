from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import HttpResponse
from django.db import connection, connections
from django.views.decorators.csrf import csrf_exempt
from .models import *
from .views import DATABASE, DB_CONNECTION
import json

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
            request.session['current_user'] = {"username": "lvt", "password": "239003"}

        except pyodbc.Error as e:
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
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
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
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
        else:
            db_alias = DB_CONNECTION["servers"][2]

        request.session['current_server'] = db_alias
        print(f"Current: {request.session.get('current_server')}")
        
        username = request.POST.get('giangvienUsername')
        password = request.POST.get('giangvienPassword')

        con, cur = None, None

        try:
            db = DatabaseModel(server=request.session['current_server'], database=DATABASE, login=username, pw=password)
            con = db.connect_to_database()
            if not con:
                messages.error(request, "Sai thông tin đăng nhập hoặc mật khẩu.")
                return redirect("login-register")
            
            cur = con.cursor()
            cur.execute(f"EXEC SP_LayThongTinGiangVien '{username}'")
            result = cur.fetchall()[0]
            print(f"Result: {result}")

            request.session['current_info'] = [result[0], result[1], result[2]]
            request.session['current_user'] = {"username": username, "password": password}

            if result[2] == "Truong":
                request.session["base_template"] = "main_Truong.html"
            elif result[2] == "Coso":
                request.session["base_template"] = "main_CS.html"
            else:
                request.session["base_template"] = "main_GV.html"
                return redirect("cauhoi")


        except pyodbc.Error as e:
            print(f"Error connecting to database: {e}")
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        return redirect("coso")

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect("login-register")


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