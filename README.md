# Health & Fitness Tracking System

Website ASP.NET MVC 5 dùng .NET Framework 4.7.2, LINQ to SQL và SQL Server. Source hiện nằm trực tiếp trong kho; không cần giải nén thêm ZIP bên trong.

## Chuẩn bị một lần trên máy mới

- Cài Visual Studio với **ASP.NET and web development**, **.NET Framework 4.7.2 development tools** và IIS Express.
- Cài SQL Server/SQL Server Express. Tài khoản Windows chạy khởi tạo cần được phép tạo database và SQL login.
- Giữ cơ chế phân quyền SQL riêng cho Admin/HLV/User: bật **SQL Server and Windows Authentication mode (Mixed Mode)** trong Server Properties → Security, rồi khởi động lại dịch vụ SQL Server. Script chỉ kiểm tra/cảnh báo; không tự đổi chế độ hoặc khởi động lại máy chủ.
- Tải/clone vào đường dẫn ngắn, ví dụ `D:\Health`.

## Khởi tạo và chạy

Mở PowerShell tại thư mục gốc kho:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\KhoiTao.ps1 -SqlServer '.\SQLEXPRESS'
```

Đổi `SqlServer` theo tên instance thực tế. Script tạo database mẫu `HEALTH`, tạo quyền theo vai trò, sinh ba SQL login riêng với mật khẩu ngẫu nhiên và ghi kết nối vào `Nhom05_Health_Fitness/Database.Local.config`. Mã nguồn không chứa mật khẩu dùng chung; không cần sửa ba nơi để đồng bộ mật khẩu.

Nếu database đúng của dự án đã tồn tại:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\KhoiTao.ps1 -SqlServer '.\SQLEXPRESS' -SuDungDuLieuHienCo
```

Script giữ dữ liệu đã có, kiểm tra cấu trúc và tái sử dụng cấu hình/login còn khớp. Không tự đổi quyền đã có hoặc đổi mật khẩu của login cũ. Giữ `Database.Local.config` ở máy nhận; tệp này bị Git bỏ qua. Có thể dùng `-Database TenDatabase` để tạo một bộ mẫu riêng.

Sau đó mở **`Nhom05_Health_Fitness.sln`** ở thư mục gốc bằng Visual Studio, Restore NuGet Packages nếu cần, Build và **F5**. Mở đường dẫn `/Account/Login` trên địa chỉ IIS Express mà Visual Studio khởi chạy. `Ctrl+Shift+B` chỉ build.

Đăng nhập ứng dụng bằng tài khoản mẫu trong `database/01_KhoiTao.sql`; chúng khác SQL login được sinh tự động. Các SQL login theo vai trò không được dùng làm tài khoản trên màn hình đăng nhập.

## Những điểm đã sửa

- Một nguồn cấu hình kết nối cho DataContext, trang đăng nhập và các controller.
- Bỏ IP/mật khẩu máy cũ và mật khẩu SQL dùng chung ghi trong C#.
- Kết nối mặc định của controller HLV cũng đọc cấu hình cục bộ, giữ phạm vi truy cập dữ liệu của bản gốc.
- Đổi tham chiếu jQuery HLV sang tệp 3.7.0 có sẵn.
- Tách schema/dữ liệu khởi tạo khỏi đoạn minh họa gây lỗi, backup/restore vào ổ E và lệnh xóa database/login.
- Sinh thông tin SQL login và cấu hình cùng một lần để tránh sai lệch mật khẩu.

Chỉ dùng bộ dữ liệu/tài khoản mẫu cho học tập. Không công khai cấu hình cục bộ; đổi thông tin đăng nhập mẫu trước khi dùng dữ liệu thật. Nếu cần các kịch bản backup/restore trong bài báo cáo, chuẩn bị riêng trên database thử nghiệm có sao lưu.

Bản sửa tập trung vào cài đặt và khả năng chạy trên máy khác; chưa chuẩn hóa lại toàn bộ quyền truy cập dữ liệu của các controller. Các mật khẩu cũ đã từng commit vẫn có thể tồn tại trong lịch sử Git; nếu còn dùng chúng trên SQL Server thật, cần thay đổi tại máy chủ.
