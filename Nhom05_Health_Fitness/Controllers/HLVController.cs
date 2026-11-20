using Nhom05_Health_Fitness.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Mvc;
namespace Nhom05_Health_Fitness.Controllers
{
    public class HLVController : CustomBaseController
    {
        // Preserve the original HLV data-access scope; use the shared local configuration.
        private new HealthDataContext db = new HealthDataContext();

        // ==========================================
        // 0. CÁC HÀM HỖ TRỢ (PRIVATE)
        // ==========================================
        private NguoiDung GetCurrentUser()
        {
            return Session["NguoiDung"] as NguoiDung;
        }

        private HuanLuyenVien GetCurrentHLVInfo()
        {
            return Session["HLVInfo"] as HuanLuyenVien;
        }
        private bool CheckUserPackageStatus(string nguoiDungId)
        {
            try
            {
                // Gọi hàm SQL trực tiếp: SELECT dbo.fn_KiemTraHanGoiTap('ID')
                string query = "SELECT dbo.fn_KiemTraHanGoiTap({0})";
                // ExecuteQuery trả về danh sách, ta lấy giá trị đầu tiên
                return db.ExecuteQuery<bool>(query, nguoiDungId).FirstOrDefault();
            }
            catch
            {
                return false; // Mặc định là false nếu lỗi
            }
        }

        // ==========================================
        // 1. TRANG CHỦ (DASHBOARD)
        // ==========================================
        public ActionResult HLVTrangChu()
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            string hlvId = hlvInfo.HLV_ID;
            var viewModel = new DashboardHLVViewModel();

            // --- 1. Danh sách học viên nghỉ quá 7 ngày ---
            try
            {
                var inactiveList = db.fn_HocVienMatTich(hlvId, 7).ToList();
                viewModel.HocVienKhongTap = inactiveList.Select(s => new HocVienKhongTapInfo
                {
                    HoTen = s.HoTen,
                    SoNgayKhongTap = s.SoNgayKhongTap ?? 0
                }).ToList();
            }
            catch
            {
                // Fallback an toàn
                viewModel.HocVienKhongTap = new List<HocVienKhongTapInfo>();
            }

            // --- 2. Tổng học viên ---
            var studentIDs = db.LichHuanLuyens
                             .Where(l => l.HLV_ID == hlvId)
                             .Select(l => l.NguoiDung_ID)
                             .Distinct()
                             .ToList();

            viewModel.TongHocVien = studentIDs.Count();

            // --- 3. Thống kê buổi tập ---
            DateTime today = DateTime.Today;
            DateTime startOfMonth = new DateTime(today.Year, today.Month, 1);
            DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);

            var sessionsThisMonth = db.BuoiTaps
                    .Where(bt => studentIDs.Contains(bt.NguoiDung_ID) &&
                                 bt.NgayTap >= startOfMonth && bt.NgayTap <= endOfMonth)
                    .ToList();

            int diff = (int)today.DayOfWeek;
            DateTime startOfWeek = today.AddDays(-diff);
            DateTime endOfWeek = startOfWeek.AddDays(6);

            viewModel.SoBuoiTuanNay = sessionsThisMonth.Count(bt => bt.NgayTap >= startOfWeek && bt.NgayTap <= endOfWeek);
            viewModel.GioTapThangNay = (sessionsThisMonth.Sum(bt => bt.ThoiLuong_phut ?? 0)) / 60;
            viewModel.SoBuoiSapToi = db.LichHuanLuyens.Count(l => l.HLV_ID == hlvId && l.Ngay > today && l.TrangThai == "Chưa diễn ra");

            // --- 4. Biểu đồ: Sessions Per Month (6 tháng) ---
            DateTime startChartDate = today.AddMonths(-5);
            DateTime iterator = new DateTime(startChartDate.Year, startChartDate.Month, 1);

            var sessionsRaw = db.BuoiTaps
                 .Where(bt => studentIDs.Contains(bt.NguoiDung_ID) &&
                              bt.NgayTap >= iterator && bt.NgayTap <= today)
                 .ToList()
                 .GroupBy(bt => new { bt.NgayTap.Value.Year, bt.NgayTap.Value.Month })
                 .Select(g => new { Year = g.Key.Year, Month = g.Key.Month, Count = g.Count() })
                 .ToList();

