# Ghi chú kỹ thuật

Hướng dẫn mở website nằm trong [README](README.md). Tệp này dành cho người cần xem cách tổ chức và phạm vi kiểm tra.

- ASP.NET MVC 5, .NET Framework 4.7.2, LINQ to SQL, IIS Express và SQL Server.
- Source nằm trực tiếp trong kho; ZIP source cũ đã được thay bằng thư mục project và solution ở gốc.
- `KhoiTao.ps1` tạo database mẫu bằng tài khoản Windows đang chạy script. Database đã có được chặn; chỉ tái sử dụng khi truyền `-SuDungDuLieuHienCo` và cấu trúc đúng.
- Schema/dữ liệu ở `database/01_KhoiTao.sql`; quyền theo vai trò ở `database/02_PhanQuyen.sql`. Đã tách các ví dụ gây lỗi, backup/restore vào ổ E và lệnh xóa database/login khỏi luồng khởi tạo.
- Script sinh SQL login riêng và mật khẩu ngẫu nhiên, rồi ghi cùng thông tin vào `Nhom05_Health_Fitness/Database.Local.config`. Tệp này bị Git bỏ qua. Chạy lại với cấu hình còn khớp sẽ tái sử dụng login, không tự đổi mật khẩu hay ghi đè quyền đã sửa.
- `DatabaseConfiguration` là nguồn đọc cấu hình cho DataContext và kết nối theo vai trò. Biến môi trường `HEALTH_CONNECTION_STRING` có thể ghi đè kết nối mặc định; kết nối theo vai trò vẫn đọc tệp cấu hình.
- Có thể chọn database riêng bằng tham số `-Database` của script.
- Controller HLV giữ phạm vi truy cập dữ liệu của bản gốc; bản sửa chưa chuẩn hóa lại toàn bộ quyền truy cập của các controller.
- Tham chiếu jQuery ở giao diện HLV đã đổi sang tệp 3.7.0 có trong source.

Đã kiểm tra biên dịch C# với thư viện tham chiếu Framework 4.7.2, tạo database sạch, gọi procedure đăng nhập bằng DataContext mặc định, đối chiếu mật khẩu SQL login/cấu hình và vai trò bằng impersonation, chặn vai trò không hợp lệ, tái sử dụng database và chặn ghi đè. Máy kiểm thử dùng Windows Authentication nên chưa kiểm thử kết nối SQL Authentication qua mạng hoặc toàn bộ giao diện IIS Express.

Mật khẩu của máy cũ đã được bỏ khỏi mã hiện hành nhưng vẫn có thể nằm trong lịch sử Git. Nếu còn dùng chúng trên SQL Server thật, cần đổi tại máy chủ. Tài khoản mẫu trong README chỉ dành cho học tập.

Tham khảo: [Microsoft — đổi chế độ xác thực SQL Server](https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/change-server-authentication-mode).
