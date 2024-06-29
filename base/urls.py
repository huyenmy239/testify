from django.urls import path
from . import views
from . import features

urlpatterns = [
    # Login - Register
    path('', views.login_register, name='login-register'),
    path('login/lsv', features.login_sv, name='login-sv'),
    path('login/lgv', features.login_gv, name='login-gv'),
    path('login/rgv', features.register_sv, name='register-sv'),

    path('coso/', views.coso_table, name='coso'),
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

    # Tính năng của role Coso
    path('add_khoa/', features.add_Khoa, name='add-khoa'),
    path('update_khoa/', features.update_Khoa, name='update-khoa'),
    path('delete_khoa/', features.delete_Khoa, name='delete-khoa'),

    path('add_lop/', features.add_Lop, name='add-lop'),
    path('update_lop/', features.update_Lop, name='update-lop'),
    path('delete_lop/', features.delete_Lop, name='delete-lop'),

    path('add_gv/', features.add_Giangvien, name='add-gv'),
    path('update_gv/', features.update_Giangvien, name='update-gv'),
    path('delete_gv/', features.delete_Giangvien, name='delete-gv'),

    path('add_sinhvien/', features.add_Sinhvien, name='add-sinhvien'),
    path('update_sinhvien/', features.update_Sinhvien, name='update-sinhvien'),
    path('delete_sinhvien/', features.delete_Sinhvien, name='delete-sinhvien'),
]