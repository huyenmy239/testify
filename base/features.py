from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import HttpResponse
from django.db import connection, connections
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

    if request.method == 'POST':
        cauhoi = ""
        mamh = request.POST.get('addMonhoc').strip().upper()
        print(f"Mã môn học: {mamh}")
        trinhdo = request.POST.get('addTrinhdo').strip().upper()
        noidung = request.POST.get('addNoidung').strip().capitalize()
        a = request.POST.get('addA').strip().capitalize()
        b = request.POST.get('addB').strip().capitalize()
        c = request.POST.get('addC').strip().capitalize()
        d = request.POST.get('addD').strip().capitalize()
        dapan = request.POST.get('addDapan').strip().upper()
        magv = request.POST.get('addGiaovien').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()

            cur.execute("EXEC SP_TaoMaCauHoi")
            cauhoi = int(cur.fetchone()[0])

            query = f"EXEC SP_INSERT_BODE '{cauhoi}', '{mamh}', N'{trinhdo}', N'{noidung}', N'{a}', N'{b}', N'{c}', N'{d}', N'{dapan}', '{magv}'"
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

        return redirect('bode')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('bode')


@csrf_exempt
def update_Bode(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

    if request.method == 'POST':
        cauhoi = request.POST.get('editCauhoi').strip().upper()
        trinhdo = request.POST.get('addTrinhdo').strip().upper()
        noidung = request.POST.get('addNoidung').strip().capitalize()
        a = request.POST.get('addA').strip().capitalize()
        b = request.POST.get('addB').strip().capitalize()
        c = request.POST.get('addC').strip().capitalize()
        d = request.POST.get('addD').strip().capitalize()
        dapan = request.POST.get('addDapan').strip().upper()

        con, cur = None, None

        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login=login.get('username'), pw=login.get('password'))
            con = db.connect_to_database()
            cur = con.cursor()
            query = f"EXEC SP_UPDATE_BODE '{cauhoi}', '{trinhdo}', '{noidung}', '{a}', '{b}', '{c}', '{d}', '{dapan}'"
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

        return redirect('bode')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('bode')


@csrf_exempt
def delete_Bode(request):
    db_alias = request.session.get('current_server')
    login = request.session.get('current_user')

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

        return redirect('bode')

    messages.error(request, "Yêu cầu không hợp lệ.")
    return redirect('bode')































def get_list_questions(request):
    if request.method == 'POST':
        coso = request.POST.get('sv_coso')
        if "1" in coso:
            db_alias = DB_CONNECTION["servers"][1]
        else:
            db_alias = DB_CONNECTION["servers"][2]

        request.session['current_server'] = db_alias
        print(f"Current: {request.session.get('current_server')}")
        
        ma_sv = request.POST.get('MaSV')
        ma_mh = request.POST.get('mamh')
        lan = request.POST.get('lan')
        trinh_do = request.POST.get('trinhdo')
        so_cau = request.POST.get('socau')
        cur, con = None, None
        try:
            print("do something here")
            db = DatabaseModel(server=request.session['current_server'], database=DATABASE, login="sa", pw="239003")
            con = db.connect_to_database()
            cur = con.cursor()
            cur.execute(f"EXEC SP_THONG_TIN_BAI_THI '{ma_sv}', '{ma_mh}', '{lan}'")
            result = cur.fetchone()
            if result is None:
                now = datetime.now()
                current_date_time = now.strftime('%Y-%m-%d')
                mabt = 'test'
                cur.execute(f"EXEC SP_TAO_BAI_THI '{mabt}', '{ma_sv}', '{ma_mh}', '{lan}', \"{current_date_time}\", '{trinh_do}', {so_cau}")
            
            cur.execute(f"EXEC SP_LAY_CAU_HOI '{mabt}'")
            result = cur.fetchall()
        except pyodbc.Error as e:
            print(f"Error connecting to database: {e}")
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        context = {"questions": result, "time": time} #Lay them time tu sp
        return render(request, 'base/dangkythi.html', context)

def update_time(request):
    if request.method == 'POST':
        coso = request.POST.get('sv_coso')
        if "1" in coso:
            db_alias = DB_CONNECTION["servers"][1]
        else:
            db_alias = DB_CONNECTION["servers"][2]
            
        request.session['current_server'] = db_alias
        print(f"Current: {request.session.get('current_server')}")

        maBT = request.POST.get('maBT')
        timer = request.POST.get('time')
        
        cur, con = None, None
        try:
            db = DatabaseModel(server=request.session['current_server'], database=DATABASE, login="sa", pw="239003")
            con = db.connect_to_database()
            cur = con.cursor()
            cur.execute(f"EXEC SP_UPDATE_TIME '{maBT}', \"{timer}\"")
        except pyodbc.Error as e:
            print(f"Error connecting to database: {e}")
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()
        HttpResponse("Update left time successfully!")
                
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