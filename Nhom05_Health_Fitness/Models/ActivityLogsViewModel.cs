using System.Collections.Generic;
using System.Web.Mvc; // Để dùng SelectListItem

namespace Nhom05_Health_Fitness.Models
{
    public class ActivityLogsViewModel
    {
        public string StudentName { get; set; }
        public string SelectedStudentId { get; set; }
        public List<SelectListItem> StudentsList { get; set; }

        // --- CÁC THUỘC TÍNH CHO BIỂU ĐỒ ---
        // Controller đang gọi model.ChartLabels => Phải có biến này
        public List<string> ChartLabels { get; set; }
        public List<int> WeeklyActivityData { get; set; }
        public List<int> CalorieBurnData { get; set; }

        // Dữ liệu cân nặng (Cho biểu đồ 2)
        public List<string> WeightLabels { get; set; }
        public List<decimal> WeightData { get; set; }

        // Dữ liệu bảng Nhật ký
        public List<WorkoutLogItem> WorkoutLogs { get; set; }

        // Constructor để khởi tạo List (Tránh lỗi NullReference)
        public ActivityLogsViewModel()
        {
            StudentsList = new List<SelectListItem>();
            WorkoutLogs = new List<WorkoutLogItem>();

            ChartLabels = new List<string>();
            WeeklyActivityData = new List<int>();
            CalorieBurnData = new List<int>();

            WeightLabels = new List<string>();
            WeightData = new List<decimal>();
        }
    }

    public class WorkoutLogItem
    {
        public string Date { get; set; }
        public string SessionType { get; set; }
        public int Duration { get; set; }
        public string Exercises { get; set; }
        public int Calories { get; set; }
    }
}