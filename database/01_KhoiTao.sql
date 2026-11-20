CREATE TABLE VaiTro (
    ID INT PRIMARY KEY,
    TenVaiTro NVARCHAR(50) NOT NULL, -- 1: Admin, 2: User, 3: HLV
    MoTa NVARCHAR(255)
);
GO
CREATE TABLE NguoiDung (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    NguoiDungID AS (CAST('ND' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    VaiTro_ID INT NOT NULL, -- Link tới bảng VaiTro
    TenDangNhap NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    MatKhau NVARCHAR(255) NOT NULL,
    NgayCapNhat DATETIME
);
GO
CREATE TABLE HoSo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    HoSoID AS (CAST('HS' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    NguoiDung_ID CHAR(10) NULL,   
    HoTen NVARCHAR(100),
    GioiTinh NVARCHAR(4),
    NgaySinh DATE,
    ChieuCao_cm DECIMAL(5,2),
    CanNang_kg DECIMAL(5,2)
);
GO
CREATE TABLE HuanLuyenVien (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    HLV_ID AS (CAST('HLV' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    NguoiDung_ID CHAR(10) NOT NULL, -- Link về tài khoản NguoiDung
    HoTen NVARCHAR(100),
    GioiTinh NVARCHAR(4),
    SoNamKinhNghiem INT,
    SoDienThoai VARCHAR(15)
);
GO
CREATE TABLE BaiTap (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    BaiTapID AS (CAST('BTAP' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    TenBaiTap NVARCHAR(100) NOT NULL,
    LoaiBaiTap NVARCHAR(50),
    MoTa NVARCHAR(255)
);
GO
CREATE TABLE GoiTap (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    GoiTapID AS (CAST('GT' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    TenGoi NVARCHAR(100) NOT NULL,
    ThoiHan_thang INT,
    GiaTien DECIMAL(10,2)
);
GO
CREATE TABLE ThietBiTap (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ThietBiID AS (CAST('TB' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    TenThietBi NVARCHAR(100) NOT NULL,
    TrangThai NVARCHAR(20),
    NgayBaoTri DATE
);
GO
CREATE TABLE BuoiTap (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    BuoiTapID AS (CAST('BT' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    NguoiDung_ID CHAR(10),   
    NgayTap DATE,
    ThoiLuong_phut INT,
    GhiChu NVARCHAR(255)
);
GO
CREATE TABLE ChiTietBuoiTap (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ChiTietBuoiTapID AS (CAST('CTBT' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    BuoiTap_ID CHAR(10) NOT NULL,   
    BaiTap_ID CHAR(10) NOT NULL,   
    SoHiep INT,
    SoLanLap INT,
    TrongLuongTa_kg DECIMAL(7,2),
    ThietBi_ID CHAR(10) NULL   
);
GO
CREATE TABLE MucTieu (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MucTieuID AS (CAST('MT' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    NguoiDung_ID CHAR(10),   
    LoaiMucTieu NVARCHAR(50),
    CanNangMucTieu_kg DECIMAL(6,2),
    HanHoanThanh DATE
);
GO
CREATE TABLE TienTrinh (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TienTrinhID AS (CAST('TT' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    NguoiDung_ID CHAR(10),   
    NgayGhi DATE,
    CanNang_kg DECIMAL(6,2),
    BMI DECIMAL(5,2)
);
GO
CREATE TABLE LichHuanLuyen (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    LichID AS (CAST('LHL' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    HLV_ID CHAR(10), 
    NguoiDung_ID CHAR(10),   
    Ngay DATE,
    NoiDung NVARCHAR(255),
    TrangThai NVARCHAR(20)
);
GO
CREATE TABLE DanhGiaBuoiTap (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DanhGiaID AS (CAST('DG' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    BuoiTap_ID CHAR(10),   
    Diem INT,
    NhanXet NVARCHAR(255)
);
GO
CREATE TABLE DangKyGoiTap (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DangKyID AS (CAST('DK' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    NguoiDung_ID CHAR(10),   
    GoiTap_ID CHAR(10),   
    NgayDangKy DATE,
    NgayHetHan DATE
);
GO
CREATE TABLE ThanhToan (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ThanhToanID AS (CAST('TTT' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    DangKy_ID CHAR(10), 
    SoTien DECIMAL(12,2),
    NgayThanhToan DATE
);
GO
CREATE TABLE LoiNhac (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    LoiNhacID AS (CAST('LN' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    NguoiDung_ID CHAR(10),
    NoiDung NVARCHAR(255),
    NgayNhac DATE
);
GO
CREATE TABLE SuKienSucKhoe (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    SKID AS (CAST('SK' + RIGHT('00000' + CAST(ID AS VARCHAR(5)),5) AS CHAR(10))) PERSISTED NOT NULL,
    NguoiDung_ID CHAR(10), 
    TenSuKien NVARCHAR(100),
    NgayBatDau DATE,
    NgayKetThuc DATE,
    GhiChu NVARCHAR(255)
);
GO
INSERT INTO VaiTro (ID, TenVaiTro, MoTa) VALUES 
(1, 'Admin', N'Quản trị hệ thống'),
(2, 'User', N'Người dùng tập luyện'),
(3, 'HLV', N'Huấn luyện viên');
GO
-- PHẦN 2: RÀNG BUỘC UNIQUE (DUY NHẤT)
-- =====================================================
-- Unique cho ID được sinh ra (Computed Column)
ALTER TABLE NguoiDung ADD CONSTRAINT UQ_NguoiDungID UNIQUE (NguoiDungID);
ALTER TABLE BaiTap ADD CONSTRAINT UQ_BaiTapID UNIQUE (BaiTapID);
ALTER TABLE GoiTap ADD CONSTRAINT UQ_GoiTapID UNIQUE (GoiTapID);
ALTER TABLE ThietBiTap ADD CONSTRAINT UQ_ThietBiID UNIQUE (ThietBiID);
ALTER TABLE HoSo ADD CONSTRAINT UQ_HoSoID UNIQUE (HoSoID);
ALTER TABLE BuoiTap ADD CONSTRAINT UQ_BuoiTapID UNIQUE (BuoiTapID);
ALTER TABLE ChiTietBuoiTap ADD CONSTRAINT UQ_ChiTietBuoiTapID UNIQUE (ChiTietBuoiTapID);
ALTER TABLE MucTieu ADD CONSTRAINT UQ_MucTieuID UNIQUE (MucTieuID);
ALTER TABLE TienTrinh ADD CONSTRAINT UQ_TienTrinhID UNIQUE (TienTrinhID);
ALTER TABLE HuanLuyenVien ADD CONSTRAINT UQ_HLV_ID UNIQUE (HLV_ID);
ALTER TABLE LichHuanLuyen ADD CONSTRAINT UQ_LichID UNIQUE (LichID);
ALTER TABLE DanhGiaBuoiTap ADD CONSTRAINT UQ_DanhGiaID UNIQUE (DanhGiaID);
ALTER TABLE DangKyGoiTap ADD CONSTRAINT UQ_DangKyID UNIQUE (DangKyID);
ALTER TABLE ThanhToan ADD CONSTRAINT UQ_ThanhToanID UNIQUE (ThanhToanID);
ALTER TABLE LoiNhac ADD CONSTRAINT UQ_LoiNhacID UNIQUE (LoiNhacID);
ALTER TABLE SuKienSucKhoe ADD CONSTRAINT UQ_SKID UNIQUE (SKID);

-- Unique logic nghiệp vụ
ALTER TABLE NguoiDung ADD CONSTRAINT UQ_NguoiDung_Email UNIQUE (Email);
ALTER TABLE NguoiDung ADD CONSTRAINT UQ_NguoiDung_TenDangNhap UNIQUE (TenDangNhap);
ALTER TABLE HoSo ADD CONSTRAINT UQ_HoSo_NguoiDung UNIQUE (NguoiDung_ID); 
ALTER TABLE HuanLuyenVien ADD CONSTRAINT UQ_HLV_NguoiDung UNIQUE (NguoiDung_ID); 
ALTER TABLE BaiTap ADD CONSTRAINT UQ_BaiTap_TenBaiTap UNIQUE (TenBaiTap);
ALTER TABLE ChiTietBuoiTap ADD CONSTRAINT UQ_ChiTietBuoiTap UNIQUE (BuoiTap_ID, BaiTap_ID);
ALTER TABLE TienTrinh ADD CONSTRAINT UQ_TienTrinh UNIQUE (NguoiDung_ID, NgayGhi);
ALTER TABLE ThietBiTap ADD CONSTRAINT UQ_ThietBiTap_TenThietBi UNIQUE (TenThietBi);
ALTER TABLE HuanLuyenVien ADD CONSTRAINT UQ_HLV_SDT UNIQUE (SoDienThoai);
ALTER TABLE DanhGiaBuoiTap ADD CONSTRAINT UQ_DanhGiaBuoiTap UNIQUE (BuoiTap_ID); 
ALTER TABLE GoiTap ADD CONSTRAINT UQ_GoiTap_TenGoi UNIQUE (TenGoi);
ALTER TABLE LoiNhac ADD CONSTRAINT UQ_LoiNhac UNIQUE (NguoiDung_ID, NgayNhac, NoiDung);
GO
-- PHẦN 3: KHÓA NGOẠI (FOREIGN KEY)
-- =====================================================
-- 1. NguoiDung -> VaiTro
ALTER TABLE NguoiDung
ADD CONSTRAINT FK_NguoiDung_VaiTro FOREIGN KEY (VaiTro_ID) REFERENCES VaiTro(ID);

-- 2. HoSo -> NguoiDung
ALTER TABLE HoSo
ADD CONSTRAINT FK_HoSo_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID); 

-- 3. HuanLuyenVien -> NguoiDung (Mới thêm)
ALTER TABLE HuanLuyenVien
ADD CONSTRAINT FK_HLV_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID);

-- 4. BuoiTap -> NguoiDung
ALTER TABLE BuoiTap
ADD CONSTRAINT FK_BuoiTap_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID); 

-- 5. ChiTietBuoiTap -> BuoiTap, BaiTap, ThietBiTap
ALTER TABLE ChiTietBuoiTap
ADD CONSTRAINT FK_ChiTietBuoiTap_BuoiTap FOREIGN KEY (BuoiTap_ID) REFERENCES BuoiTap(BuoiTapID); 

ALTER TABLE ChiTietBuoiTap
ADD CONSTRAINT FK_ChiTietBuoiTap_BaiTap FOREIGN KEY (BaiTap_ID) REFERENCES BaiTap(BaiTapID); 

ALTER TABLE ChiTietBuoiTap
ADD CONSTRAINT FK_ChiTietBuoiTap_ThietBi FOREIGN KEY (ThietBi_ID) REFERENCES ThietBiTap(ThietBiID); 

-- 6. MucTieu -> NguoiDung
ALTER TABLE MucTieu
ADD CONSTRAINT FK_MucTieu_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID); 

-- 7. TienTrinh -> NguoiDung
ALTER TABLE TienTrinh
ADD CONSTRAINT FK_TienTrinh_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID); 

-- 8. LichHuanLuyen -> HuanLuyenVien, NguoiDung
ALTER TABLE LichHuanLuyen
ADD CONSTRAINT FK_LichHuanLuyen_HLV FOREIGN KEY (HLV_ID) REFERENCES HuanLuyenVien(HLV_ID); 

ALTER TABLE LichHuanLuyen
ADD CONSTRAINT FK_LichHuanLuyen_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID); 

-- 9. DanhGiaBuoiTap -> BuoiTap
ALTER TABLE DanhGiaBuoiTap
ADD CONSTRAINT FK_DanhGiaBuoiTap_BuoiTap FOREIGN KEY (BuoiTap_ID) REFERENCES BuoiTap(BuoiTapID); 

-- 10. DangKyGoiTap -> NguoiDung, GoiTap
ALTER TABLE DangKyGoiTap
ADD CONSTRAINT FK_DangKyGoiTap_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID); 

ALTER TABLE DangKyGoiTap
ADD CONSTRAINT FK_DangKyGoiTap_GoiTap FOREIGN KEY (GoiTap_ID) REFERENCES GoiTap(GoiTapID); 

-- 11. ThanhToan -> DangKyGoiTap
ALTER TABLE ThanhToan
ADD CONSTRAINT FK_ThanhToan_DangKy FOREIGN KEY (DangKy_ID) REFERENCES DangKyGoiTap(DangKyID); 

-- 12. LoiNhac -> NguoiDung
ALTER TABLE LoiNhac
ADD CONSTRAINT FK_LoiNhac_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID); 

-- 13. SuKienSucKhoe -> NguoiDung
ALTER TABLE SuKienSucKhoe
ADD CONSTRAINT FK_SuKien_NguoiDung FOREIGN KEY (NguoiDung_ID) REFERENCES NguoiDung(NguoiDungID);
GO
-- PHẦN 4: CHECK CONSTRAINTS (ĐIỀU KIỆN)
-- =====================================================
ALTER TABLE NguoiDung ADD CONSTRAINT CK_NguoiDung_NgayCapNhat CHECK (NgayCapNhat <= GETDATE());
ALTER TABLE HoSo ADD CONSTRAINT CK_HoSo_CanNang CHECK (CanNang_kg > 0);
ALTER TABLE BuoiTap ADD CONSTRAINT CK_BuoiTap_ThoiLuong CHECK (ThoiLuong_phut > 0);
ALTER TABLE BaiTap ADD CONSTRAINT CK_BaiTap_LoaiBaiTap CHECK (LEN(LoaiBaiTap) > 0);
ALTER TABLE ChiTietBuoiTap ADD CONSTRAINT CK_ChiTietBuoiTap_SoLanLap CHECK (SoLanLap >= 0);
ALTER TABLE MucTieu ADD CONSTRAINT CK_MucTieu_CanNang CHECK (CanNangMucTieu_kg > 0);
ALTER TABLE TienTrinh ADD CONSTRAINT CK_TienTrinh_CanNang CHECK (CanNang_kg > 0);
ALTER TABLE ThietBiTap ADD CONSTRAINT CK_ThietBiTap_TrangThai CHECK (TrangThai IN (N'Hoạt động', N'Bảo trì'));
ALTER TABLE HuanLuyenVien ADD CONSTRAINT CK_HLV_SoNamKinhNghiem CHECK (SoNamKinhNghiem >= 0);
ALTER TABLE LichHuanLuyen ADD CONSTRAINT CK_LichHuanLuyen_Ngay CHECK (Ngay >= GETDATE());
ALTER TABLE DanhGiaBuoiTap ADD CONSTRAINT CK_DanhGia_Diem CHECK (Diem BETWEEN 1 AND 5);
ALTER TABLE GoiTap ADD CONSTRAINT CK_GoiTap_ThoiHan CHECK (ThoiHan_thang > 0);
ALTER TABLE DangKyGoiTap ADD CONSTRAINT CK_DangKy_Ngay CHECK (NgayHetHan >= NgayDangKy);
ALTER TABLE ThanhToan ADD CONSTRAINT CK_ThanhToan_SoTien CHECK (SoTien >= 0);
ALTER TABLE LoiNhac ADD CONSTRAINT CK_LoiNhac_Ngay CHECK (CAST(NgayNhac AS DATE) >= CAST(GETDATE() AS DATE));
ALTER TABLE SuKienSucKhoe ADD CONSTRAINT CK_SuKien_Ngay CHECK (NgayKetThuc >= NgayBatDau);
ALTER TABLE LichHuanLuyen ADD CONSTRAINT CK_LichHuanLuyen_TrangThai CHECK (TrangThai IN (N'Chưa diễn ra', N'Hoàn thành', N'Đã hủy'));
GO
-- PHẦN 5: DEFAULT VALUES (MẶC ĐỊNH)
-- =====================================================
ALTER TABLE NguoiDung ADD CONSTRAINT DF_NguoiDung_VaiTro DEFAULT 2 FOR VaiTro_ID; -- Mặc định tạo ra là User
ALTER TABLE NguoiDung ADD CONSTRAINT DF_NguoiDung_NgayCapNhat DEFAULT (GETDATE()) FOR NgayCapNhat;
ALTER TABLE HoSo ADD CONSTRAINT DF_HoSo_GioiTinh DEFAULT (N'N/A') FOR GioiTinh;
ALTER TABLE BuoiTap ADD CONSTRAINT DF_BuoiTap_NgayTap DEFAULT (GETDATE()) FOR NgayTap;
ALTER TABLE BaiTap ADD CONSTRAINT DF_BaiTap_LoaiBaiTap DEFAULT (N'Khác') FOR LoaiBaiTap;
ALTER TABLE ChiTietBuoiTap ADD CONSTRAINT DF_ChiTietBuoiTap_SoLanLap DEFAULT (0) FOR SoLanLap;
ALTER TABLE MucTieu ADD CONSTRAINT DF_MucTieu_LoaiMucTieu DEFAULT (N'Giảm cân') FOR LoaiMucTieu;
ALTER TABLE TienTrinh ADD CONSTRAINT DF_TienTrinh_BMI DEFAULT (0) FOR BMI;
ALTER TABLE ThietBiTap ADD CONSTRAINT DF_ThietBiTap_TrangThai DEFAULT (N'Hoạt động') FOR TrangThai;
ALTER TABLE HuanLuyenVien ADD CONSTRAINT DF_HLV_GioiTinh DEFAULT (N'N/A') FOR GioiTinh;
ALTER TABLE LichHuanLuyen ADD CONSTRAINT DF_LichHuanLuyen_NoiDung DEFAULT (N'Chưa có') FOR NoiDung;
ALTER TABLE DanhGiaBuoiTap ADD CONSTRAINT DF_DanhGia_NhanXet DEFAULT (N'') FOR NhanXet;
ALTER TABLE GoiTap ADD CONSTRAINT DF_GoiTap_ThoiHan DEFAULT (1) FOR ThoiHan_thang;
ALTER TABLE DangKyGoiTap ADD CONSTRAINT DF_DangKyGoiTap_NgayDangKy DEFAULT (GETDATE()) FOR NgayDangKy;
ALTER TABLE ThanhToan ADD CONSTRAINT DF_ThanhToan_NgayThanhToan DEFAULT (GETDATE()) FOR NgayThanhToan;
ALTER TABLE LoiNhac ADD CONSTRAINT DF_LoiNhac_NgayNhac DEFAULT (GETDATE()) FOR NgayNhac;
ALTER TABLE SuKienSucKhoe ADD CONSTRAINT DF_SuKien_GhiChu DEFAULT (N'') FOR GhiChu;
ALTER TABLE LichHuanLuyen ADD CONSTRAINT DF_LichHuanLuyen_TrangThai DEFAULT (N'Chưa diễn ra') FOR TrangThai;
GO
-- 7. DỮ LIỆU
-- =============================

-- 1. Người dùng (Tài khoản chung)
-- Lưu ý: ID sẽ tự động tăng, ND00001 -> ND00013
INSERT INTO NguoiDung (TenDangNhap, Email, MatKhau, VaiTro_ID)
VALUES
(N'tranminhtuan', N'tuan.tran@gmail.com', N'123456', 2), -- ND00001 (User)
(N'levananh', N'anh.le@gmail.com', N'123456', 2),       -- ND00002 (User)
(N'phamgiabao', N'bao.pham@gmail.com', N'123456', 1),     -- ND00003 (ADMIN)
(N'nguyenhoanglan', N'lan.nguyen@gmail.com', N'123456', 2), 
(N'vovanduc', N'duc.vo@gmail.com', N'123456', 2),
(N'truongmylinh', N'linh.truong@gmail.com', N'123456', 2),
(N'dinhcongthanh', N'thanh.dinh@gmail.com', N'123456', 2),
(N'lythikimhue', N'hue.ly@gmail.com', N'123456', 2),
(N'buitanphat', N'phat.bui@gmail.com', N'123456', 2),
(N'domanhtrung', N'trung.do@gmail.com', N'123456', 2),
(N'phanthingoc', N'ngoc.phan@gmail.com', N'123456', 2),
(N'huynhphuongnam', N'nam.huynh@gmail.com', N'123456', 2),
(N'danglehoang', N'hoang.dang@gmail.com', N'123456', 2);
GO
INSERT INTO NguoiDung (TenDangNhap, Email, MatKhau, VaiTro_ID)
VALUES
(N'hlv_dung', N'dung.hoang@gym.com', N'123456', 3),
(N'hlv_thao', N'thao.mai@gym.com', N'123456', 3),
(N'hlv_minh', N'minh.nguyen@gym.com', N'123456', 3),
(N'hlv_ha', N'ha.le@gym.com', N'123456', 3),
(N'hlv_bo', N'bo.tran@gym.com', N'123456', 3),
(N'hlv_my', N'my.vu@gym.com', N'123456', 3),
(N'hlv_lam', N'lam.dang@gym.com', N'123456', 3),
(N'hlv_hien', N'hien.trinh@gym.com', N'123456', 3),
(N'hlv_vinh', N'vinh.bui@gym.com', N'123456', 3),
(N'hlv_chi', N'chi.ho@gym.com', N'123456', 3),
(N'hlv_truong', N'truong.luong@gym.com', N'123456', 3),
(N'hlv_phuong', N'phuong.nguyen@gym.com', N'123456', 3);
GO
INSERT INTO HuanLuyenVien (NguoiDung_ID, HoTen, GioiTinh, SoNamKinhNghiem, SoDienThoai)
VALUES
(N'ND00014', N'Hoàng Trung Dũng', N'Nam', 5, '0909123456'),
(N'ND00015', N'Mai Phương Thảo', N'Nữ', 3, '0911222333'),
(N'ND00016', N'Nguyễn Tiến Minh', N'Nam', 8, '0988111222'),
(N'ND00017', N'Lê Ngọc Hà', N'Nữ', 2, '0977333444'),
(N'ND00018', N'Trần Đức Bo', N'Nam', 10, '0966555666'),
(N'ND00019', N'Vũ Thị Diễm My', N'Nữ', 4, '0955777888'),
(N'ND00020', N'Đặng Văn Lâm', N'Nam', 1, '0944999000'),
(N'ND00021', N'Trịnh Thúy Hiền', N'Nữ', 5, '0933123123'),
(N'ND00022', N'Bùi Quang Vinh', N'Nam', 3, '0922456456'),
(N'ND00023', N'Hồ Thị Kim Chi', N'Nữ', 7, '0911789789'),
(N'ND00024', N'Lương Xuân Trường', N'Nam', 6, '0905654321'),
(N'ND00025', N'Nguyễn Công Phượng', N'Nam', 6, '0912121219');
GO
INSERT INTO GoiTap (TenGoi, ThoiHan_thang, GiaTien)
VALUES
(N'Gói 1 tháng', 1, 500000),
(N'Gói 3 tháng', 3, 1200000),
(N'Gói 6 tháng', 6, 2000000),
(N'Gói 12 tháng', 12, 3500000),
(N'Gói PT 1-1 (10 buổi)', 1, 4000000),
(N'Gói PT 1-1 (30 buổi)', 3, 11000000),
(N'Gói Sinh viên (1 tháng)', 1, 350000),
(N'Gói Giờ vàng (1 tháng)', 1, 300000),
(N'Gói Tập thử 1 tuần', 1, 150000),
(N'Gói Yoga (1 tháng)', 1, 700000),
(N'Gói Kickboxing (3 tháng)', 3, 2500000),
(N'Gói Doanh nghiệp (5 người)', 6, 8000000),
(N'Gói Gia đình (3 người)', 12, 9000000);
GO
INSERT INTO BaiTap (TenBaiTap, LoaiBaiTap, MoTa)
VALUES
(N'Hít đất', N'Sức mạnh', N'Tập cơ tay và ngực'),
(N'Chạy bộ', N'Thể lực', N'Cải thiện sức bền'),
(N'Kéo xà', N'Sức mạnh', N'Tập lưng và tay sau'),
(N'Squat', N'Sức mạnh', N'Tập cơ đùi và mông'),
(N'Deadlift', N'Sức mạnh', N'Tập lưng dưới và chân'),
(N'Bench Press', N'Sức mạnh', N'Tập cơ ngực'),
(N'Overhead Press', N'Sức mạnh', N'Tập cơ vai'),
(N'Plank', N'Sức bền', N'Tập cơ bụng lõi'),
(N'Gập bụng', N'Sức mạnh', N'Tập cơ bụng'),
(N'Nhảy dây', N'Thể lực', N'Cardio cường độ cao'),
(N'Đạp xe', N'Thể lực', N'Tập sức bền chân'),
(N'Yoga Flow', N'Linh hoạt', N'Tăng cường sự dẻo dai'),
(N'Đẩy vai', N'Sức mạnh', N'Tập vai với tạ đơn');
GO
INSERT INTO ThietBiTap (TenThietBi, TrangThai, NgayBaoTri)
VALUES
(N'Máy chạy bộ 1', N'Hoạt động', '2025-10-01'),
(N'Tạ đơn 10kg (cặp)', N'Hoạt động', '2025-09-10'),
(N'Máy chạy bộ 2', N'Hoạt động', '2025-11-01'),
(N'Tạ đơn 5kg (cặp)', N'Hoạt động', '2025-09-10'),
(N'Ghế đẩy ngực', N'Bảo trì', '2025-10-20'),
(N'Tạ đơn 15kg (cặp)', N'Hoạt động', '2025-09-10'),
(N'Máy kéo xô (Lat Pulldown)', N'Hoạt động', '2026-01-15'),
(N'Máy tập chân (Leg Press)', N'Hoạt động', '2026-01-15'),
(N'Xe đạp tập thể lực 1', N'Hoạt động', '2025-12-01'),
(N'Xe đạp tập thể lực 2', N'Bảo trì', '2025-10-25'),
(N'Dây nhảy', N'Hoạt động', '2025-10-01'),
(N'Máy tập vai', N'Hoạt động', '2026-02-01');
GO
INSERT INTO HoSo (NguoiDung_ID, HoTen, GioiTinh, NgaySinh, ChieuCao_cm, CanNang_kg)
VALUES
(N'ND00001', N'Trần Minh Tuấn', N'Nam', '1998-05-10', 175, 70),
(N'ND00002', N'Lê Vân Anh', N'Nữ', '2000-07-22', 160, 50),
(N'ND00003', N'Phạm Gia Bảo', N'Nam', '1995-12-01', 180, 80),
(N'ND00004', N'Nguyễn Hoàng Lan', N'Nữ', '1999-01-15', 165, 65),
(N'ND00005', N'Võ Văn Đức', N'Nam', '2001-03-20', 158, 48),
(N'ND00006', N'Trương Mỹ Linh', N'Nữ', '1990-11-30', 170, 72),
(N'ND00007', N'Đinh Công Thành', N'Nam', '2002-02-18', 162, 55),
(N'ND00008', N'Lý Thị Kim Huệ', N'Nữ', '1988-09-05', 178, 85),
(N'ND00009', N'Bùi Tấn Phát', N'Nam', '1996-06-12', 155, 50),
(N'ND00010', N'Đỗ Mạnh Trung', N'Nam', '2003-08-25', 182, 78),
(N'ND00011', N'Phan Thị Ngọc', N'Nữ', '1994-04-14', 168, 60),
(N'ND00012', N'Huỳnh Phương Nam', N'Nam', '1992-10-10', 173, 70),
(N'ND00013', N'Đặng Lê Hoàng', N'Nam', '1997-07-07', 177, 76);
GO
INSERT INTO DangKyGoiTap (NguoiDung_ID, GoiTap_ID, NgayDangKy, NgayHetHan)
VALUES
(N'ND00001', N'GT00001', GETDATE(), DATEADD(MONTH, 1, GETDATE())),
(N'ND00002', N'GT00002', GETDATE(), DATEADD(MONTH, 3, GETDATE())),
(N'ND00004', N'GT00004', GETDATE(), DATEADD(MONTH, 12, GETDATE())),
(N'ND00008', N'GT00001', GETDATE(), DATEADD(MONTH, 1, GETDATE())),
(N'ND00001', N'GT00007', DATEADD(DAY, -1, GETDATE()), DATEADD(MONTH, 3, DATEADD(DAY, -1, GETDATE()))),
(N'ND00010', N'GT00002', GETDATE(), DATEADD(MONTH, 1, GETDATE())),
(N'ND00003', N'GT00010', GETDATE(), DATEADD(MONTH, 3, GETDATE())),
(N'ND00012', N'GT00005', DATEADD(DAY, -2, GETDATE()), DATEADD(MONTH, 1, DATEADD(DAY, -2, GETDATE()))),
(N'ND00005', N'GT00009', GETDATE(), DATEADD(DAY, 7, GETDATE())),
(N'ND00009', N'GT00011', DATEADD(DAY, -5, GETDATE()), DATEADD(MONTH, 3, DATEADD(DAY, -5, GETDATE()))),
(N'ND00002', N'GT00003', GETDATE(), DATEADD(MONTH, 6, GETDATE())),
(N'ND00007', N'GT00013', DATEADD(DAY, -5, GETDATE()), DATEADD(MONTH, 12, DATEADD(DAY, -5, GETDATE())));
GO
INSERT INTO BuoiTap (NguoiDung_ID, NgayTap, ThoiLuong_phut, GhiChu)
VALUES
(N'ND00001', GETDATE(), 60, N'Tập ngực và tay'),
(N'ND00002', GETDATE(), 45, N'Tập cardio'),
(N'ND00005', DATEADD(DAY, -1, GETDATE()), 50, N'Tập chân'),
(N'ND00001', GETDATE(), 60, N'Tập cardio và bụng'),
(N'ND00011', DATEADD(DAY, -1, GETDATE()), 75, N'Tập toàn thân'),
(N'ND00003', DATEADD(DAY, -1, GETDATE()), 45, N'Tập Yoga'),
(N'ND00008', GETDATE(), 90, N'Tập ngực và tay sau'),
(N'ND00013', DATEADD(DAY, -2, GETDATE()), 60, N'Tập lưng xô, tay trước'),
(N'ND00002', GETDATE(), 30, N'Chạy bộ phục hồi'),
(N'ND00007', DATEADD(DAY, -2, GETDATE()), 60, N'Tập Kickboxing'),
(N'ND00010', GETDATE(), 50, N'Tập bụng và cardio'),
(N'ND00004', DATEADD(DAY, -2, GETDATE()), 45, N'Tập vai và tay sau');
GO
INSERT INTO MucTieu (NguoiDung_ID, LoaiMucTieu, CanNangMucTieu_kg, HanHoanThanh)
VALUES
(N'ND00001', N'Giảm cân', 65, DATEADD(MONTH, 1, GETDATE())),
(N'ND00002', N'Tăng cân', 55, DATEADD(MONTH, 2, GETDATE())),
(N'ND00004', N'Giảm cân', 60, DATEADD(MONTH, 2, GETDATE())),
(N'ND00009', N'Tăng cân', 50, DATEADD(MONTH, 3, GETDATE())),
(N'ND00001', N'Tăng cơ', 72, DATEADD(MONTH, 1, GETDATE())),
(N'ND00011', N'Giữ cân', 55, DATEADD(MONTH, 6, GETDATE())),
(N'ND00006', N'Tăng cơ', 88, DATEADD(MONTH, 4, GETDATE())),
(N'ND00002', N'Giảm cân', 48, DATEADD(MONTH, 2, GETDATE())),
(N'ND00013', N'Tăng cân', 82, DATEADD(MONTH, 3, GETDATE())),
(N'ND00007', N'Giảm mỡ', 58, DATEADD(MONTH, 2, GETDATE())),
(N'ND00003', N'Giữ cân', 70, DATEADD(MONTH, 6, GETDATE())),
(N'ND00008', N'Giảm cân', 72, DATEADD(MONTH, 3, GETDATE()));
GO
INSERT INTO TienTrinh (NguoiDung_ID, NgayGhi, CanNang_kg, BMI)
VALUES
(N'ND00001', GETDATE(), 70, 22.9),
(N'ND00002', GETDATE(), 50, 19.5),
(N'ND00005', GETDATE(), 65, 23.9),
(N'ND00001', DATEADD(DAY, -1, GETDATE()), 69, 19.2),
(N'ND00010', DATEADD(DAY, -1, GETDATE()), 72, 24.1),
(N'ND00007', DATEADD(DAY, -2, GETDATE()), 55, 21.0),
(N'ND00002', DATEADD(DAY, -1, GETDATE()), 51, 26.9),
(N'ND00013', DATEADD(DAY, -2, GETDATE()), 50, 20.8),
(N'ND00004', GETDATE(), 78, 23.5),
(N'ND00009', DATEADD(DAY, -3, GETDATE()), 60, 21.3),
(N'ND00003', GETDATE(), 70, 23.4),
(N'ND00008', DATEADD(DAY, -1, GETDATE()), 76, 24.3);
GO
INSERT INTO LichHuanLuyen (HLV_ID, NguoiDung_ID, Ngay, NoiDung)
VALUES
(N'HLV00001', N'ND00001', DATEADD(DAY, 1, GETDATE()), N'Hướng dẫn bài tập sức mạnh'),
(N'HLV00002', N'ND00002', DATEADD(DAY, 2, GETDATE()), N'Tập cardio cùng HLV'),
(N'HLV00003', N'ND00004', DATEADD(DAY, 1, GETDATE()), N'Kiểm tra thể lực đầu vào'),
(N'HLV00001', N'ND00008', DATEADD(DAY, 2, GETDATE()), N'Hướng dẫn kỹ thuật Squat'),
(N'HLV00007', N'ND00002', DATEADD(DAY, 1, GETDATE()), N'Tập ngực (Bench Press)'),
(N'HLV00002', N'ND00011', DATEADD(DAY, 3, GETDATE()), N'Buổi tập Yoga nâng cao'),
(N'HLV00009', N'ND00001', DATEADD(DAY, 1, GETDATE()), N'Chỉnh sửa form Deadlift'),
(N'HLV00012', N'ND00005', DATEADD(DAY, 2, GETDATE()), N'Tư vấn dinh dưỡng giảm cân'),
(N'HLV00004', N'ND00010', DATEADD(DAY, 4, GETDATE()), N'Hướng dẫn bài tập vai'),
(N'HLV00008', N'ND00013', DATEADD(DAY, 1, GETDATE()), N'Buổi tập Kickboxing cơ bản'),
(N'HLV00005', N'ND00003', DATEADD(DAY, 5, GETDATE()), N'Tập cardio cường độ cao (HIIT)'),
(N'HLV00010', N'ND00007', DATEADD(DAY, 2, GETDATE()), N'Tập phục hồi và giãn cơ');
GO
INSERT INTO LoiNhac (NguoiDung_ID, NoiDung, NgayNhac)
VALUES
(N'ND00001', N'Uống đủ 2 lít nước mỗi ngày', DATEADD(DAY, 1, GETDATE())),
(N'ND00002', N'Không bỏ bữa sáng', DATEADD(DAY, 2, GETDATE())),
(N'ND00004', N'Nhớ mang theo khăn tập', DATEADD(DAY, 1, GETDATE())),
(N'ND00008', N'Tập cardio 30 phút', DATEADD(DAY, 1, GETDATE())),
(N'ND00001', N'Uống whey protein sau tập', DATEADD(DAY, 1, GETDATE())),
(N'ND00011', N'Mang thảm Yoga', DATEADD(DAY, 3, GETDATE())),
(N'ND00006', N'Tập nặng hôm nay, nhớ khởi động kỹ', DATEADD(DAY, 1, GETDATE())),
(N'ND00002', N'Ăn nhẹ trước khi tập 1 tiếng', DATEADD(DAY, 2, GETDATE())),
(N'ND00005', N'Hạn chót gia hạn gói tập', DATEADD(DAY, 6, GETDATE())),
(N'ND00013', N'Đo lại cân nặng', DATEADD(DAY, 7, GETDATE())),
(N'ND00003', N'Mua thêm thực phẩm bổ sung', DATEADD(DAY, 4, GETDATE())),
(N'ND00009', N'Nghỉ ngơi, không tập quá sức', DATEADD(DAY, 1, GETDATE()));
GO
INSERT INTO SuKienSucKhoe (NguoiDung_ID, TenSuKien, NgayBatDau, NgayKetThuc, GhiChu)
VALUES
(N'ND00001', N'Thử thách plank 7 ngày', GETDATE(), DATEADD(DAY, 7, GETDATE()), N'Chăm chỉ mỗi ngày'),
(N'ND00002', N'Chương trình chạy bộ 5km', GETDATE(), DATEADD(DAY, 5, GETDATE()), N'Rèn luyện thể lực'),
(N'ND00006', N'Thử thách 100 hít đất/ngày', GETDATE(), DATEADD(DAY, 10, GETDATE()), N'Cố gắng'),
(N'ND00001', N'Giải chạy 10km', DATEADD(DAY, 30, GETDATE()), DATEADD(DAY, 30, GETDATE()), N'Đã đăng ký'),
(N'ND00008', N'Tuần lễ detox', DATEADD(DAY, 1, GETDATE()), DATEADD(DAY, 8, GETDATE()), N'Uống nhiều nước ép'),
(N'ND00003', N'Tham gia Workshop Yoga', DATEADD(DAY, 10, GETDATE()), DATEADD(DAY, 11, GETDATE()), N''),
(N'ND00011', N'Kiểm tra sức khỏe định kỳ', DATEADD(DAY, 15, GETDATE()), DATEADD(DAY, 15, GETDATE()), N'Bệnh viện'),
(N'ND00004', N'Thử thách 30 ngày không ăn đường', GETDATE(), DATEADD(DAY, 30, GETDATE()), N'Nghiêm túc'),
(N'ND00010', N'Giải bơi lội CLB', DATEADD(DAY, 20, GETDATE()), DATEADD(DAY, 20, GETDATE()), N''),
(N'ND00002', N'Thi đấu Kickboxing', DATEADD(DAY, 40, GETDATE()), DATEADD(DAY, 40, GETDATE()), N'Chuẩn bị kỹ'),
(N'ND00013', N'Leo núi cuối tuần', DATEADD(DAY, 5, GETDATE()), DATEADD(DAY, 6, GETDATE()), N'Cùng nhóm bạn'),
(N'ND00007', N'Tuần lễ ăn sạch', DATEADD(DAY, 1, GETDATE()), DATEADD(DAY, 8, GETDATE()), N'Không ăn đồ chiên');
GO
INSERT INTO ThanhToan (DangKy_ID, SoTien, NgayThanhToan)
VALUES
(N'DK00001', 500000, GETDATE()),
(N'DK00002', 1200000, GETDATE()),
(N'DK00003', 3500000, GETDATE()),
(N'DK00004', 4000000, GETDATE()),
(N'DK00005', 1200000, DATEADD(DAY, -1, GETDATE())),
(N'DK00001', 500000, DATEADD(DAY, -30, GETDATE())), 
(N'DK00007', 11000000, GETDATE()),
(N'DK00008', 350000, DATEADD(DAY, -2, GETDATE())),
(N'DK00009', 150000, GETDATE()),
(N'DK00010', 2500000, DATEADD(DAY, -5, GETDATE())),
(N'DK00011', 2000000, GETDATE()),
(N'DK00012', 9000000, DATEADD(DAY, -5, GETDATE()));
GO
INSERT INTO DanhGiaBuoiTap (BuoiTap_ID, Diem, NhanXet)
VALUES
(N'BT00001', 4, N'Rất hiệu quả'),
(N'BT00002', 3, N'Ổn định, nên duy trì'),
(N'BT00003', 3, N'Hơi mệt nhưng tốt'),
(N'BT00004', 4, N'Máy chạy mới chạy êm'),
(N'BT00005', 5, N'Tuyệt vời, HLV hỗ trợ tốt'),
(N'BT00006', 2, N'Tập trung bình'),
(N'BT00007', 4, N'Giáo viên Yoga tận tâm'),
(N'BT00008', 3, N'Đông người, phải chờ thiết bị'),
(N'BT00009', 5, N'Hơi mệt, không hoàn thành được'),
(N'BT00010', 3, N'Chạy bộ nhẹ nhàng, thư giãn'),
(N'BT00011', 5, N'Lớp Kickboxing rất vui'),
(N'BT00012', 4, N'Hôm nay hơi đuối');
GO
INSERT INTO ChiTietBuoiTap (BuoiTap_ID, BaiTap_ID, SoHiep, SoLanLap, TrongLuongTa_kg, ThietBi_ID)
VALUES
(N'BT00001', N'BTAP00001', 3, 15, 0, NULL), -- Hít đất
(N'BT00001', N'BTAP00003', 3, 10, 10, N'TB00002'), -- Kéo xà
(N'BT00002', N'BTAP00002', 1, 1, 0, N'TB00001'), -- Chạy bộ
(N'BT00003', N'BTAP00004', 4, 10, 50, NULL), -- Squat
(N'BT00003', N'BTAP00005', 3, 8, 80, NULL), -- Deadlift
(N'BT00004', N'BTAP00002', 1, 1, 0, N'TB00003'), -- Chạy bộ (TB 2)
(N'BT00005', N'BTAP00012', 1, 1, 0, NULL), -- Yoga
(N'BT00006', N'BTAP00006', 4, 10, 60, N'TB00005'), -- Bench Press (Ghế)
(N'BT00007', N'BTAP00001', 3, 10, 40, NULL), -- Hít đất
(N'BT00008', N'BTAP00010', 3, 30, 0, N'TB00011'), -- Nhảy dây
(N'BT00009', N'BTAP00011', 1, 1, 0, N'TB00009'), -- Đạp xe (Xe 1)
(N'BT00012', N'BTAP00013', 3, 10, 15, N'TB00006'), -- Đẩy vai (Tạ 15kg)
(N'BT00001', N'BTAP00004', 3, 12, 40, NULL); -- Buổi tập cũ, bài mới
GO
CREATE PROCEDURE usp_DangKyNguoiDung
    @TenDangNhap NVARCHAR(50),
    @Email NVARCHAR(100),
    @MatKhauHash NVARCHAR(255), 
    @HoTen NVARCHAR(100) = NULL,
    @GioiTinh NVARCHAR(4) = NULL,
    @NgaySinh DATE = NULL,
    @ChieuCao_cm DECIMAL(5,2) = NULL,
    @CanNang_kg DECIMAL(5,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    -- Role 2 là User (Người dùng tập luyện)
    DECLARE @VaiTro_ID INT = 2;
    DECLARE @NguoiDungID CHAR(10);

    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Thêm vào bảng NguoiDung
        INSERT INTO NguoiDung (VaiTro_ID, TenDangNhap, Email, MatKhau, NgayCapNhat)
        VALUES (@VaiTro_ID, @TenDangNhap, @Email, @MatKhauHash, GETDATE());

        -- Lấy NguoiDungID vừa được tạo
        SELECT @NguoiDungID = NguoiDungID FROM NguoiDung WHERE ID = SCOPE_IDENTITY();

        -- 2. Thêm vào bảng HoSo
        INSERT INTO HoSo (NguoiDung_ID, HoTen, GioiTinh, NgaySinh, ChieuCao_cm, CanNang_kg)
        VALUES (@NguoiDungID, @HoTen, @GioiTinh, @NgaySinh, @ChieuCao_cm, @CanNang_kg);

        COMMIT TRANSACTION;
        SELECT 1 AS Result, @NguoiDungID AS NguoiDungID, N'Đăng ký thành công.' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Trả về lỗi
        SELECT 0 AS Result, NULL AS NguoiDungID, ERROR_MESSAGE() AS Message;
    END CATCH
END
GO
CREATE PROCEDURE usp_DangNhap
    @TenDangNhapHoacEmail NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ND.NguoiDungID,
        ND.TenDangNhap,
        ND.Email,
        ND.MatKhau, 
        VT.TenVaiTro
    FROM
        NguoiDung ND
    JOIN
        VaiTro VT ON ND.VaiTro_ID = VT.ID
    WHERE
        ND.TenDangNhap = @TenDangNhapHoacEmail OR ND.Email = @TenDangNhapHoacEmail;
END
GO
CREATE PROCEDURE usp_CapNhatHoSo
    @NguoiDungID CHAR(10),
    @HoTen NVARCHAR(100) = NULL,
    @GioiTinh NVARCHAR(4) = NULL,
    @NgaySinh DATE = NULL,
    @ChieuCao_cm DECIMAL(5,2) = NULL,
    @CanNang_kg DECIMAL(5,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE HoSo
    SET
        HoTen = ISNULL(@HoTen, HoTen),
        GioiTinh = ISNULL(@GioiTinh, GioiTinh),
        NgaySinh = ISNULL(@NgaySinh, NgaySinh),
        ChieuCao_cm = ISNULL(@ChieuCao_cm, ChieuCao_cm),
        CanNang_kg = ISNULL(@CanNang_kg, CanNang_kg)
    WHERE
        NguoiDung_ID = @NguoiDungID;

    -- Cập nhật ngày cập nhật trong bảng NguoiDung
    UPDATE NguoiDung
    SET NgayCapNhat = GETDATE()
    WHERE NguoiDungID = @NguoiDungID;

    IF @@ROWCOUNT > 0
        SELECT 1 AS Result, N'Cập nhật hồ sơ thành công.' AS Message;
    ELSE
        SELECT 0 AS Result, N'Không tìm thấy Hồ sơ để cập nhật.' AS Message;
END
GO
CREATE PROCEDURE usp_ThemBuoiTapMoi
    @NguoiDungID CHAR(10),
    @NgayTap DATE,
    @ThoiLuong_phut INT,
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @BuoiTapID CHAR(10);

    INSERT INTO BuoiTap (NguoiDung_ID, NgayTap, ThoiLuong_phut, GhiChu)
    VALUES (@NguoiDungID, @NgayTap, @ThoiLuong_phut, @GhiChu);

    -- Lấy BuoiTapID vừa được tạo
    SELECT @BuoiTapID = BuoiTapID FROM BuoiTap WHERE ID = SCOPE_IDENTITY();

    SELECT 1 AS Result, @BuoiTapID AS BuoiTapID, N'Thêm buổi tập thành công.' AS Message;
END
GO
CREATE PROCEDURE usp_ThemChiTietBuoiTap
    @BuoiTapID CHAR(10),
    @BaiTapID CHAR(10),
    @SoHiep INT,
    @SoLanLap INT,
    @TrongLuongTa_kg DECIMAL(7,2) = NULL,
    @ThietBiID CHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem BuoiTapID và BaiTapID có tồn tại không 
    IF NOT EXISTS (SELECT 1 FROM BuoiTap WHERE BuoiTapID = @BuoiTapID)
    BEGIN
        SELECT 0 AS Result, N'Lỗi: Buổi tập không tồn tại.' AS Message;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM BaiTap WHERE BaiTapID = @BaiTapID)
    BEGIN
        SELECT 0 AS Result, N'Lỗi: Bài tập không tồn tại.' AS Message;
        RETURN;
    END

    INSERT INTO ChiTietBuoiTap (BuoiTap_ID, BaiTap_ID, SoHiep, SoLanLap, TrongLuongTa_kg, ThietBi_ID)
    VALUES (@BuoiTapID, @BaiTapID, @SoHiep, @SoLanLap, @TrongLuongTa_kg, @ThietBiID);

    SELECT 1 AS Result, N'Thêm chi tiết buổi tập thành công.' AS Message;
END
GO
CREATE PROCEDURE usp_DangKyGoiTap
    @NguoiDungID CHAR(10),
    @GoiTapID CHAR(10),
    @NgayDangKy DATE,
    @SoTienThanhToan DECIMAL(12,2) = NULL -- [FIX]: Cho phép NULL để thanh toán sau
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NgayHetHan DATE;
    DECLARE @ThoiHan_thang INT;
    DECLARE @DangKyID CHAR(10);
    DECLARE @GiaGoi DECIMAL(12,2);

    -- Lấy thông tin gói
    SELECT @ThoiHan_thang = ThoiHan_thang, @GiaGoi = GiaTien
    FROM GoiTap
    WHERE GoiTapID = @GoiTapID;

    IF @ThoiHan_thang IS NULL
    BEGIN
        PRINT N'Lỗi: Gói tập không tồn tại.';
        RETURN;
    END
    -- Tính ngày hết hạn
    SET @NgayHetHan = DATEADD(month, @ThoiHan_thang, @NgayDangKy);

    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Thêm vào bảng DangKyGoiTap
        INSERT INTO DangKyGoiTap (NguoiDung_ID, GoiTap_ID, NgayDangKy, NgayHetHan)
        VALUES (@NguoiDungID, @GoiTapID, @NgayDangKy, @NgayHetHan);

        -- Lấy DangKyID vừa được tạo
        SELECT @DangKyID = DangKyID FROM DangKyGoiTap WHERE ID = SCOPE_IDENTITY();
        -- 2. Xử lý thanh toán 
        IF @SoTienThanhToan IS NOT NULL AND @SoTienThanhToan > 0
        BEGIN
            INSERT INTO ThanhToan (DangKy_ID, SoTien, NgayThanhToan)
            VALUES (@DangKyID, @SoTienThanhToan, @NgayDangKy);
            
            PRINT N'Đăng ký và thanh toán thành công.';
        END
        ELSE
        BEGIN
            PRINT N'Đăng ký thành công (Chưa thanh toán). Vui lòng thanh toán sau.';
        END

        COMMIT TRANSACTION;
        SELECT 1 AS Result, @DangKyID AS DangKyID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT N'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END
GO
CREATE PROCEDURE usp_Top4GoiTapPhoBien
AS
BEGIN
    SELECT TOP 4 
        GT.GoiTapID, 
        GT.TenGoi,
        GT.GiaTien,
        COUNT(DK.ID) AS SoLuotDangKy
    FROM GoiTap GT
    LEFT JOIN DangKyGoiTap DK ON GT.GoiTapID = DK.GoiTap_ID
    GROUP BY GT.GoiTapID, GT.TenGoi, GT.GiaTien 
    ORDER BY COUNT(DK.ID) DESC;
END;
GO
CREATE PROCEDURE usp_GhiNhanTienTrinh
    @NguoiDungID CHAR(10),
    @CanNangHienTai DECIMAL(6,2)
AS
BEGIN
    SET NOCOUNT ON;
    -- 1. Kiểm tra đầu vào
    IF @CanNangHienTai <= 0
    BEGIN
        RAISERROR(N'Lỗi: Cân nặng phải lớn hơn 0.', 16, 1);
        RETURN;
    END

    -- 2. Khai báo biến để tính toán
    DECLARE @ChieuCao DECIMAL(5,2);
    DECLARE @BMI DECIMAL(5,2) = 0; -- Mặc định là 0 nếu không tính được
    -- 3. Lấy chiều cao từ hồ sơ người dùng
    SELECT @ChieuCao = ChieuCao_cm 
    FROM HoSo 
    WHERE NguoiDung_ID = @NguoiDungID;

    -- 4. Tính chỉ số BMI (Nếu có chiều cao hợp lệ)
    -- Công thức: BMI = Cân nặng (kg) / (Chiều cao (m) ^ 2)
    IF @ChieuCao IS NOT NULL AND @ChieuCao > 0
    BEGIN
        SET @BMI = @CanNangHienTai / POWER((@ChieuCao / 100.0), 2);
    END

    -- 5. Thực hiện Ghi nhận (Insert hoặc Update)
    MERGE TienTrinh AS T
    USING (SELECT @NguoiDungID AS ND_ID, CAST(GETDATE() AS DATE) AS Ngay) AS S
    ON (T.NguoiDung_ID = S.ND_ID AND T.NgayGhi = S.Ngay)
    
    WHEN MATCHED THEN
        UPDATE SET 
            CanNang_kg = @CanNangHienTai,
            BMI = @BMI -- Cập nhật luôn chỉ số BMI mới
            
    WHEN NOT MATCHED THEN
        INSERT (NguoiDung_ID, NgayGhi, CanNang_kg, BMI)
        VALUES (@NguoiDungID, CAST(GETDATE() AS DATE), @CanNangHienTai, @BMI);

    PRINT N'Ghi nhận thành công! Cân nặng: ' + FORMAT(@CanNangHienTai, 'N2') + N' kg - BMI: ' + FORMAT(@BMI, 'N2');
END;
GO
CREATE PROCEDURE usp_DashboardNguoiDung
    @NguoiDungID CHAR(10)
AS
BEGIN
    -- SET 1: Thông tin User và Chỉ số cơ thể mới nhất
    SELECT TOP 1 
        ND.TenDangNhap, 
        HS.HoTen, 
        TT.CanNang_kg AS CanNangMoiNhat,
        TT.BMI
    FROM NguoiDung ND
    LEFT JOIN HoSo HS ON ND.NguoiDungID = HS.NguoiDung_ID
    LEFT JOIN TienTrinh TT ON ND.NguoiDungID = TT.NguoiDung_ID
    WHERE ND.NguoiDungID = @NguoiDungID
    ORDER BY TT.NgayGhi DESC; -- Lấy bản ghi tiến trình mới nhất

    -- SET 2: Gói tập đang còn hạn (Active)
    SELECT 
        GT.TenGoi,
        DK.NgayDangKy,
        DK.NgayHetHan,
        DATEDIFF(DAY, GETDATE(), DK.NgayHetHan) AS SoNgayConLai
    FROM DangKyGoiTap DK
    JOIN GoiTap GT ON DK.GoiTap_ID = GT.GoiTapID
    WHERE DK.NguoiDung_ID = @NguoiDungID 
      AND DK.NgayHetHan >= GETDATE();

    -- SET 3: Lịch huấn luyện sắp tới 
    SELECT 
        LHL.Ngay,
        LHL.NoiDung,
        LHL.TrangThai,
        HLV.HoTen AS TenHLV
    FROM LichHuanLuyen LHL
    LEFT JOIN HuanLuyenVien HLV ON LHL.HLV_ID = HLV.HLV_ID
    WHERE LHL.NguoiDung_ID = @NguoiDungID 
      AND LHL.Ngay >= CAST(GETDATE() AS DATE)
    ORDER BY LHL.Ngay ASC;
END;
GO
CREATE PROCEDURE usp_NhatKyTapLuyen
    @NguoiDungID CHAR(10),
    @NgayXem DATE
AS
BEGIN
    SELECT 
        BT.NgayTap,
        BT.ThoiLuong_phut,
        BTAP.TenBaiTap,
        CT.SoHiep,
        CT.SoLanLap,
        CT.TrongLuongTa_kg,
        TB.TenThietBi
    FROM BuoiTap BT
    JOIN ChiTietBuoiTap CT ON BT.BuoiTapID = CT.BuoiTap_ID
    JOIN BaiTap BTAP ON CT.BaiTap_ID = BTAP.BaiTapID
    LEFT JOIN ThietBiTap TB ON CT.ThietBi_ID = TB.ThietBiID
    WHERE BT.NguoiDung_ID = @NguoiDungID 
      AND BT.NgayTap = @NgayXem;
END;
GO
CREATE PROCEDURE usp_ThanhToanGoiTap
    @DangKyID CHAR(10) -- ID của bản ghi trong bảng DangKyGoiTap 
AS
BEGIN
    BEGIN TRY
        DECLARE @SoTien DECIMAL(12,2);
        
        -- 1. Lấy giá tiền của gói tập dựa trên ID đăng ký
        SELECT @SoTien = GT.GiaTien
        FROM DangKyGoiTap DK
        JOIN GoiTap GT ON DK.GoiTap_ID = GT.GoiTapID
        WHERE DK.DangKyID = @DangKyID;

        IF @SoTien IS NULL
        BEGIN
            PRINT N'Lỗi: Không tìm thấy thông tin đăng ký.';
            RETURN;
        END

        -- 2. Kiểm tra xem đã thanh toán chưa (tránh thanh toán trùng)
        IF EXISTS (SELECT 1 FROM ThanhToan WHERE DangKy_ID = @DangKyID)
        BEGIN
            PRINT N'Cảnh báo: Gói đăng ký này đã được thanh toán trước đó.';
            RETURN;
        END

        -- 3. Ghi vào bảng ThanhToan
        INSERT INTO ThanhToan (DangKy_ID, SoTien, NgayThanhToan)
        VALUES (@DangKyID, @SoTien, GETDATE());

        PRINT N'Thanh toán thành công số tiền: ' + FORMAT(@SoTien, 'N0') + ' VND';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
CREATE PROCEDURE usp_HLV_DatLich
    @HLV_ID CHAR(10),
    @NguoiDung_ID CHAR(10),
    @Ngay DATE,
    @NoiDung NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. KIỂM TRA NGÀY THÁNG
    -- Không cho phép đặt lịch ngày quá khứ
    IF @Ngay < CAST(GETDATE() AS DATE)
    BEGIN
        RAISERROR(N'Lỗi: Không thể đặt lịch cho ngày trong quá khứ.', 16, 1);
        RETURN;
    END

    -- 2. KIỂM TRA SỨC CHỨA CỦA HLV 
    -- Đếm số ca "chưa hủy" của HLV trong ngày đó
    DECLARE @SoCaHienTai INT;
    
    SELECT @SoCaHienTai = COUNT(*) 
    FROM LichHuanLuyen 
    WHERE HLV_ID = @HLV_ID 
      AND Ngay = @Ngay 
      AND TrangThai != N'Đã hủy'; -- Chỉ đếm các ca đang hoạt động hoặc đã hoàn thành

    -- Nếu đã đủ 8 ca thì chặn
    IF @SoCaHienTai >= 8
    BEGIN
        RAISERROR(N'Lỗi: HLV này đã kín lịch làm việc (8/8 ca) trong ngày này. Vui lòng chọn ngày khác.', 16, 1);
        RETURN;
    END

    -- 3. KIỂM TRA TRÙNG LẶP 
    -- Ngăn User đặt 2 lịch với CÙNG 1 HLV trong CÙNG 1 ngày 
    IF EXISTS (
        SELECT 1 
        FROM LichHuanLuyen 
        WHERE HLV_ID = @HLV_ID 
          AND NguoiDung_ID = @NguoiDung_ID 
          AND Ngay = @Ngay 
          AND TrangThai != N'Đã hủy'
    )
    BEGIN
        RAISERROR(N'Lỗi: Bạn đã có lịch hẹn với HLV này vào ngày đó rồi.', 16, 1);
        RETURN;
    END
    -- 4. THỰC HIỆN ĐẶT LỊCH 
    BEGIN TRY
        INSERT INTO LichHuanLuyen (HLV_ID, NguoiDung_ID, Ngay, NoiDung, TrangThai)
        VALUES (@HLV_ID, @NguoiDung_ID, @Ngay, @NoiDung, N'Chưa diễn ra');
        PRINT N'Đặt lịch thành công!';
    END TRY
    BEGIN CATCH
        -- Bắt lỗi hệ thống 
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
CREATE PROCEDURE usp_HuyLichHen
    @LichID CHAR(10),
    @LyDoHuy NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NgayLich DATE;
    DECLARE @TrangThaiHienTai NVARCHAR(20);
    -- Lấy thông tin lịch
    SELECT @NgayLich = Ngay, @TrangThaiHienTai = TrangThai
    FROM LichHuanLuyen
    WHERE LichID = @LichID;
    -- Kiểm tra tồn tại
    IF @NgayLich IS NULL
    BEGIN
        PRINT N'Lỗi: Mã lịch hẹn không tồn tại.';
        RETURN;
    END
    -- Kiểm tra logic
    IF @NgayLich < CAST(GETDATE() AS DATE)
    BEGIN
        PRINT N'Lỗi: Không thể hủy lịch hẹn trong quá khứ.';
        RETURN;
    END
    IF @TrangThaiHienTai = N'Đã hủy'
    BEGIN
        PRINT N'Lỗi: Lịch hẹn này đã bị hủy trước đó.';
        RETURN;
    END
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Cập nhật trạng thái
        UPDATE LichHuanLuyen
        SET TrangThai = N'Đã hủy',
            NoiDung = NoiDung + N' (Lý do hủy: ' + @LyDoHuy + N')'
        WHERE LichID = @LichID;

        COMMIT TRANSACTION;
        PRINT N'Hủy lịch hẹn thành công.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'Lỗi hệ thống: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
CREATE FUNCTION fn_HocVienMatTich ()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ND.NguoiDungID,
        ND.TenDangNhap,
        ND.Email,
        HS.HoTen,
        MAX(BT.NgayTap) AS NgayTapGanNhat,
        DATEDIFF(DAY, MAX(BT.NgayTap), GETDATE()) AS SoNgayChuaTap
    FROM NguoiDung ND
    JOIN HoSo HS ON ND.NguoiDungID = HS.NguoiDung_ID
    LEFT JOIN BuoiTap BT ON ND.NguoiDungID = BT.NguoiDung_ID
    WHERE ND.VaiTro_ID = 2 -- Chỉ lấy User (Học viên)
    GROUP BY ND.NguoiDungID, ND.TenDangNhap, ND.Email, HS.HoTen
    HAVING 
        MAX(BT.NgayTap) IS NULL -- Chưa tập bao giờ
        OR 
        DATEDIFF(DAY, MAX(BT.NgayTap), GETDATE()) > 7 -- Quá 7 ngày
);
GO
CREATE TRIGGER trg_UpdateNgayCapNhat
ON NguoiDung
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ cập nhật nếu cột NgayCapNhat chưa được gán giá trị mới trong câu lệnh UPDATE
    IF NOT UPDATE(NgayCapNhat)
    BEGIN
        UPDATE NguoiDung
        SET NgayCapNhat = GETDATE()
        FROM NguoiDung N
        JOIN inserted I ON N.ID = I.ID;
    END
END;
GO
CREATE TRIGGER trg_ChanXoaBaiTap
ON BaiTap
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem có bài tập nào trong danh sách xóa đang được sử dụng không
    IF EXISTS (
        SELECT 1 
        FROM ChiTietBuoiTap C
        JOIN deleted D ON C.BaiTap_ID = D.BaiTapID
    )
    BEGIN
        RAISERROR(N'Lỗi: Không thể xóa bài tập này vì đã có dữ liệu lịch sử tập luyện liên quan.', 16, 1);
        ROLLBACK TRANSACTION; -- Hủy thao tác xóa
        RETURN;
    END

    -- Nếu không có ràng buộc thì tiến hành xóa bình thường
    DELETE FROM BaiTap
    WHERE BaiTapID IN (SELECT BaiTapID FROM deleted);

    PRINT N'Xóa bài tập thành công.';
END;
GO
CREATE PROCEDURE usp_LayBaoCaoDoanhThuNam
    @Nam INT
AS
BEGIN
    -- Trả về bảng dữ liệu gồm 3 cột: Tháng, Tiền, Số Lượng
    SELECT 
        MONTH(NgayThanhToan) AS Thang,
        SUM(SoTien) AS TongDoanhThu,
        COUNT(ID) AS SoLuotGiaoDich
    FROM ThanhToan
    WHERE YEAR(NgayThanhToan) = @Nam
    GROUP BY MONTH(NgayThanhToan)
    ORDER BY Thang;
END;
GO
CREATE PROCEDURE usp_BaoTriThietBi
    @ThietBiID CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ThietBiTap WHERE ThietBiID = @ThietBiID)
    BEGIN
        PRINT N'Lỗi: Thiết bị không tồn tại.';
        RETURN;
    END

    -- Kiểm tra xem thiết bị có đang được sử dụng trong buổi tập nào của ngày hôm nay không
    IF EXISTS (
        SELECT 1 
        FROM ChiTietBuoiTap CT
        JOIN BuoiTap BT ON CT.BuoiTap_ID = BT.BuoiTapID
        WHERE CT.ThietBi_ID = @ThietBiID 
          AND BT.NgayTap = CAST(GETDATE() AS DATE)
    )
    BEGIN
        PRINT N'CẢNH BÁO: Thiết bị này đang được ghi nhận sử dụng trong ngày hôm nay. Vui lòng kiểm tra lại trước khi bảo trì.';
        -- Vẫn cho phép bảo trì nhưng in cảnh báo, hoặc dùng RETURN để chặn hẳn nếu muốn.
    END

    -- Cập nhật trạng thái
    UPDATE ThietBiTap
    SET TrangThai = N'Bảo trì',
        NgayBaoTri = CAST(GETDATE() AS DATE)
    WHERE ThietBiID = @ThietBiID;

    PRINT N'Đã chuyển trạng thái thiết bị sang Bảo trì.';
END;
GO
CREATE TRIGGER trg_ThongBaoHoanThanhBuoiTap
ON LichHuanLuyen
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Chỉ xử lý khi trạng thái chuyển sang 'Hoàn thành'
    INSERT INTO LoiNhac (NguoiDung_ID, NoiDung, NgayNhac)
    SELECT 
        i.NguoiDung_ID,
        N'Chúc mừng! Bạn đã hoàn thành buổi tập ngày ' + CONVERT(NVARCHAR, i.Ngay, 103) + N'. Hãy vào đánh giá buổi tập nhé!',
        CAST(GETDATE() AS DATE)
    FROM inserted i
    JOIN deleted d ON i.LichID = d.LichID
    WHERE i.TrangThai = N'Hoàn thành' AND d.TrangThai != N'Hoàn thành';
END;
GO
CREATE PROCEDURE usp_DanhSachPhanQuyen
AS
BEGIN
    SELECT 
        ND.NguoiDungID,
        ND.TenDangNhap,
        ND.Email,
        HS.HoTen,
        VT.TenVaiTro AS QuyenHienTai,
        ND.NgayCapNhat
    FROM NguoiDung ND
    JOIN VaiTro VT ON ND.VaiTro_ID = VT.ID
    LEFT JOIN HoSo HS ON ND.NguoiDungID = HS.NguoiDung_ID
    ORDER BY VT.ID ASC, ND.NguoiDungID ASC; -- Admin lên đầu
END;
GO
CREATE PROCEDURE usp_HoanThanhBaoTri
    @ThietBiID CHAR(10)
AS
BEGIN
    UPDATE ThietBiTap
    SET TrangThai = N'Hoạt động',
        NgayBaoTri = NULL -- Hoặc giữ ngày bảo trì gần nhất tùy logic của bạn
    WHERE ThietBiID = @ThietBiID;
    
    PRINT N'Thiết bị đã hoạt động trở lại.';
END;
GO
CREATE PROCEDURE usp_LayChiTietNguoiDung
    @NguoiDungID CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ND.NguoiDungID,
        ND.TenDangNhap,
        ND.Email,
        VT.TenVaiTro,
        HS.HoTen,
        HS.GioiTinh,
        HS.NgaySinh,
        HS.ChieuCao_cm,
        HS.CanNang_kg,
        ND.NgayCapNhat
    FROM NguoiDung ND
    JOIN VaiTro VT ON ND.VaiTro_ID = VT.ID
    LEFT JOIN HoSo HS ON ND.NguoiDungID = HS.NguoiDung_ID
    WHERE ND.NguoiDungID = @NguoiDungID;
END;
GO
CREATE PROCEDURE usp_ThemLoiNhacChoHLV
    @HLV_ID CHAR(10),
    @NoiDung NVARCHAR(255),
    @NgayNhac DATE  
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NguoiDungID CHAR(10);

    -- 1. Lấy NguoiDung_ID từ HLV_ID
    SELECT @NguoiDungID = NguoiDung_ID
    FROM HuanLuyenVien
    WHERE HLV_ID = @HLV_ID;

    -- Kiểm tra nếu HLV không tồn tại
    IF @NguoiDungID IS NULL
    BEGIN
        PRINT N'Lỗi: Mã Huấn luyện viên không tồn tại.';
        RETURN;
    END

    -- 2. Thêm vào bảng LoiNhac 
    INSERT INTO LoiNhac (NguoiDung_ID, NoiDung, NgayNhac)
    VALUES (@NguoiDungID, @NoiDung, @NgayNhac);

    PRINT N'Đã thêm lời nhắc cho HLV thành công.';
END;
GO
