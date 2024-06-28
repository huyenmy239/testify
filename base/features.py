from django.shortcuts import render, redirect
from django.contrib import messages
from django.http import HttpResponse
from django.db import connection, connections
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

            request.session['current_info'] = [result[0], result[1], result[2]]

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