# Cách chạy website Health & Fitness

Làm lần lượt từ bước 1 đến bước 6 dưới đây trên máy Windows. Các bước cài đặt và tạo dữ liệu chỉ cần làm lần đầu. Những lần sau xem mục **Mở lại vào lần sau** ở cuối trang.

## Bước 1 — Cài phần mềm

Nếu máy đã có phần mềm nào thì bỏ qua phần đó.

| Phần mềm | Cách cài |
|---|---|
| [Visual Studio 2022 Community](https://aka.ms/vs/17/release/vs_community.exe) | Mở bộ cài, tích **ASP.NET and web development**, rồi bấm **Install**. Bộ này cài công cụ mở website bằng IIS Express. Đây là Visual Studio, khác Visual Studio Code. |
| [.NET Framework 4.7.2 Developer Pack](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net472) | Trên trang tải, chọn **Developer Pack**, tải về và cài. Nếu báo máy đã có thì bỏ qua. |
| [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) | Tìm mục **Express**, tải bộ cài, mở lên, chọn **Basic** và cài đến khi hoàn tất. |
| [SQL Server Management Studio — SSMS](https://learn.microsoft.com/en-us/ssms/install/install) | Tải và cài theo nút tải trên trang Microsoft. Đây là chương trình dùng để kết nối SQL Server. |

Nếu bộ cài yêu cầu khởi động lại Windows, hãy khởi động lại trước khi làm tiếp.

## Bước 2 — Kết nối và chỉnh SQL Server

**A. Kết nối vào máy chủ**

1. Mở **SQL Server Management Studio**.
2. Ở cửa sổ kết nối, chọn:
   - **Server type:** `Database Engine`.
   - **Server name:** `.\SQLEXPRESS` nếu bạn vừa cài Express theo kiểu Basic.
   - **Authentication:** `Windows Authentication`.
3. Bấm **Connect**. Nếu có lỗi chứng chỉ, tích **Trust server certificate** rồi kết nối lại.
4. Kết nối thành công là khi bên trái hiện máy chủ và thư mục **Databases**.

**Ghi lại tên trong ô Server name.** Lệnh ở bước 4 dùng `.\SQLEXPRESS`. Nếu bạn kết nối bằng tên khác, thay đúng phần đó trong lệnh bằng tên vừa dùng.

**B. Bật chế độ đăng nhập mà website cần — chỉ làm một lần**

1. Trong khung bên trái SSMS, bấm chuột phải vào **tên máy chủ ở dòng trên cùng** → **Properties**.
2. Chọn **Security** ở bên trái.
3. Ở phần **Server authentication**, tích **SQL Server and Windows Authentication mode**.
4. Bấm **OK**. Nếu có thông báo yêu cầu khởi động lại dịch vụ, bấm **OK**.
5. Bấm chuột phải vào tên máy chủ → **Restart** → xác nhận khởi động lại.
6. Đợi dịch vụ chạy lại rồi kết nối SSMS lại nếu cần.

Nếu **Restart** báo không có quyền, đóng SSMS rồi mở lại bằng **Run as administrator**. Nếu đây là máy chủ dùng chung, nhờ người quản lý thực hiện bước bật chế độ và khởi động lại vào thời điểm phù hợp.

## Bước 3 — Tải và mở đúng thư mục dự án

1. Trên trang GitHub của dự án, bấm **Code** → **Download ZIP**.
2. Giải nén ở đường dẫn ngắn, ví dụ `D:\Health`.
3. Mở thư mục đã giải nén. Thư mục đúng phải nhìn thấy **`README.md`, `KhoiTao.ps1` và `Nhom05_Health_Fitness.sln` cùng một chỗ**.
4. Nếu GitHub tạo thêm thư mục `HeQuanTriCSDL-master`, mở tiếp thư mục đó để tìm ba tệp trên.

Source đã có trực tiếp trong kho; sau khi giải nén bản tải từ GitHub là dùng thư mục này.

## Bước 4 — Tạo dữ liệu mẫu

1. Trong thư mục có `KhoiTao.ps1`, bấm vào **thanh địa chỉ** của File Explorer.
2. Gõ `powershell`, nhấn **Enter**. Một cửa sổ PowerShell sẽ mở tại đúng thư mục này.
3. Sao chép nguyên lệnh dưới đây, dán vào PowerShell rồi nhấn **Enter**:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\KhoiTao.ps1 -SqlServer '.\SQLEXPRESS'
```

4. Đợi đến khi thấy **`Da luu cau hinh rieng tai:`** và không có dòng lỗi màu đỏ.
5. Nếu có cảnh báo **`SQL Server dang chi cho Windows Authentication`**, hoàn tất lại phần B của bước 2 trước khi mở website.

Lệnh tạo sẵn dữ liệu mẫu và các kết nối cần thiết cho website. Giữ tệp `Nhom05_Health_Fitness/Database.Local.config` mà lệnh vừa tạo; bạn không cần tự sửa mật khẩu trong mã.

**Nếu báo `Database HEALTH da ton tai`:** nếu đây đúng là dữ liệu cũ của dự án, chạy lệnh sau để sử dụng lại:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\KhoiTao.ps1 -SqlServer '.\SQLEXPRESS' -SuDungDuLieuHienCo
```

Nếu chưa chắc database đó là gì, giữ nguyên và gửi nội dung lỗi để được kiểm tra.

## Bước 5 — Mở website

1. Bấm đúp tệp **`Nhom05_Health_Fitness.sln`** ở thư mục đã mở tại bước 3. Chọn mở bằng **Visual Studio 2022**.
2. Trong **Solution Explorer** bên phải, bấm chuột phải vào dòng trên cùng có chữ **Solution** → **Restore NuGet Packages**, rồi đợi hoàn tất.
3. Bấm chuột phải vào project **Nhom05_Health_Fitness** → **Set as Startup Project**.
4. Nhấn **F5** hoặc nút tam giác xanh **IIS Express**. Đợi Visual Studio mở trình duyệt.
5. Nếu Visual Studio hỏi có tin cậy chứng chỉ HTTPS của IIS Express cho dự án không, xác nhận để mở website cục bộ.
6. Trên trình duyệt, mở đường dẫn **`/Account/Login`** của website vừa chạy. Ví dụ, nếu địa chỉ đang là `https://localhost:44337/`, đổi thành `https://localhost:44337/Account/Login`.

Dùng đúng số cổng mà Visual Studio vừa mở trên máy bạn. Nếu bấm `Ctrl + Shift + B`, Visual Studio chỉ kiểm tra/build mã; muốn mở website thì bấm **F5**.

## Bước 6 — Đăng nhập dùng thử

Các tài khoản sau có khi bạn tạo dữ liệu mẫu mới ở bước 4:

| Loại tài khoản | Tên đăng nhập | Mật khẩu mẫu |
|---|---|---|
| Quản trị | `phamgiabao` | `123456` |
| Huấn luyện viên | `hlv_dung` | `123456` |
| Hội viên | `tranminhtuan` | `123456` |

Nhập vào **trang đăng nhập của website**, không nhập các tài khoản này vào SSMS. Nếu dùng database cũ đã đổi mật khẩu, hãy dùng mật khẩu của database cũ.

## Mở lại vào lần sau

Mở `Nhom05_Health_Fitness.sln` bằng Visual Studio rồi nhấn **F5**. Giữ dịch vụ SQL Server hoạt động và giữ tệp `Database.Local.config` đã tạo. Không cần làm lại bước 4 mỗi lần mở.

## Nếu gặp lỗi

| Bạn thấy gì? | Làm gì tiếp? |
|---|---|
| Không tìm thấy `KhoiTao.ps1` | Quay lại bước 3, mở đúng thư mục có README, KhoiTao và tệp `.sln`, rồi mở PowerShell lại. |
| Không kết nối được SQL Server | Kiểm tra có Connect được trong SSMS ở bước 2 không; dùng đúng Server name đó trong lệnh bước 4. |
| `CREATE DATABASE permission denied` hoặc không được tạo SQL login | Tài khoản Windows đang dùng chưa có quyền khởi tạo. Nhờ người cài/quản lý SQL Server cấp quyền cho tài khoản đó. |
| Báo chỉ cho Windows Authentication hoặc `Login failed` sau khi đăng nhập website | Hoàn tất phần B của bước 2 và khởi động lại dịch vụ SQL Server. Nếu vẫn lỗi, gửi đúng thông báo để kiểm tra tiếp. |
| Thiếu `Database.Local.config` | Chạy lại bước 4 tại bản dự án trên máy đang dùng. |
| `MSB3644` hoặc thiếu `.NET Framework 4.7.2` | Cài **Developer Pack 4.7.2** ở bước 1 rồi mở lại Visual Studio. |
| Thiếu `Microsoft.WebApplication.targets` hoặc không có IIS Express | Mở **Visual Studio Installer** → **Modify** → tích **ASP.NET and web development** → cài bổ sung. |
| Thiếu thư viện NuGet | Thực hiện **Restore NuGet Packages** ở bước 5; máy cần internet khi tải gói còn thiếu. |
| Website không mở dù đã bấm Build | Dùng **F5/IIS Express** để chạy; Build không mở website. |

Tệp `Database.Local.config` là cấu hình riêng của máy; giữ nó trên máy và ngoài GitHub. Các tài khoản ở trên chỉ là tài khoản mẫu cho học tập.

[Thông tin kỹ thuật và phạm vi kiểm thử](GHI_CHU_KY_THUAT.md).