# [Create Linked Servers](#create-linked-servers)

### Chuẩn bị: [Hướng dẫn tạo login](../Create-Login/README.md)

Tạo một login tại server remote(Server muốn link tới) với:

- **[Login](#login)<a id="login"></a>**: HTKN

- **[Password](#password)<a id="password"></a>**: 12345

### Create Link server

1. Mở server để link -> mở rộng `Server Objects` -> chuột phải vào thư mục `Linked Servers` -> chọn `New Linked Servers`.

    ![alt text](./imgs/image-1.png)

2. Ô `Linked serve`” nhập tên của linked server.

3. Server type:
    
    - Product: tên của server bạn muốn link tới.
    
    - Data source: tên của server bạn muốn link tới.

        ![alt text](./imgs/image-2.png)

4. Chuyển sang tab `Security`. Chọn `Be made using this security context`.

    - Remote login: [Login đã tạo ở trên](#login)

    - With Password: [Password đã tạo ở trên](#password)

    ![alt text](./imgs/image-3.png)

5. Chọn OK.