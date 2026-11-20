# Nạp dữ liệu và chạy

## 1. Nạp dữ liệu

Mở thư mục có `KhoiTao.ps1`, gõ `powershell` vào thanh địa chỉ rồi nhấn Enter. Dán lệnh:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\KhoiTao.ps1 -SqlServer '.\SQLEXPRESS'
```

Thay `.\SQLEXPRESS` nếu SQL Server của bạn có tên khác. Nếu dữ liệu đã có, thêm `-SuDungDuLieuHienCo` vào cuối lệnh.

## 2. Chạy website

1. Mở `Nhom05_Health_Fitness.sln` bằng **Visual Studio**.
2. Nhấn **F5** và mở `/Account/Login` trên website vừa chạy.
3. Đăng nhập mẫu: **`phamgiabao` / `123456`**.

Lần sau chỉ cần mở `.sln` và nhấn **F5**, không nạp lại dữ liệu.

Máy chưa cài đủ phần mềm hoặc chưa bật SQL Mixed Mode: xem [hướng dẫn cài đặt](HUONG_DAN_CAI_DAT.md).