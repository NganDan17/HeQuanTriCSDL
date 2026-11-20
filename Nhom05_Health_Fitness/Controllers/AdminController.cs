using Nhom05_Health_Fitness.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Linq;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

namespace Nhom05_Health_Fitness.Controllers
{
    // KẾ THỪA CUSTOM BASE CONTROLLER để dùng SQL Login Admin
    public class AdminController : CustomBaseController
    {
        // GET: Admin
        public ActionResult Admin_TrangChu()
        {
            // TÍNH TỔNG HỘI VIÊN
            int tongHoiVien = db.NguoiDungs
                          .Count(nd => nd.VaiTro_ID == 2);

            ViewBag.TongHoiVien = tongHoiVien;

            // TÍNH TỔNG HLV
            int tongHLV = db.NguoiDungs
                          .Count(nd => nd.VaiTro_ID == 3);

            // HIỂN THỊ DOANH THU THÁNG
            int currentYear = DateTime.Now.Year;
            int currentMonth = DateTime.Now.Month;
            var baoCaoNam = db.usp_LayBaoCaoDoanhThuNam(currentYear);

            var doanhThuThangHienTai = baoCaoNam
                                        .FirstOrDefault(r => r.Thang == currentMonth);
            ViewBag.DoanhThuThang = doanhThuThangHienTai?.TongDoanhThu ?? 0m;
            ViewBag.TongHLV = tongHLV;

            // HIỂN THỊ THIẾT BỊ BẢO TRÌ
            var thietBiBaoTri = db.ThietBiTaps
                        .Where(tb => tb.TrangThai.Trim() == "Bảo trì")
                        .ToList();
            ViewBag.ThietBiBaoTri = thietBiBaoTri;
            return View();
        }

        // DASHBOARD
        public ActionResult Admin_GetThietBiBaoTri()
        {
            var thietBiBaoTri = db.ThietBiTaps
                           .Where(tb => tb.TrangThai.Trim() == "Bảo trì")
                           .Select(tb => new
                           {
                               tb.TenThietBi,
                               tb.TrangThai
                           })
                           .ToList();
            return PartialView("_PartialThietBiBaoTri", thietBiBaoTri);
        }

        // THIẾT BI TẬP
        public ActionResult Admin_QuanLyThietBi()
        {
            var model = db.ThietBiTaps.OrderBy(tb => tb.TrangThai)
                                        .ThenBy(tb => tb.TenThietBi)
                                        .ToList();
            return View(model);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Admin_BaoTri(string id)
        {
            db.usp_BaoTriThietBi(id);
            db.SubmitChanges();

            return RedirectToAction("Admin_QuanLyThietBi");
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Admin_HoanThanhBaoTri(string id)
        {

            db.usp_HoanThanhBaoTri(id);
            db.SubmitChanges();

            return RedirectToAction("Admin_QuanLyThietBi");
        }
        public ActionResult Admin_ChiTietThietBi(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.BadRequest);
            }

            var thietBi = db.ThietBiTaps.SingleOrDefault(tb => tb.ThietBiID.Trim() == id.Trim());

            if (thietBi == null)
            {
                return HttpNotFound();
            }
            var lichSuSuDung = (from ct in db.ChiTietBuoiTaps
                                join bt in db.BuoiTaps on ct.BuoiTap_ID equals bt.BuoiTapID
                                join btap in db.BaiTaps on ct.BaiTap_ID equals btap.BaiTapID
                                where ct.ThietBi_ID.Trim() == id.Trim()
                                orderby bt.NgayTap descending
                                select new
                                {
                                    NgayTap = bt.NgayTap,
                                    TenBaiTap = btap.TenBaiTap,
                                    NguoiDungID = bt.NguoiDung_ID
                                }).Take(5).ToList();
            ViewBag.LichSuSuDung = lichSuSuDung;
            return View(thietBi);
        }

        // TỔNG DOANH THU
        public ActionResult Admin_BaoCaoDoanhThu()
        {
            int currentYear = DateTime.Now.Year;
            var baoCaoNam = db.usp_LayBaoCaoDoanhThuNam(currentYear).ToList();

            return View(baoCaoNam);
        }
        //XEM CHI TIẾT HỘI VIÊN
        public ActionResult Admin_DanhSachHoiVien()
        {
            // Lọc ra những người có QuyenHienTai là 'User' từ Stored Procedure
            var listHoiVien = db.usp_DanhSachPhanQuyen()
                                .Where(x => x.QuyenHienTai == "User")
                                .ToList();
            return View(listHoiVien);
        }
        // Trong file: Controllers/AdminController.cs

