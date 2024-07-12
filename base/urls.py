from django.urls import path
from . import views
from . import features

urlpatterns = [
    # Login - Register
    path('', views.login_register, name='login-register'),
    path('login/lsv', features.login_sv, name='login-sv'),
    path('login/lgv', features.login_gv, name='login-gv'),
    path('register-sv', features.register_sv, name='register-sv'),
    path('register-truong', features.register_truong, name='register-truong'),
    path('register-coso', features.register_coso, name='register-coso'),
    path('register-giangvien', features.register_giangvien, name='register-giangvien'),

    path('list-question', features.get_list_questions, name='list-question'),
    path('update-answer', features.update_answer, name='update-answer'),
    path('update-time', features.update_time, name='update-time'),
    path('exam-result', features.set_score, name='exam-result'),
    path('review-result', features.review_result, name='review-result'),

    path('report-score', features.exam_scores_list, name='report-score'),
    path('report-registration', features.exam_registration_list, name='report-registration'),

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
    path('dathi/', views.dathi_table_sv, name='dathi'),

    # Tính năng của Coso
    path('add_khoa/', features.add_Khoa, name='add-khoa'),
    path('update_khoa/', features.update_Khoa, name='update-khoa'),
    path('delete_khoa/', features.delete_Khoa, name='delete-khoa'),
    path('undo_khoa/', features.undo_Khoa, name='undo-khoa'),

    path('add_lop/', features.add_Lop, name='add-lop'),
    path('update_lop/', features.update_Lop, name='update-lop'),
    path('delete_lop/', features.delete_Lop, name='delete-lop'),

    path('add_gv/', features.add_Giangvien, name='add-gv'),
    path('update_gv/', features.update_Giangvien, name='update-gv'),
    path('delete_gv/', features.delete_Giangvien, name='delete-gv'),

    path('add_sinhvien/', features.add_Sinhvien, name='add-sinhvien'),
    path('update_sinhvien/', features.update_Sinhvien, name='update-sinhvien'),
    path('delete_sinhvien/', features.delete_Sinhvien, name='delete-sinhvien'),

    path('add_monhoc/', features.add_Monhoc, name='add-monhoc'),
    path('update_monhoc/', features.update_Monhoc, name='update-monhoc'),
    path('delete_monhoc/', features.delete_Monhoc, name='delete-monhoc'),

    path('add_bode/', features.add_Bode, name='add-bode'),
    path('update_bode/', features.update_Bode, name='update-bode'),
    path('delete_bode/', features.delete_Bode, name='delete-bode'),

    path('add_dangkythi/', features.add_Dangky, name='add-dangkythi'),
    path('delete_dangkythi/', features.delete_Dangky, name='delete-dangkythi'),
    path('ds-cauhoithithu', features.ds_cauhoithithu, name='ds-cauhoithithu'),
]