            for (int i = 0; i < 6; i++)
            {
                var data = sessionsRaw.FirstOrDefault(d => d.Year == iterator.Year && d.Month == iterator.Month);
                viewModel.SessionsPerMonthLabels.Add(iterator.ToString("MMM"));
                viewModel.SessionsPerMonthData.Add(data?.Count ?? 0);
                iterator = iterator.AddMonths(1);
            }

            // --- 5. Biểu đồ: Tiến độ trung bình (Cân nặng) ---
            DateTime fiveWeeksAgo = today.AddDays(-35);
            var progressRaw = db.TienTrinhs
                .Where(t => studentIDs.Contains(t.NguoiDung_ID) &&
                            t.NgayGhi >= fiveWeeksAgo && t.CanNang_kg > 0)
                .OrderBy(t => t.NgayGhi)
                .ToList()
                .GroupBy(t => CultureInfo.CurrentCulture.Calendar.GetWeekOfYear(
                                 t.NgayGhi.Value, CalendarWeekRule.FirstDay, DayOfWeek.Sunday))
                .Select(g => new { Week = g.Key, AvgWeight = g.Average(x => x.CanNang_kg) })
                .ToList();

            foreach (var item in progressRaw)
            {
                viewModel.StudentProgressLabels.Add($"W{item.Week}");
                viewModel.StudentProgressData.Add((int)Math.Round(item.AvgWeight ?? 0));
            }
            viewModel.AvgProgress = viewModel.StudentProgressData.Any() ? viewModel.StudentProgressData.Last() : 0;

