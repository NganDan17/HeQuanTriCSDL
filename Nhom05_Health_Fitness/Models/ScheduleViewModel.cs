using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
namespace Nhom05_Health_Fitness.Models
{
    public class ScheduleViewModel
    {// --- Thống kê ---
        public int TotalTeachingHours { get; set; }
        public int CompletedSessions { get; set; }
        public int UpcomingSessions { get; set; }

        // --- Danh sách lịch ---
        public List<ScheduleItem> UpcomingList { get; set; }
        public List<ScheduleItem> CompletedList { get; set; }

        // --- Dữ liệu cho Modal "Add New Session" ---
        public string SelectedStudentId { get; set; }
        public DateTime? Date { get; set; }
        public TimeSpan? Time { get; set; }
        public int Duration { get; set; } = 60; // Mặc định 60 phút
        public string Notes { get; set; } // Ghi chú nội dung tập

        // Dropdown danh sách học viên
        public List<SelectListItem> StudentsList { get; set; }
        public int LichID { get; set; }
        public ScheduleViewModel()
        {
            UpcomingList = new List<ScheduleItem>();
            CompletedList = new List<ScheduleItem>();
            StudentsList = new List<SelectListItem>();
        }
    }

    public class ScheduleItem
    {
        public int LichID { get; set; }
        public string StudentName { get; set; }
        public DateTime Date { get; set; }
        public string Time { get; set; } // VD: 09:00
        public int Duration { get; set; }
        public string Status { get; set; } // Chưa diễn ra / Hoàn thành
    }
}