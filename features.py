from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import HttpResponse
from django.db import connection, connections
from .models import *
from .views import DATABASE, DB_CONNECTION

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
            db = DatabaseModel(server=request.session['current_server'], database=DATABASE, login="sa", pw="239003")
            con = db.connect_to_database()
            cur = con.cursor()
            cur.execute(f"EXEC SP_LayThongTinSinhVien '{username}', '{password}'")
            result = cur.fetchall()[0]
            print(f"Result: {result}")
            if result[0] == -1:
                messages.error(request, "Sai thông tin đăng nhập hoặc mật khẩu.")
                return redirect("login-register")  
            request.session['current_info'] = [result[0], result[1], result[2]]

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

        res = ""

        cur, con = None, None
        try:
            db = DatabaseModel(server=db_alias, database=DATABASE, login="sa", pw="239003")
            con = db.connect_to_database()
            cur = con.cursor()
            cur.execute(f"EXEC SP_SinhVienDangKy '{username}', '{password}'")
            # cur.execute(f"UPDATE SINHVIEN SET PASSWORD = '{password}' WHERE MASV = '{username}'")
            con.commit()
            result = cur.fetchall()[0]
            res = result
            if result[0] == -1:
                messages.error(request, f"{result[1]}")
                return redirect("login-register")            

        except pyodbc.Error as e:
            print(f"Error connecting to database: {e}")
            return HttpResponse(f"Error connecting to the database.\nError: {e}", status=500)
        finally:
            if cur is not None:
                cur.close()
            if con is not None:
                con.close()

        messages.success(request, f"username: {username} | pass: {password} | coso: {sv_coso} | res: {res}")
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

            if result[2] == "Truong":
                request.session["base_template"] = "main_Truong.html"
            elif result[2] == "Coso":
                request.session["base_template"] = "main_CS.html"
            else:
                request.session["base_template"] = "main_GV.html"
                return redirect("cauhoi")

            request.session['current_info'] = [result[0], result[1], result[2]]

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