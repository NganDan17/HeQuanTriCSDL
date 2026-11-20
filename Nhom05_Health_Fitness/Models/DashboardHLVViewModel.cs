using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Nhom05_Health_Fitness.Models
{
    // --- ViewModel chính cho Dashboard ---
    public class DashboardHLVViewModel
    {
        public int TongHocVien { get; set; }
        public int SoBuoiTuanNay { get; set; }
        public int GioTapThangNay { get; set; }
        public int SoBuoiSapToi { get; set; }
        public int AvgProgress { get; set; }

        // Danh sách học viên cảnh báo (nghỉ lâu)
        public List<HocVienKhongTapInfo> HocVienKhongTap { get; set; }

        // Danh sách thông báo (Mới thêm)
        public List<NotificationItem> Notifications { get; set; }
        public int UnreadCount { get; set; }

        // Dữ liệu biểu đồ
        public List<int> SessionsPerMonthData { get; set; }
        public List<string> SessionsPerMonthLabels { get; set; }
        public List<int> StudentProgressData { get; set; }
        public List<string> StudentProgressLabels { get; set; }

        public DashboardHLVViewModel()
        {
            HocVienKhongTap = new List<HocVienKhongTapInfo>();
            Notifications = new List<NotificationItem>();
            SessionsPerMonthData = new List<int>();
            SessionsPerMonthLabels = new List<string>();
            StudentProgressData = new List<int>();
            StudentProgressLabels = new List<string>();
        }
    }

    // --- Các class con hỗ trợ ---

    public class HocVienKhongTapInfo
    {
        public string HoTen { get; set; }
        public int SoNgayKhongTap { get; set; }
    }

    public class NotificationItem
    {
        public int Id { get; set; }          // ID thông báo
        public string Title { get; set; }    // Tiêu đề
        public string Message { get; set; }  // Nội dung
        public string TimeAgo { get; set; }  // Thời gian (VD: 2 giờ trước)
        public string Type { get; set; }     // Loại (warning, info, error, calendar)
        public bool IsRead { get; set; }     // Trạng thái đã đọc
    }

    // --- Các ViewModel khác ---

    public class StudentInfoPageViewModel
    {
        public List<StudentInfoViewModel> Students { get; set; }
        public StudentInfoPageViewModel()
        {
            Students = new List<StudentInfoViewModel>();
        }
    }

    public class StudentInfoViewModel
    {
        public string NguoiDungID { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public decimal? Weight { get; set; }
        public decimal? Height { get; set; }
        public string Goal { get; set; }
        public int Progress { get; set; }
        public DateTime? LastUpdate { get; set; }

        public string TrangThaiGoiTap { get; set; }
    }

    public class StudentDetailViewModel
    {
        public string NguoiDungID { get; set; }
        public string HoTen { get; set; }
        public string Gender { get; set; }
        public decimal? Height { get; set; }
        public decimal? Weight { get; set; }
        public decimal? BMI { get; set; }

        public string Goal { get; set; }
        public string GoalTarget { get; set; }
        public string GoalTimeline { get; set; }

        public List<string> ProgressChartLabels { get; set; }
        public List<decimal> ProgressChartData { get; set; }
        public string PackageStatus { get; set; }

        public StudentDetailViewModel()
        {
            ProgressChartLabels = new List<string>();
            ProgressChartData = new List<decimal>();
        }
    }

    public class HLVSettingsViewModel
    {
        // --- Thông tin cơ bản ---
        [Display(Name = "Họ và tên")]
        [Required(ErrorMessage = "Vui lòng nhập họ tên.")]
        public string FullName { get; set; }

        [Display(Name = "Email")]
        [Required(ErrorMessage = "Vui lòng nhập email.")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ.")]
        public string Email { get; set; }

        [Display(Name = "Số điện thoại")]
        public string PhoneNumber { get; set; }

        // --- Các trường MỚI THÊM để khớp với Controller ---
        [Display(Name = "Giới tính")]
        public string GioiTinh { get; set; }

        [Display(Name = "Ngày sinh")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? NgaySinh { get; set; }

        [Display(Name = "Chiều cao (cm)")]
        public decimal? ChieuCao_cm { get; set; }

        [Display(Name = "Cân nặng (kg)")]
        public decimal? CanNang_kg { get; set; }

        [Display(Name = "Kinh nghiệm (năm)")]
        public int? SoNamKinhNghiem { get; set; } // Thay thế hoặc dùng chung với Specialization

        // --- Bảo mật ---
        [Display(Name = "Mật khẩu hiện tại")]
        [DataType(DataType.Password)]
        public string CurrentPassword { get; set; }

        [Display(Name = "Mật khẩu mới")]
        [DataType(DataType.Password)]
        public string NewPassword { get; set; }

        // --- Cấu hình thông báo ---
        public bool InactiveStudentAlerts { get; set; }
        public bool ScheduleReminders { get; set; }
        public bool ScheduleConflicts { get; set; }
        public bool WeeklySummary { get; set; }
        public bool StudentProgressUpdates { get; set; }
    }
}