            return View(viewModel);
        }

        // ==========================================
        // 2. ĐĂNG NHẬP & ĐĂNG XUẤT
        // ==========================================
        [HttpGet]
        public ActionResult HLVDangNhap()
        {
            return View();
        }

        [HttpPost]
        public ActionResult HLVDangNhap(string Username, string Pass)
        {
            var nguoiDung = db.NguoiDungs.FirstOrDefault(n =>
                (n.Email == Username || n.TenDangNhap == Username) && n.MatKhau == Pass);

            if (nguoiDung == null)
            {
                ViewBag.ThongBaoLoi = "Tên đăng nhập hoặc mật khẩu không chính xác.";
                return View();
            }

            if (nguoiDung.VaiTro_ID != 3)
            {
                ViewBag.ThongBaoLoi = "Tài khoản này không có quyền Huấn Luyện Viên.";
                return View();
            }

            var hoSo = db.HoSos.FirstOrDefault(hs => hs.NguoiDung_ID == nguoiDung.NguoiDungID);
            if (hoSo == null) hoSo = new HoSo { HoTen = nguoiDung.TenDangNhap, NguoiDung_ID = nguoiDung.NguoiDungID };

            var hlvInfo = db.HuanLuyenViens.FirstOrDefault(h => h.NguoiDung_ID == nguoiDung.NguoiDungID);
            if (hlvInfo == null) hlvInfo = db.HuanLuyenViens.FirstOrDefault(h => h.HoTen == hoSo.HoTen);

            if (hlvInfo == null)
            {
                ViewBag.ThongBaoLoi = "Lỗi dữ liệu: Tài khoản chưa có thông tin chuyên môn HLV.";
                return View();
            }

            Session["NguoiDung"] = nguoiDung;
            Session["HLVInfo"] = hlvInfo;
            Session["HoSo"] = hoSo;
            Session["TenHLV"] = hoSo.HoTen;

            return RedirectToAction("HLVTrangChu");
        }

        public ActionResult HLVDangXuat()
        {
            Session.Clear();
            return RedirectToAction("HLVDangNhap");
        }

        // ==========================================
        // 3. QUẢN LÝ HỌC VIÊN
        // ==========================================
        public ActionResult StudentInfo(string searchString)
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            string hlvId = hlvInfo.HLV_ID;
            ViewBag.CurrentFilter = searchString;

            var studentIDs = db.LichHuanLuyens
                .Where(l => l.HLV_ID == hlvId)
                .Select(l => l.NguoiDung_ID)
                .Distinct().ToList();

            var studentsList = new List<StudentInfoViewModel>();

            foreach (var id in studentIDs)
            {
                var hs = db.HoSos.FirstOrDefault(h => h.NguoiDung_ID == id);
                var latestProgress = db.TienTrinhs.Where(t => t.NguoiDung_ID == id).OrderByDescending(t => t.NgayGhi).FirstOrDefault();
                var latestGoal = db.MucTieus.Where(m => m.NguoiDung_ID == id).OrderByDescending(m => m.ID).FirstOrDefault();
                int progressPercent = (latestGoal != null) ? 75 : 0;

                // [CẬP NHẬT 1] Gọi hàm kiểm tra tại đây
                bool isPackageValid = CheckUserPackageStatus(id);

                var student = new StudentInfoViewModel
                {
                    NguoiDungID = id,
                    Name = (hs != null) ? hs.HoTen : "Chưa cập nhật",
                    Gender = (hs != null) ? hs.GioiTinh : "N/A",
                    Height = (hs != null) ? hs.ChieuCao_cm : null,
                    Weight = latestProgress != null ? latestProgress.CanNang_kg : (hs?.CanNang_kg),
                    Goal = latestGoal != null ? latestGoal.LoaiMucTieu : "Chưa đặt",
                    LastUpdate = latestProgress?.NgayGhi,
                    Progress = progressPercent,

                    // [CẬP NHẬT 2] Gán trạng thái vào ViewModel
                    // Lưu ý: Bạn cần thêm thuộc tính TrangThaiGoiTap (string) vào class StudentInfoViewModel
                    TrangThaiGoiTap = isPackageValid ? "Còn hạn" : "Hết hạn"
                };
                studentsList.Add(student);
            }

            if (!String.IsNullOrEmpty(searchString))
            {
                searchString = searchString.ToLower();
                studentsList = studentsList.Where(s =>
                    (s.Name != null && s.Name.ToLower().Contains(searchString)) ||
                    (s.NguoiDungID != null && s.NguoiDungID.ToLower().Contains(searchString))
                ).ToList();
            }

            return View(new StudentInfoPageViewModel { Students = studentsList });
        }

        public ActionResult ViewStudentDetail(string id)
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            id = id?.Trim();
            var hoSo = db.HoSos.FirstOrDefault(h => h.NguoiDung_ID == id);
            if (hoSo == null) return HttpNotFound();

            var latestProgress = db.TienTrinhs.Where(t => t.NguoiDung_ID == id).OrderByDescending(t => t.NgayGhi).FirstOrDefault();
            var latestGoal = db.MucTieus.Where(m => m.NguoiDung_ID == id).OrderByDescending(m => m.ID).FirstOrDefault();
            var progressHistory = db.TienTrinhs.Where(t => t.NguoiDung_ID == id && t.CanNang_kg.HasValue).OrderBy(t => t.NgayGhi).ToList();

            // [CẬP NHẬT 3] Kiểm tra gói tập cho trang chi tiết
            bool isPackageValid = CheckUserPackageStatus(id);

            var viewModel = new StudentDetailViewModel
            {
                NguoiDungID = id,
                HoTen = hoSo.HoTen,
                Gender = hoSo.GioiTinh,
                Height = hoSo.ChieuCao_cm,
                Weight = latestProgress?.CanNang_kg ?? hoSo.CanNang_kg,
                BMI = latestProgress?.BMI,
                Goal = latestGoal?.LoaiMucTieu ?? "Chưa đặt mục tiêu",
                GoalTarget = (latestGoal?.CanNangMucTieu_kg != null) ? $"{latestGoal.CanNangMucTieu_kg} kg" : "N/A",

                // [CẬP NHẬT 4] Gán trạng thái vào ViewModel chi tiết
                // Lưu ý: Thêm thuộc tính PackageStatus (string) vào class StudentDetailViewModel
                PackageStatus = isPackageValid ? "Active (Còn hạn)" : "Inactive (Hết hạn)"
            };

            if (latestGoal?.HanHoanThanh != null)
            {
                var deadline = latestGoal.HanHoanThanh.Value.Date;
                if (deadline < DateTime.Today) viewModel.GoalTimeline = "Đã quá hạn";
                else viewModel.GoalTimeline = $"Còn {(deadline - DateTime.Today).Days} ngày";
            }
            else viewModel.GoalTimeline = "Không có thời hạn";

            foreach (var entry in progressHistory)
            {
                viewModel.ProgressChartLabels.Add(entry.NgayGhi.Value.ToString("dd/MM"));
                viewModel.ProgressChartData.Add(entry.CanNang_kg.Value);
            }

            return View(viewModel);
        }

        // ==========================================
        // 4. NHẬT KÝ HOẠT ĐỘNG (Activity Logs) - [ĐÃ CẬP NHẬT LOGIC BIỂU ĐỒ]
        // ==========================================
        // GET: ActivityLogs
        public ActionResult ActivityLogs(string studentId)
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            string hlvId = hlvInfo.HLV_ID;

            // 1. Lấy danh sách học viên của HLV này
            var listStudents = (from l in db.LichHuanLuyens
                                join h in db.HoSos on l.NguoiDung_ID equals h.NguoiDung_ID
                                where l.HLV_ID == hlvId
                                select new { h.NguoiDung_ID, h.HoTen })
                                .Distinct()
                                .ToList();

            // 2. Xử lý trường hợp chưa chọn học viên (studentId null)
            if (string.IsNullOrEmpty(studentId))
            {
                var first = listStudents.FirstOrDefault();
                if (first != null)
                {
                    // Redirect lại chính trang này kèm theo studentId của người đầu tiên
                    return RedirectToAction("ActivityLogs", new { studentId = first.NguoiDung_ID.Trim() });
                }
                else
                {
                    // Nếu HLV chưa có học viên nào
                    return RedirectToAction("StudentInfo");
                }
            }

            // Chuẩn hóa ID
            studentId = studentId.Trim();

            // 3. Lấy thông tin chi tiết học viên đang chọn
            var currentStudent = db.HoSos.FirstOrDefault(h => h.NguoiDung_ID == studentId);
            if (currentStudent == null) return HttpNotFound();

            var model = new ActivityLogsViewModel
            {
                StudentName = currentStudent.HoTen,
                SelectedStudentId = studentId
            };

            // 4. Đổ dữ liệu Dropdown (Quan trọng: So sánh với studentId)
            foreach (var s in listStudents)
            {
                model.StudentsList.Add(new SelectListItem
                {
                    Value = s.NguoiDung_ID.Trim(),
                    Text = s.HoTen,
                    // So sánh không phân biệt hoa thường để đảm bảo chính xác
                    Selected = s.NguoiDung_ID.Trim().Equals(studentId, StringComparison.OrdinalIgnoreCase)
                });
            }

            // --- 5. DỮ LIỆU BIỂU ĐỒ (Dùng studentId thay vì id) ---
            DateTime today = DateTime.Today;
            DateTime sevenDaysAgo = today.AddDays(-6);

            // Chart 1: Hoạt động tuần qua
            for (int i = 0; i < 7; i++)
            {
                DateTime d = sevenDaysAgo.AddDays(i);
                model.ChartLabels.Add(d.ToString("dd/MM"));

                int count = db.BuoiTaps.Count(b => b.NguoiDung_ID == studentId && b.NgayTap == d);
                model.WeeklyActivityData.Add(count);
            }

            // Chart 2: Tiến trình cân nặng
            var progressList = db.TienTrinhs
                .Where(t => t.NguoiDung_ID == studentId && t.CanNang_kg.HasValue)
                .OrderBy(t => t.NgayGhi)
                .Take(10).ToList();

            if (progressList.Any())
            {
                foreach (var item in progressList)
                {
                    model.WeightLabels.Add(item.NgayGhi.Value.ToString("dd/MM"));
                    model.WeightData.Add(item.CanNang_kg.Value);
                }
            }
            else if (currentStudent.CanNang_kg.HasValue)
            {
                model.WeightLabels.Add(DateTime.Today.ToString("dd/MM"));
                model.WeightData.Add(currentStudent.CanNang_kg.Value);
            }

            // --- 6. DANH SÁCH NHẬT KÝ TẬP LUYỆN ---
            var recentLogs = db.BuoiTaps
                .Where(b => b.NguoiDung_ID == studentId)
                .OrderByDescending(b => b.NgayTap)
                .Take(10).ToList();

            foreach (var b in recentLogs)
            {
                var exercises = (from ct in db.ChiTietBuoiTaps
                                 join bt in db.BaiTaps on ct.BaiTap_ID equals bt.BaiTapID
                                 where ct.BuoiTap_ID == b.BuoiTapID
                                 select bt.TenBaiTap).ToList();

                string exerciseList = string.Join(", ", exercises);
                int duration = b.ThoiLuong_phut ?? 0;

                model.WorkoutLogs.Add(new WorkoutLogItem
                {
                    Date = b.NgayTap.HasValue ? b.NgayTap.Value.ToString("dd/MM/yyyy") : "N/A",
                    SessionType = "Tập luyện",
                    Duration = duration,
                    Exercises = string.IsNullOrEmpty(exerciseList) ? "Chưa cập nhật" : exerciseList,
                    Calories = duration * 6 // Giả định tính toán calories
                });
            }

            // QUAN TRỌNG: Xóa ModelState để Dropdown hiển thị đúng người được chọn (Selected = true)
            ModelState.Clear();

            return View(model);
        }        // GET: Schedule Management
        public ActionResult Schedule()
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            string hlvId = hlvInfo.HLV_ID;
            var model = new ScheduleViewModel();

            // 1. Lấy danh sách học viên (Giữ nguyên)
            var students = (from l in db.LichHuanLuyens
                            join h in db.HoSos on l.NguoiDung_ID equals h.NguoiDung_ID
                            where l.HLV_ID == hlvId
                            select new { h.NguoiDung_ID, h.HoTen })
                            .Distinct().ToList();

            foreach (var s in students)
            {
                model.StudentsList.Add(new SelectListItem
                {
                    Value = s.NguoiDung_ID.Trim(),
                    Text = s.HoTen
                });
            }

            // 2. Lấy danh sách Lịch dạy (SỬA ĐOẠN NÀY)
            var schedules = (from l in db.LichHuanLuyens
                             join h in db.HoSos on l.NguoiDung_ID equals h.NguoiDung_ID
                             where l.HLV_ID == hlvId
                             orderby l.Ngay
                             select new
                             {
                                 // --- SỬA LỖI TẠI ĐÂY ---
                                 // Thay l.LichID (string "LHL...") bằng l.ID (int)
                                 RealID = l.ID,

                                 h.HoTen,
                                 l.Ngay,
                                 l.TrangThai,
                                 Duration = 60 // Giả định thời lượng
                             }).ToList();

            DateTime now = DateTime.Now;

            // Phân loại Sắp tới / Đã xong
            foreach (var item in schedules)
            {
                var sItem = new ScheduleItem
                {
                    // Gán RealID (int) vào LichID (int) -> Hết lỗi
                    LichID = item.RealID,

                    StudentName = item.HoTen,
                    Date = item.Ngay.HasValue ? item.Ngay.Value : DateTime.MinValue,
                    Time = "09:00", // Giả định giờ
                    Duration = item.Duration,
                    Status = item.TrangThai
                };

                // Logic phân loại
                if (item.Ngay >= now.Date && item.TrangThai == "Chưa diễn ra")
                {
                    model.UpcomingList.Add(sItem);
                }
                else
                {
                    model.CompletedList.Add(sItem);
                }
            }

            // 3. Tính thống kê
            model.UpcomingSessions = model.UpcomingList.Count;
            model.CompletedSessions = model.CompletedList.Count;
            model.TotalTeachingHours = (model.CompletedSessions * 60) / 60;

            return View(model);
        }

        // POST: Add New Session
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddSchedule(ScheduleViewModel model)
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            try
            {
                if (model.Date.HasValue && !string.IsNullOrEmpty(model.SelectedStudentId))
                {
                    // Gọi Stored Procedure: usp_HLV_DatLich
                    // Lưu ý: SP này trong SQL của bạn chỉ nhận Ngày, chưa có Giờ/Phút
                    db.usp_HLV_DatLich(
                        hlvInfo.HLV_ID,
                        model.SelectedStudentId,
                        model.Date.Value,
                        model.Notes ?? "Lịch tập mới"
                    );

                    TempData["SuccessMessage"] = "Thêm lịch tập thành công!";
                }
                else
                {
                    TempData["ErrorMessage"] = "Vui lòng nhập đầy đủ thông tin.";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi: " + ex.Message;
            }

            return RedirectToAction("Schedule");
        }
        // POST: Edit Schedule
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditSchedule(ScheduleViewModel model)
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            try
            {
                // Lấy lịch cũ từ DB
                // Lưu ý: model.LichID ở đây là ID (int) thực tế của bảng
                var lich = db.LichHuanLuyens.SingleOrDefault(l => l.ID == model.LichID);

                if (lich != null && lich.HLV_ID == hlvInfo.HLV_ID)
                {
                    if (model.Date.HasValue)
                    {
                        // Cập nhật thông tin
                        lich.Ngay = model.Date.Value;
                        lich.NoiDung = model.Notes; // Dùng Notes làm Nội dung

                        // Nếu muốn đổi trạng thái thì thêm vào đây, ví dụ:
                        // lich.TrangThai = model.Status; 

                        db.SubmitChanges();
                        TempData["SuccessMessage"] = "Cập nhật lịch tập thành công!";
                    }
                }
                else
                {
                    TempData["ErrorMessage"] = "Không tìm thấy lịch tập hoặc bạn không có quyền sửa.";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi: " + ex.Message;
            }

            return RedirectToAction("Schedule");
        }
        // GET: HLV/Notifications
        // GET: HLV/Notifications
        public ActionResult Notifications()
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            // Lấy ID User của HLV (Vì bảng LoiNhac liên kết theo NguoiDung_ID)
            string currentUserId = hlvInfo.NguoiDung_ID;

            var model = new DashboardHLVViewModel();

            // Truy vấn bảng LoiNhac từ SQL
            var logs = db.LoiNhacs
                .Where(ln => ln.NguoiDung_ID == currentUserId)
                .OrderByDescending(ln => ln.NgayNhac) // Mới nhất lên đầu
                .Take(50) // Lấy tối đa 50 thông báo
                .ToList();

            foreach (var item in logs)
            {
                // 1. Xử lý thời gian hiển thị
                string timeStr = "";
                DateTime targetTime = item.NgayNhac ?? DateTime.Now;
                TimeSpan diff = targetTime - DateTime.Now;

                if (diff.TotalSeconds > 0)
                {
                    // Tương lai
                    if (diff.TotalDays < 1) timeStr = "Hôm nay";
                    else if (diff.TotalDays < 2) timeStr = "Ngày mai";
                    else timeStr = $"Còn {(int)diff.TotalDays} ngày nữa";
                }
                else
                {
                    // Quá khứ
                    TimeSpan past = DateTime.Now - targetTime;
                    if (past.TotalMinutes < 60) timeStr = "Vừa xong";
                    else if (past.TotalHours < 24) timeStr = $"{(int)past.TotalHours} giờ trước";
                    else timeStr = $"{(int)past.TotalDays} ngày trước";
                }

                // 2. Phân loại Icon & Tiêu đề dựa trên nội dung
                string content = item.NoiDung ?? "";
                string type = "info";
                string title = "Thông báo mới";

                string contentLower = content.ToLower();

                if (contentLower.Contains("hết hạn") || contentLower.Contains("chưa tập") || contentLower.Contains("vắng"))
                {
                    type = "warning";
                    title = "Cảnh báo";
                }
                else if (contentLower.Contains("lịch") || contentLower.Contains("hẹn") || contentLower.Contains("ngày mai"))
                {
                    type = "calendar";
                    title = "Lịch trình";
                }
                else if (contentLower.Contains("chúc mừng") || contentLower.Contains("hoàn thành"))
                {
                    type = "success";
                    title = "Thành tích";
                }

                model.Notifications.Add(new NotificationItem
                {
                    Id = item.ID, // ID int tự tăng
                    Title = title,
                    Message = content,
                    TimeAgo = timeStr,
                    Type = type
                });
            }

            model.UnreadCount = model.Notifications.Count; // Tạm tính là chưa đọc hết

            return View(model);
        }
        // POST: HLV/AddNotification
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddNotification(string message, DateTime? date)
        {
            var hlvInfo = GetCurrentHLVInfo();
            if (hlvInfo == null) return RedirectToAction("HLVDangNhap");

            try
            {
                if (string.IsNullOrEmpty(message))
                {
                    TempData["ErrorMessage"] = "Nội dung nhắc nhở không được để trống.";
                }
                else
                {
                    // Ngày nhắc mặc định là ngày mai nếu không chọn
                    DateTime remindDate = date ?? DateTime.Now.AddDays(1);

                    // Gọi Stored Procedure từ DB Context
                    // Lưu ý: Hàm này được tạo ra sau khi bạn update file .dbml
                    db.usp_ThemLoiNhacChoHLV(hlvInfo.HLV_ID, message, remindDate);

                    TempData["SuccessMessage"] = "Đã thêm lời nhắc thành công!";
                }
            }
            catch (Exception ex)
            {
                // Bắt lỗi từ SQL (ví dụ: Ngày quá khứ)
                TempData["ErrorMessage"] = "Lỗi: " + ex.Message;
            }

            // Quay lại trang Thông báo
            return RedirectToAction("Notifications");
        }
        // ==========================================
        // CÀI ĐẶT (Settings)
        // ==========================================
        [HttpGet]
        public ActionResult HLVSettings()
        {
            var nd = GetCurrentUser();
            if (nd == null) return RedirectToAction("HLVDangNhap");

            nd = db.NguoiDungs.SingleOrDefault(n => n.NguoiDungID == nd.NguoiDungID);
            var hs = db.HoSos.SingleOrDefault(h => h.NguoiDung_ID == nd.NguoiDungID);
            var hlv = db.HuanLuyenViens.SingleOrDefault(h => h.NguoiDung_ID == nd.NguoiDungID);

            if (nd == null || hs == null || hlv == null) return HttpNotFound("Dữ liệu không đồng bộ.");

            var viewModel = new HLVSettingsViewModel
            {
                Email = nd.Email,
                FullName = hs.HoTen,
                GioiTinh = hs.GioiTinh,
                NgaySinh = hs.NgaySinh,
                ChieuCao_cm = hs.ChieuCao_cm,
                CanNang_kg = hs.CanNang_kg,
                PhoneNumber = hlv.SoDienThoai,
                SoNamKinhNghiem = hlv.SoNamKinhNghiem,
                InactiveStudentAlerts = true,
                ScheduleReminders = true
            };

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult HLVSettings(HLVSettingsViewModel model)
        {
            var sessionUser = GetCurrentUser();
            if (sessionUser == null) return RedirectToAction("HLVDangNhap");
            if (!ModelState.IsValid) return View(model);

            try
            {
                var nd = db.NguoiDungs.SingleOrDefault(n => n.NguoiDungID == sessionUser.NguoiDungID);
                var hs = db.HoSos.SingleOrDefault(h => h.NguoiDung_ID == sessionUser.NguoiDungID);
                var hlv = db.HuanLuyenViens.SingleOrDefault(h => h.NguoiDung_ID == sessionUser.NguoiDungID);

                if (nd != null && hs != null && hlv != null)
                {
                    nd.Email = model.Email;
                    hs.HoTen = model.FullName;
                    hs.GioiTinh = model.GioiTinh;
                    hs.NgaySinh = model.NgaySinh;
                    hs.ChieuCao_cm = model.ChieuCao_cm;
                    hs.CanNang_kg = model.CanNang_kg;
                    hlv.HoTen = model.FullName;
                    hlv.GioiTinh = model.GioiTinh;
                    hlv.SoDienThoai = model.PhoneNumber;
                    hlv.SoNamKinhNghiem = model.SoNamKinhNghiem;

                    if (!string.IsNullOrEmpty(model.CurrentPassword) && !string.IsNullOrEmpty(model.NewPassword))
                    {
                        if (nd.MatKhau == model.CurrentPassword)
                        {
                            nd.MatKhau = model.NewPassword;
                            TempData["SuccessMessage"] = "Đã đổi mật khẩu thành công.";
                        }
                        else
                        {
                            ModelState.AddModelError("CurrentPassword", "Mật khẩu hiện tại sai.");
                            return View(model);
                        }
                    }
                    else
                    {
                        TempData["SuccessMessage"] = "Cập nhật thông tin thành công.";
                    }

                    db.SubmitChanges();
                    Session["NguoiDung"] = nd;
                    Session["HoSo"] = hs;
                    Session["HLVInfo"] = hlv;
                    Session["TenHLV"] = hs.HoTen;

                    return RedirectToAction("HLVSettings");
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "Lỗi: " + ex.Message);
            }

            return View(model);
        }
    }
}
