using System;

namespace Nhom05_Health_Fitness.Models
{
    public class LichSuGoiViewModel
    {
        public string TenGoi { get; set; }
        public DateTime? NgayDangKy { get; set; }
        public DateTime? NgayHetHan { get; set; }
        public decimal? GiaTien { get; set; }
        public bool DaThanhToan { get; set; }
        public DateTime? NgayThanhToan { get; set; }
    }
}