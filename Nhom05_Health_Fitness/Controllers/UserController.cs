using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Nhom05_Health_Fitness.Models;
using Nhom05_Health_Fitness.Filters;
using System.Data.SqlClient;
using System.Configuration;

namespace Nhom05_Health_Fitness.Controllers
{
    // ============================================================
    // CUSTOM BASE CONTROLLER (Áp dụng cho Admin, HLV, User)
    // ============================================================
    public class CustomBaseController : Controller
    {
        protected HealthDataContext db;

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            string userConnString = Session["UserConnectionString"] as string;

            // Nếu không có chuỗi kết nối riêng (ví dụ: đang ở trang Index AllowAnonymous)
            if (string.IsNullOrEmpty(userConnString))
            {
                var settings = ConfigurationManager.ConnectionStrings["HEALTHConnectionString"];
                if (settings != null)
                {
                    userConnString = settings.ConnectionString;
                }
            }

            // Khởi tạo DataContext bằng chuỗi kết nối động hoặc chuỗi mặc định
            if (!string.IsNullOrEmpty(userConnString))
                db = new HealthDataContext(userConnString);
            else
                // Fallback an toàn (FIX CS1729)
                db = new HealthDataContext();

            base.OnActionExecuting(filterContext);
        }

        protected string GetCurrentUserID()
        {
            return (Session["NguoiDungID"] as string)?.Trim();
        }
    }

    // ============================================================
    // USER CONTROLLER (Kế thừa)
    // ============================================================
    [CustomAuthorize("User")]
    public class UserController : CustomBaseController
    {
        // *** Các Action của UserController ***

        #region Trang chủ
        // --- TRANG CHỦ ---
        [AllowAnonymous]
        public ActionResult Index()
        {
            var topGoiTap = db.usp_Top4GoiTapPhoBien().ToList();
            ViewBag.TopGoiTap = topGoiTap;

            var topHLV = db.HuanLuyenViens
                           .OrderByDescending(x => x.SoNamKinhNghiem)
                           .Take(4)
                           .ToList();
            ViewBag.TopHLV = topHLV;

            var danhGiaList = (from dg in db.DanhGiaBuoiTaps
                               join bt in db.BuoiTaps on dg.BuoiTap_ID equals bt.BuoiTapID
                               join hs in db.HoSos on bt.NguoiDung_ID equals hs.NguoiDung_ID
                               where dg.Diem >= 4
                               orderby dg.ID descending
                               select new ReviewViewModel
                               {
                                   TenKhach = hs.HoTen,
                                   SoSao = dg.Diem,
                                   NoiDung = dg.NhanXet,
                                   NgayTap = bt.NgayTap
                               }).Take(3).ToList();

            ViewBag.DanhGia = danhGiaList;
            return View();
        }
        #endregion
        #region Danh sách Huấn luyện viên
        // --- DANH SÁCH HLV ---
        public ActionResult DanhSachHLV(string searchString, string sortOrder)
        {
            var query = db.HuanLuyenViens.AsQueryable();

            if (!string.IsNullOrEmpty(searchString))
            {
                query = query.Where(h => h.HoTen.Contains(searchString));
            }

            ViewBag.CurrentSort = sortOrder;

            switch (sortOrder)
            {
                case "name_desc":
                    query = query.OrderByDescending(h => h.HoTen);
                    break;
                case "exp_desc":
                    query = query.OrderByDescending(h => h.SoNamKinhNghiem);
                    break;
                default:
                    query = query.OrderBy(h => h.HoTen);
                    break;
            }

            var result = query.ToList();
            ViewBag.CurrentFilter = searchString;

            return View(result);
        }

        #endregion
        #region Gói tập
        // --- TẤT CẢ GÓI TẬP ---
        public ActionResult TatCaGoiTap(string searchString, decimal? minPrice, decimal? maxPrice)
        {
            var query = db.GoiTaps.AsQueryable();

            if (!string.IsNullOrEmpty(searchString))
            {
                query = query.Where(g => g.TenGoi.Contains(searchString));
            }

            if (minPrice.HasValue)
            {
                query = query.Where(g => g.GiaTien >= minPrice.Value);
            }

            if (maxPrice.HasValue)
            {
                query = query.Where(g => g.GiaTien <= maxPrice.Value);
            }

            var result = query.OrderBy(g => g.GiaTien).ToList();

            ViewBag.CurrentFilter = searchString;
            ViewBag.MinPrice = minPrice;
            ViewBag.MaxPrice = maxPrice;

            return View(result);
        }
        #endregion
        #region Đăng ký gói tập
        // --- ĐĂNG KÝ GÓI TẬP ---
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DangKyGoiTap(string idGoi, decimal? giaTien)
        {
            string nguoiDungID = GetCurrentUserID();
            if (string.IsNullOrEmpty(nguoiDungID))
            {
                return RedirectToAction("Login", "Account");
            }

            try
            {
                db.usp_DangKyGoiTap(nguoiDungID, idGoi, DateTime.Now, giaTien ?? 0);

                TempData["Success"] = "Đăng ký gói tập thành công!";
                return RedirectToAction("LichSuGoiTap");
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
                return RedirectToAction("TatCaGoiTap");
            }
        }
        #endregion
        #region Lịch sử gói tập
        // --- LỊCH SỬ GÓI TẬP ---
        public ActionResult LichSuGoiTap()
        {
            string uid = GetCurrentUserID();
            if (string.IsNullOrEmpty(uid)) return RedirectToAction("Login", "Account");

            var lichSu = (from dk in db.DangKyGoiTaps
                          join gt in db.GoiTaps on dk.GoiTap_ID equals gt.GoiTapID
                          join tt in db.ThanhToans on dk.DangKyID equals tt.DangKy_ID into joinedTT
                          from payment in joinedTT.DefaultIfEmpty()
                          where dk.NguoiDung_ID == uid
                          orderby dk.NgayDangKy descending
                          select new LichSuGoiViewModel
                          {
                              TenGoi = gt.TenGoi,
                              NgayDangKy = dk.NgayDangKy,
                              NgayHetHan = dk.NgayHetHan,
                              GiaTien = gt.GiaTien,
                              DaThanhToan = (payment != null),
                              NgayThanhToan = (payment != null) ? payment.NgayThanhToan : (DateTime?)null
                          }).ToList();

            return View(lichSu);
        }
        #endregion
        #region Nhật ký tập luyện
        // --- NHẬT KÝ TẬP LUYỆN ---
        public ActionResult NhatKy(DateTime? ngayXem)
        {
            string uid = GetCurrentUserID();
            DateTime ngay = ngayXem ?? DateTime.Now.Date;

            var nhatKy = db.usp_NhatKyTapLuyen(uid, ngay).ToList();
            ViewBag.NgayHienTai = ngay;

            var buoiTap = db.BuoiTaps.FirstOrDefault(b => b.NguoiDung_ID == uid && b.NgayTap == ngay);

            if (buoiTap != null)
            {
                ViewBag.BuoiTapID = buoiTap.BuoiTapID;

                var danhGia = db.DanhGiaBuoiTaps.FirstOrDefault(d => d.BuoiTap_ID == buoiTap.BuoiTapID);
                ViewBag.DanhGia = danhGia;
            }

            return View(nhatKy);
        }
        // --- LƯU ĐÁNH GIÁ (POST) ---
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LuuDanhGia(string buoiTapID, int soSao, string nhanXet)
        {
            string uid = GetCurrentUserID();
            if (string.IsNullOrEmpty(uid)) return RedirectToAction("Login", "Account");

            try
            {
                var existing = db.DanhGiaBuoiTaps.FirstOrDefault(d => d.BuoiTap_ID == buoiTapID);

                if (existing == null)
                {
                    var dg = new DanhGiaBuoiTap();
                    dg.BuoiTap_ID = buoiTapID;
                    dg.Diem = soSao;
                    dg.NhanXet = nhanXet;
                    db.DanhGiaBuoiTaps.InsertOnSubmit(dg);
                }
                else
                {
                    existing.Diem = soSao;
                    existing.NhanXet = nhanXet;
                }

                db.SubmitChanges();
                TempData["Success"] = "Cảm ơn bạn đã đánh giá buổi tập!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
            }

            var buoiTap = db.BuoiTaps.FirstOrDefault(b => b.BuoiTapID == buoiTapID);
            return RedirectToAction("NhatKy", new { ngayXem = buoiTap?.NgayTap });
        }
        #endregion
        #region Hồ sơ cá nhân
        // --- HỒ SƠ CÁ NHÂN ---
        public ActionResult HoSoCaNhan()
        {
            string uid = GetCurrentUserID();

            var model = (from h in db.HoSos
                         join u in db.NguoiDungs on h.NguoiDung_ID equals u.NguoiDungID
                         where h.NguoiDung_ID == uid
                         select new UserProfileViewModel
                         {
                             HoTen = h.HoTen,
                             GioiTinh = h.GioiTinh,
                             NgaySinh = h.NgaySinh,
                             ChieuCao = h.ChieuCao_cm,
                             CanNang = h.CanNang_kg,
                             Email = u.Email,
                             TenDangNhap = u.TenDangNhap
                         }).FirstOrDefault();

            return View(model);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CapNhatHoSo(UserProfileViewModel input)
        {
            string uid = GetCurrentUserID();

            try
            {
                db.usp_CapNhatHoSo(
                    uid,
                    input.HoTen,
                    input.GioiTinh,
                    input.NgaySinh,
                    input.ChieuCao,
                    input.CanNang
                );

                Session["TenHienThi"] = input.HoTen;

                TempData["Success"] = "Cập nhật hồ sơ thành công!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
            }

            return RedirectToAction("HoSoCaNhan");
        }
        #endregion
        #region Biểu đồ tiến trình
        // --- BIỂU ĐỒ TIẾN TRÌNH ---
        public ActionResult BieuDoTienTrinh()
        {
            string uid = GetCurrentUserID();

            var data = db.TienTrinhs
                 .Where(t => t.NguoiDung_ID == uid)
                 .OrderBy(t => t.NgayGhi)
                 .Select(t => new { t.NgayGhi, t.CanNang_kg, t.BMI })
                 .ToList();

            ViewBag.Labels = data.Select(x => string.Format("{0:dd/MM}", x.NgayGhi)).ToArray();
            ViewBag.DataWeight = data.Select(x => x.CanNang_kg).ToArray();
            ViewBag.DataBMI = data.Select(x => x.BMI).ToArray();

            if (data.Any())
            {
                ViewBag.StartWeight = data.First().CanNang_kg;
                ViewBag.CurrentWeight = data.Last().CanNang_kg;
                ViewBag.Change = data.Last().CanNang_kg - data.First().CanNang_kg;
            }

            return View();
        }
        #endregion
        #region Đổi mật khẩu
        // --- ĐỔI MẬT KHẨU ---
        public ActionResult DoiMatKhau()
        {
            return View();
        }

        [HttpPost]
        public ActionResult DoiMatKhau(string matKhauCu, string matKhauMoi, string xacNhanMatKhau)
        {
            string uid = GetCurrentUserID();

            if (matKhauMoi != xacNhanMatKhau)
            {
                ViewBag.Error = "Mật khẩu xác nhận không khớp!";
                return View();
            }

            var user = db.NguoiDungs.SingleOrDefault(u => u.NguoiDungID == uid && u.MatKhau == matKhauCu);
            if (user == null)
            {
                ViewBag.Error = "Mật khẩu cũ không đúng!";
                return View();
            }

            user.MatKhau = matKhauMoi;
            db.SubmitChanges();

            ViewBag.Success = "Đổi mật khẩu thành công!";
            return View();
        }
        #endregion
        #region Mục tiêu và Lưu mục tiêu
        // --- MỤC TIÊU TẬP LUYỆN ---
        public ActionResult MucTieu()
        {
            string uid = GetCurrentUserID();

            var goal = db.MucTieus.FirstOrDefault(m => m.NguoiDung_ID == uid);

            var latestProgress = db.TienTrinhs
                                   .Where(t => t.NguoiDung_ID == uid)
                                   .OrderByDescending(t => t.NgayGhi)
                                   .FirstOrDefault();

            ViewBag.CurrentWeight = latestProgress != null ? latestProgress.CanNang_kg : 0;

            return View(goal);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LuuMucTieu(string loaiMucTieu, decimal canNangMucTieu, DateTime hanHoanThanh)
        {
            string uid = GetCurrentUserID();

            try
            {
                var goal = db.MucTieus.FirstOrDefault(m => m.NguoiDung_ID == uid);

                if (goal == null)
                {
                    goal = new MucTieu();
                    goal.NguoiDung_ID = uid;
                    goal.LoaiMucTieu = loaiMucTieu;
                    goal.CanNangMucTieu_kg = canNangMucTieu;
                    goal.HanHoanThanh = hanHoanThanh;
                    db.MucTieus.InsertOnSubmit(goal);
                }
                else
                {
                    goal.LoaiMucTieu = loaiMucTieu;
                    goal.CanNangMucTieu_kg = canNangMucTieu;
                    goal.HanHoanThanh = hanHoanThanh;
                }

                db.SubmitChanges();
                TempData["Success"] = "Đã lưu mục tiêu tập luyện!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
            }

            return RedirectToAction("MucTieu");
        }
        #endregion
        #region Lịch hẹn với Huấn luyện viên và chức năng
        // 1. XEM LỊCH HẸN CỦA TÔI
        public ActionResult LichHenCuaToi()
        {
            string uid = GetCurrentUserID();
            if (string.IsNullOrEmpty(uid)) return RedirectToAction("Login", "Account");

            var listLich = (from l in db.LichHuanLuyens
                            join h in db.HuanLuyenViens on l.HLV_ID equals h.HLV_ID
                            where l.NguoiDung_ID == uid
                            orderby l.Ngay descending
                            select new LichHenViewModel
                            {
                                LichID = l.LichID,
                                TenHLV = h.HoTen,
                                Ngay = l.Ngay,
                                NoiDung = l.NoiDung,
                                TrangThai = l.TrangThai
                            }).ToList();

            return View(listLich);
        }

        // 2. ĐẶT LỊCH TẬP (BOOKING)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DatLichTap(string hlvID, DateTime ngayTap, string noiDung)
        {
            string uid = GetCurrentUserID();
            if (string.IsNullOrEmpty(uid)) return RedirectToAction("Login", "Account");

            try
            {
                db.usp_HLV_DatLich(hlvID, uid, ngayTap, noiDung);

                TempData["Success"] = "Đặt lịch thành công! Hãy đến đúng giờ nhé.";
            }
            catch (SqlException sqlEx)
            {
                TempData["Error"] = sqlEx.Message;
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
            }

            return RedirectToAction("LichHenCuaToi");
        }

        // 3. HỦY LỊCH HẸN
        [HttpPost]
        public ActionResult HuyLich(string lichID, string lyDo)
        {
            try
            {
                db.usp_HuyLichHen(lichID, lyDo ?? "Bận đột xuất");
                TempData["Success"] = "Đã hủy lịch hẹn.";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Không thể hủy: " + ex.Message;
            }

            return RedirectToAction("LichHenCuaToi");
        }

        #endregion
        #region Ghi nhận buổi tập (LOG WORKOUT)

        // 1. GIAO DIỆN TẠO BUỔI TẬP MỚI
        public ActionResult TaoBuoiTap()
        {
            string uid = GetCurrentUserID();
            if (string.IsNullOrEmpty(uid)) return RedirectToAction("Login", "Account");

            return View();
        }

        // 2. XỬ LÝ TẠO BUỔI TẬP (HEADER)
        [HttpPost]
        public ActionResult TaoBuoiTap(DateTime ngayTap, int thoiLuong, string ghiChu)
        {
            string uid = GetCurrentUserID();
            try
            {
                var result = db.usp_ThemBuoiTapMoi(uid, ngayTap, thoiLuong, ghiChu).FirstOrDefault();

                if (result != null)
                {
                    return RedirectToAction("ChiTietBuoiTap", new { maBuoiTap = result.BuoiTapID });
                }
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
            }
            return View();
        }

        // 3. GIAO DIỆN THÊM BÀI TẬP VÀO BUỔI TẬP (DETAILS)
        public ActionResult ChiTietBuoiTap(string maBuoiTap)
        {
            string uid = GetCurrentUserID();
            if (string.IsNullOrEmpty(uid)) return RedirectToAction("Login", "Account");

            var buoiTap = db.BuoiTaps.FirstOrDefault(b => b.BuoiTapID == maBuoiTap && b.NguoiDung_ID == uid);
            if (buoiTap == null) return RedirectToAction("Index");

            var listChiTiet = (from ct in db.ChiTietBuoiTaps
                               join b in db.BaiTaps on ct.BaiTap_ID equals b.BaiTapID
                               join t in db.ThietBiTaps on ct.ThietBi_ID equals t.ThietBiID into joinedT
                               from tb in joinedT.DefaultIfEmpty()
                               where ct.BuoiTap_ID == maBuoiTap
                               select new ChiTietBaiTapDisplay
                               {
                                   TenBai = b.TenBaiTap,
                                   SoHiep = ct.SoHiep ?? 0,
                                   SoLan = ct.SoLanLap ?? 0,
                                   KhoiLuong = ct.TrongLuongTa_kg,
                                   ThietBi = tb.TenThietBi
                               }).ToList();

            ViewBag.DanhSachBaiTap = new SelectList(db.BaiTaps.OrderBy(x => x.TenBaiTap), "BaiTapID", "TenBaiTap");
            ViewBag.DanhSachThietBi = new SelectList(db.ThietBiTaps.Where(x => x.TrangThai == "Hoạt động"), "ThietBiID", "TenThietBi");

            ViewBag.ListDaTap = listChiTiet;

            return View(buoiTap);
        }

        // 4. XỬ LÝ THÊM 1 BÀI TẬP (ADD ITEM)
        [HttpPost]
        public ActionResult ThemBaiTapVaoBuoi(string buoiTapID, string baiTapID, int soHiep, int soLan, decimal? khoiLuong, string thietBiID)
        {
            try
            {
                db.usp_ThemChiTietBuoiTap(buoiTapID, baiTapID, soHiep, soLan, khoiLuong ?? 0, thietBiID);
                TempData["Success"] = "Đã thêm bài tập!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
            }

            return RedirectToAction("ChiTietBuoiTap", new { maBuoiTap = buoiTapID });
        }
        #endregion
        #region Lời nhắc 
        [ChildActionOnly]
        public ActionResult HienThiLoiNhac()
        {
            string uid = GetCurrentUserID();
            var listLoiNhac = new List<LoiNhac>();

            if (!string.IsNullOrEmpty(uid))
            {
                listLoiNhac = db.LoiNhacs
                                .Where(l => l.NguoiDung_ID == uid)
                                .OrderByDescending(l => l.NgayNhac)
                                .Take(5)
                                .ToList();
            }

            return PartialView("_LoiNhacPartial", listLoiNhac);
        }
        #endregion
        // --- THƯ VIỆN BÀI TẬP ---
        public ActionResult ThuVienBaiTap(string searchString, string loaiBaiTap)
        {
            var baiTaps = db.BaiTaps.AsQueryable();

            if (!string.IsNullOrEmpty(searchString))
            {
                baiTaps = baiTaps.Where(s => s.TenBaiTap.Contains(searchString));
            }

            if (!string.IsNullOrEmpty(loaiBaiTap))
            {
                baiTaps = baiTaps.Where(x => x.LoaiBaiTap == loaiBaiTap);
            }

            var listLoai = db.BaiTaps.Select(x => x.LoaiBaiTap).Distinct().ToList();
            ViewBag.LoaiBaiTap = new SelectList(listLoai);

            ViewBag.CurrentFilter = searchString;
            ViewBag.CurrentLoai = loaiBaiTap;

            return View(baiTaps.ToList());
        }
        // --- CẬP NHẬT CÂN NẶNG NHANH (GỌI TỪ MODAL) ---
        [HttpPost]
        public ActionResult CapNhatCanNangNhanh(decimal canNang)
        {
            string uid = GetCurrentUserID();
            if (string.IsNullOrEmpty(uid)) return RedirectToAction("Login", "Account");

            try
            {
                db.usp_GhiNhanTienTrinh(uid, canNang);
                TempData["Success"] = "Đã cập nhật cân nặng mới!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi: " + ex.Message;
            }

            if (Request.UrlReferrer != null)
                return Redirect(Request.UrlReferrer.ToString());

            return RedirectToAction("Index");
        }
    }
}
