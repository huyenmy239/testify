# [Thi trắc nghiệm](#ecommerce-shop) <a id="ecommerce-shop"></a>

## [Table of Contents](#table-of-contents) <a id="table-of-contents"></a>

- [Tables of Contents](#table-of-contents)

- [Instruction](#introduction)

- [Structure](#structure)

- [Featured](#feature)

- [Prerequisites](#prerequisites)

- [Utilization](#utilization)

- [Contributors](#contributors)

- [Problems and suggestions](#problems-and-suggestions)

## [Introduction](#introduction) <a id="introduction"></a>

- Đây là đồ án cuối kì môn "Cơ sở dữ liệu phân tán" của thầy Lưu Nguyễn Kỳ Thư trường PTITHCM (Học viên Công nghệ Buu chính Viễn thông tại cơ sở tại Thành phố Hồ Chí Minh).

- Ban đầu nhóm mình làm đồ án này bằng app, nhưng có 1 số vấn đề về mặt giao diện (style cho các table, button,...) nếu làm thì khá là tốn công sức đi nghiên cứu nên nhóm mình quyết định chuyển sang dùng web.

- Mục đích:

	1. Hiểu hệ thống phân tán.
	
	2. Thiết kế Kiến trúc có thể mở rộng.
	
	3. Triển khai phân chia dữ liệu.
	

## [Structure](#structure) <a id="structure"></a>

    

## [Features](#feature) <a id="feature"></a>

- Giảng viên:

	- Thêm, xóa, cập nhật ngân hàng câu hỏi của mình.
	
	- Có thể làm trước bài kiểm tra cho kỳ thi đó nhưng không tính điểm.

- Giảng viên nắm quyền cơ sở:

	- Quản lý thông tin giảng viên, nhân viên, sinh viên, lịch thi,... tại cơ sở tương ứng.
	
	- Tạo báo cáo danh sách điểm của sinh viên, danh sách đăng ký thi theo một khoảng thời gian.
	
- Giảng viên thuộc quyền trường:

	- Theo dõi, tạo báo cáo của của cả 2 cơ sở.
	
	- Được xem các thông tin như khoa, lớp, trường... nhưng không thể thao tác với dữ liệu đó.

- Sinh viên:

	- Xem danh sách các bài thi chưa thi, đã từng thi và không thi của chính mình.
	
	- Tham gia thi và được tính điểm.
	
	- Xem lại bài thi và kết quả chi tiết.

## [Prerequisites](#prerequisites) <a id="prerequisites"></a>

1. [Download SQL Server Management Studio (SSMS) 20.1](https://aka.ms/ssmsfullsetup)

2. [Download SQL Server 2022 (Deverlopber)](https://go.microsoft.com/fwlink/p/?linkid=2215158&clcid=0x409&culture=en-us&country=us)

3. [Download Python](https://www.python.org/downloads/)

## [Utilization](#utilization) <a id="utilization"></a>

1. Đầu tiên bạn cần phải đảm bảo đã tải đầy đủ các tài nguyên cần thiết [ở đây](#prerequisites).

2. Tạo database và phân tán.

3. Clone repo này về.

```bash
git clone 
cd testify
```

4. Tải các package cần thiết.

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

5. Chạy project:

```bash
python manage.py runserver
```

## [Contributors](#contributors) <a id="contributors"></a>

<table>
    <tr>
        <th>Name</th>
        <th>Avatar</th>
        <th>Link Github</th>
        <th>Effect</th>
    </tr>
    <tr>
        <td>Nguyễn Thị Huyền My</td>
        <td><img title="huyenmy239-avatar" style="width:30pt; height: auto; align:center; border:solid" src="https://avatars.githubusercontent.com/u/92309591?v=4"/></td>
        <td><a href="https://github.com/huyenmy239">huyenmy239</a></td>
        <td>
            <ul>
            </ul>
        </td>
    </tr>
    <tr>
        <td>Vũ Thị Thanh Thùy</td>
        <td><img title="thanhthuyne2211-avatar" style="width:30pt; height: auto; align:center; border:solid" src="https://avatars.githubusercontent.com/u/120545208?v=4"/></td>
        <td><a href="https://github.com/thanhthuyne2211">thanhthuyne2211</a></td>
        <td>
            <ul>
            </ul>
        </td>
    </tr>
    <tr>
        <td>Nguyễn Tấn Nguyên</td>
        <td><img title="KonstanNguyen-avatar" style="width:30pt; height: auto; align:center; border:solid" src="https://avatars.githubusercontent.com/u/106095525?v=4"/></td>
        <td><a href="https://github.com/KonstanNguyen">KonstanNguyen</a></td>
        <td>
            <ul>
            </ul>
        </td>
    </tr>
</table>

## [Problems and suggestions](#problems-and-suggestions) <a id="problems-and-suggestions"></a>

- Problems:

	- Python nói chung và Django nói riêng hỗ trợ khá tốt ở các database khác nhưng về SQL Server thì có phần hơi hạn chế nên cần phải cân nhắc.
	
	- Django không phù hợp với Cơ sở dữ liệu phân tán trên SQL Server. Vì Django ORM khi ánh xạ với các bảng và khi connect với một server phân mảnh
	thì lúc truy vấn, dữ liệu sẽ ưu tiên trả về dữ liệu ở server gốc.
	
	- Database ban đầu của thầy gửi cho tụi mình có thiếu một số bảng (table) và một vài trường (field) gây ra việc có vài tính năng không thể xử lý được.
	
- Suggestions:

	- Nhóm mình dùng pyodbc để connect với server thay thế cho việc configure DATABASE sẵn có trong file `settings.py` của Django. Tự tạo model thay vì dùng
	Django ORM để ánh xạ với các bảng trong Cơ sở dữ liệu.
	
	- Cân nhắc bổ sung field, xóa, thay đổi cho thích hợp với nhu cầu của bạn. Đây là 1 số thay đổi của nhóm mình:
	
		- Thêm bảng CT_BAITHI(MABT, CAUHOI, TRALOI).
		
		- Thêm field TGCL (thời gian còn lại) vào bảng BAITHI.
		
		- Ngoài ra bạn có thể cân nhắc về việc thay đổi kiểu dữ liệu của MABT(ở bảng BAITHI). Nhưng vì nhóm đã phân tán xong
		nên việc thay đổi rất khó khăn nên nhóm vẫn quyết định giữ lại một số thứ, chi tiết bạn có thể xem file đã phân tán [tại đây]().
		