        public ActionResult Admin_ChiTietUser(string id)
        {
            if (string.IsNullOrEmpty(id)) return RedirectToAction("Admin_DanhSachHoiVien");

            // 1. Gọi Stored Procedure mới (đã Trim ID)
            var result = db.usp_LayChiTietNguoiDung(id.Trim()).FirstOrDefault();

            if (result == null) return HttpNotFound();

            // 2. Map dữ liệu sang ViewModel
            var model = new UserProfileViewModel
            {
                // Thông tin tài khoản
                TenDangNhap = result.TenDangNhap,
                Email = result.Email,

                // Thông tin hồ sơ
                HoTen = result.HoTen,
                GioiTinh = result.GioiTinh,
                NgaySinh = result.NgaySinh,
                ChieuCao = result.ChieuCao_cm,
                CanNang = result.CanNang_kg
            };

            // 3. Lấy thêm các thông tin phụ (BMI, Gói tập...)
            // (Giữ nguyên logic lấy TienTrinh và DangKyGoiTap như cũ)
            var latestStats = db.TienTrinhs
                                .Where(t => t.NguoiDung_ID == result.NguoiDungID)
                                .OrderByDescending(t => t.NgayGhi)
                                .FirstOrDefault();

            // Trong AdminController.cs -> Admin_ChiTietUser

            // Cách mới: Lấy trực tiếp đối tượng DangKyGoiTap
            var activePackages = db.DangKyGoiTaps
                                   .Where(dk => dk.NguoiDung_ID.Trim() == id && dk.NgayHetHan >= DateTime.Now)
                                   .ToList();

            ViewBag.ActivePackages = activePackages;

            ViewBag.UserID = result.NguoiDungID;
            ViewBag.Role = result.TenVaiTro; // Lấy trực tiếp từ SP
            ViewBag.LatestStats = latestStats;
            ViewBag.ActivePackages = activePackages;

            return View(model);
        }
        //SỬA THÔNG TIN NGƯỜI DÙNG
        // --- GET: Hiển thị form sửa thông tin ---
        public ActionResult Admin_SuaUser(string id)
        {
            if (string.IsNullOrEmpty(id)) return RedirectToAction("Admin_DanhSachHoiVien");

            // 1. Lấy thông tin chi tiết bằng SP
            var result = db.usp_LayChiTietNguoiDung(id.Trim()).FirstOrDefault();

            if (result == null) return HttpNotFound();

            // 2. Đổ dữ liệu vào ViewModel
            var model = new UserProfileViewModel
            {
                // Gán ID vào TenDangNhap (hoặc tạo prop mới) để giữ tham chiếu
                TenDangNhap = result.NguoiDungID,

                // Các thông tin hiển thị
                Email = result.Email,
                HoTen = result.HoTen,
                GioiTinh = result.GioiTinh,
                NgaySinh = result.NgaySinh,
                ChieuCao = result.ChieuCao_cm,
                CanNang = result.CanNang_kg
            };

            ViewBag.UserID = result.NguoiDungID; // Lưu ID để dùng cho nút Quay lại
            return View(model);
        }

