# Cách chạy

**Máy cần có:** Visual Studio với **ASP.NET and web development**, .NET Framework 4.7.2 Developer Pack và SQL Server.

1. Trong SSMS: chuột phải tên máy chủ → **Properties → Security → SQL Server and Windows Authentication mode → OK**. Chuột phải máy chủ → **Restart**. Chỉ cần làm một lần; máy chủ dùng chung cần người quản lý thực hiện.
2. Tải và giải nén dự án vào đường dẫn ngắn, ví dụ `D:\Health`.
3. Mở thư mục có `KhoiTao.ps1`, gõ `powershell` vào thanh địa chỉ, nhấn Enter rồi chạy:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\KhoiTao.ps1 -SqlServer '.\SQLEXPRESS'
   ```

   Đổi `.\SQLEXPRESS` theo tên SQL Server của máy. Nếu database của dự án đã có, thêm `-SuDungDuLieuHienCo` vào cuối lệnh.
4. Mở `Nhom05_Health_Fitness.sln` bằng Visual Studio. Nếu thiếu gói, chuột phải Solution → **Restore NuGet Packages**.
5. Nhấn **F5**, mở `/Account/Login` trên website vừa chạy. Đăng nhập mẫu: **`phamgiabao` / `123456`**.

**Lần sau:** chỉ mở `.sln` rồi F5. Giữ tệp `Database.Local.config` đã tạo. Dữ liệu đi kèm là dữ liệu mẫu; không tự nạp đè database đang dùng.