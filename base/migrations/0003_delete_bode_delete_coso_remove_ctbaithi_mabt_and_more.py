# Generated by Django 4.2.13 on 2024-07-10 03:48

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('base', '0002_delete_msdynamicsnapshotjobs_and_more'),
    ]

    operations = [
        migrations.DeleteModel(
            name='Bode',
        ),
        migrations.DeleteModel(
            name='Coso',
        ),
        migrations.RemoveField(
            model_name='ctbaithi',
            name='mabt',
        ),
        migrations.DeleteModel(
            name='Giaovien',
        ),
        migrations.RemoveField(
            model_name='giaoviendangky',
            name='mamh',
        ),
        migrations.DeleteModel(
            name='Khoa',
        ),
        migrations.DeleteModel(
            name='Lop',
        ),
        migrations.DeleteModel(
            name='Sinhvien',
        ),
        migrations.DeleteModel(
            name='Baithi',
        ),
        migrations.DeleteModel(
            name='CtBaithi',
        ),
        migrations.DeleteModel(
            name='GiaovienDangky',
        ),
        migrations.DeleteModel(
            name='Monhoc',
        ),
    ]