        // --- POST: Lưu thay đổi ---
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Admin_SuaUser(string id, UserProfileViewModel input)
        {
            id = id.Trim(); // Xử lý ID

            try
            {
                // 1. Gọi SP để cập nhật thông tin cá nhân (Hồ sơ)
                db.usp_CapNhatHoSo(
                    id,
                    input.HoTen,
                    input.GioiTinh,
                    input.NgaySinh,
                    input.ChieuCao,
                    input.CanNang
                );

                // 2. Cập nhật Email (Vì SP usp_CapNhatHoSo không sửa bảng NguoiDung)
                // Nếu bạn cho phép admin sửa email hội viên:
                var user = db.NguoiDungs.FirstOrDefault(u => u.NguoiDungID == id);
                if (user != null && !string.IsNullOrEmpty(input.Email) && user.Email != input.Email)
                {
                    user.Email = input.Email;
                    db.SubmitChanges();
                }

                TempData["Success"] = "Cập nhật hồ sơ thành công!";
                return RedirectToAction("Admin_ChiTietUser", new { id = id });
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Lỗi cập nhật: " + ex.Message;
                ViewBag.UserID = id;
                return View(input);
            }
        }
        //XEM THÔNG TIN HLV
        // --- DANH SÁCH HUẤN LUYỆN VIÊN 
        public ActionResult Admin_DanhSachHLV()
        {
            // 1. Dùng LINQ nối bảng để lấy thông tin HLV
            var listHLV = (from u in db.NguoiDungs
                           join hlv in db.HuanLuyenViens on u.NguoiDungID equals hlv.NguoiDung_ID
                           join vt in db.VaiTros on u.VaiTro_ID equals vt.ID
                           where u.VaiTro_ID == 3 // 3 là Vai trò HLV
                           select new Nhom05_Health_Fitness.Models.usp_DanhSachPhanQuyenResult
                           {
                               // Map dữ liệu vào class kết quả có sẵn để tận dụng View cũ
                               NguoiDungID = u.NguoiDungID,
                               TenDangNhap = u.TenDangNhap,
                               Email = u.Email,
                               HoTen = hlv.HoTen, // Lấy tên từ bảng HuanLuyenVien
                               QuyenHienTai = vt.TenVaiTro,
                               NgayCapNhat = u.NgayCapNhat
                           }).ToList();

            return View(listHLV);
        }
        // --- 1. HIỂN THỊ MA TRẬN PHÂN QUYỀN ---
        public ActionResult Admin_QuanLyQuyenTruyCap()
        {
            // Lấy danh sách tất cả các bảng trong Database (trừ các bảng hệ thống)
            string queryTables = "SELECT name FROM sys.tables WHERE name != 'sysdiagrams' ORDER BY name";
            var listTables = db.ExecuteQuery<string>(queryTables).ToList();

            var model = new List<BangPhanQuyenViewModel>();

            foreach (var table in listTables)
            {
                // Kiểm tra quyền hiện tại của HLV trên bảng này
                string sqlCheckHLV = $"SELECT COUNT(*) FROM sys.database_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('ROLE_HUANLUYENVIEN') AND major_id = OBJECT_ID('{table}') AND permission_name = 'SELECT' AND state = 'G'";
                int hlvHasRight = db.ExecuteQuery<int>(sqlCheckHLV).Single();

                // Kiểm tra quyền hiện tại của Hội viên trên bảng này
                string sqlCheckUser = $"SELECT COUNT(*) FROM sys.database_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('ROLE_HOIVIEN') AND major_id = OBJECT_ID('{table}') AND permission_name = 'SELECT' AND state = 'G'";
                int userHasRight = db.ExecuteQuery<int>(sqlCheckUser).Single();

                model.Add(new BangPhanQuyenViewModel
                {
                    TenBang = table,
                    HlvDuocXem = hlvHasRight > 0,
                    HoiVienDuocXem = userHasRight > 0
                });
            }

            return View(model);
        }

        // --- 2. CẬP NHẬT QUYỀN (GỌI AJAX) ---
        [HttpPost]
        public ActionResult CapNhatQuyenBang(string tenBang, string role, bool choPhep)
        {
            try
            {
                // Xác định tên Role trong SQL
                string roleSQL = (role == "HLV") ? "ROLE_HUANLUYENVIEN" : "ROLE_HOIVIEN";

                string command = "";
                if (choPhep)
                {
                    // Cấp quyền: GRANT SELECT ON [TenBang] TO [ROLE]
                    command = $"GRANT SELECT ON [{tenBang}] TO {roleSQL}";
                }
                else
                {
                    // Thu hồi quyền: REVOKE SELECT ON [TenBang] FROM [ROLE]
                    command = $"REVOKE SELECT ON [{tenBang}] FROM {roleSQL}";
                }

                // Thực thi lệnh SQL trực tiếp
                db.ExecuteCommand(command);

                return Json(new { success = true, msg = "Đã cập nhật quyền thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, msg = "Lỗi SQL: " + ex.Message });
            }
        }
    }
}