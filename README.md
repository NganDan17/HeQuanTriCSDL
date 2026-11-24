# Nạp dữ liệu và chạy Health Fitness

**Máy Windows cần có:** SQL Server, [.NET Framework 4.7.2 Developer Pack](https://dotnet.microsoft.com/download/dotnet-framework/net472) và [IIS Express 10](https://www.microsoft.com/download/details.aspx?id=48264) (chọn bản amd64 trên Windows 64-bit). Visual Studio tím với **ASP.NET and web development** cũng có thể cung cấp các công cụ này. Chỉ cài .NET SDK 8/10 chưa đủ vì đây là dự án .NET Framework.

## Làm một lần sau khi tải

1. Trong SSMS: chuột phải tên máy chủ → **Properties → Security → SQL Server and Windows Authentication mode → OK**. Chuột phải máy chủ → **Restart**. Chỉ cần làm một lần; máy chủ dùng chung cần người quản lý thực hiện.
2. Tải và giải nén dự án vào đường dẫn ngắn, ví dụ `D:\Health`.
3. Mở thư mục có `KhoiTao.ps1`, gõ `powershell` vào thanh địa chỉ, nhấn Enter rồi chạy:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\KhoiTao.ps1 -SqlServer '.\SQLEXPRESS'
   ```

   Đổi `.\SQLEXPRESS` theo tên SQL Server của máy. Nếu database của dự án đã có, thêm `-SuDungDuLieuHienCo` vào cuối lệnh.

## Chạy bằng VS Code xanh

1. Chọn **File → Open Folder**, mở đúng thư mục có `Chay.ps1` và `.vscode` (không mở riêng thư mục con).
2. Chọn tin cậy thư mục nếu VS Code hỏi. Nhấn **Ctrl + Shift + B**: tác vụ sẽ biên dịch rồi chạy IIS Express và mở trang đăng nhập tại **http://localhost:5085/Account/Login**.
3. Giữ Terminal đang chạy. Muốn dừng, bấm **Q** trong Terminal đó hoặc chọn **Terminal → Terminate Task**. Dừng lần cũ trước khi chạy lại.

Không cần cài extension IIS hoặc debugger để chạy tác vụ này. Đây là chạy website, không phải cấu hình F5 gỡ lỗi C# trong VS Code.

## Chạy bằng Visual Studio tím

1. Mở `Nhom05_Health_Fitness.sln`. Nếu thiếu gói, chuột phải Solution → **Restore NuGet Packages**.
2. Nhấn **F5** (hoặc **Ctrl + F5**). Mở `/Account/Login` trên website vừa chạy; cổng có thể khác VS Code.

**Đăng nhập mẫu ở cả hai cách:** `phamgiabao` / `123456`.

**Lần sau:** VS Code nhấn **Ctrl + Shift + B**, hoặc Visual Studio mở `.sln` rồi **F5**. Không chạy lại khởi tạo để nạp đè dữ liệu.

Nếu cổng 5085 bận, dừng website cũ hoặc mở PowerShell tại thư mục dự án rồi chạy:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Chay.ps1 -Port 5086
```

Giữ tệp `Database.Local.config` đã tạo trên máy; tệp này được bỏ ngoài GitHub. Dữ liệu đi kèm là dữ liệu mẫu; không tự nạp đè database đang dùng.
