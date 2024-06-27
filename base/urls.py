from django.urls import path
from . import views
from . import features

urlpatterns = [
    path('login/', views.login_register, name='login-register'),
    path('login/lsv', features.login_sv, name='login-sv'),
    path('login/lgv', features.login_gv, name='login-gv'),
    path('login/rgv', features.register_sv, name='register-sv'),
    path('', views.coso_table, name='coso'),
    path('khoa/', views.khoa_table, name='khoa'),
    path('lop/', views.lop_table, name='lop'),
    path('giangvien/', views.gv_table, name='giangvien'),
    path('sinhvien/', views.sv_table, name='sinhvien'),
    path('monhoc/', views.mon_table, name='monhoc'),
    path('bode/', views.bode_table, name='bode'),
    path('cauhoi/', views.bode_table_gv, name='cauhoi'),
    path('dangkythi/', views.dangky_table, name='dangkythi'),
    path('dangkythi_gv/', views.dangky_table_gv, name='dangkythi-gv'),
    path('danhsachthi/', views.dangky_table_sv, name='danhsachthi'),
]