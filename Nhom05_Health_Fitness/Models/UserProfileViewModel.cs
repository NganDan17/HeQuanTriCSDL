using System;

namespace Nhom05_Health_Fitness.Models
{
    public class UserProfileViewModel
    {
        public string HoTen { get; set; }
        public string GioiTinh { get; set; }
        public DateTime? NgaySinh { get; set; }
        public decimal? ChieuCao { get; set; }
        public decimal? CanNang { get; set; }
        public string Email { get; set; }
        public string TenDangNhap { get; set; }
    }
}