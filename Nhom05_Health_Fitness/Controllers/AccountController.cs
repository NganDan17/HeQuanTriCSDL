using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using System.Configuration;
using Nhom05_Health_Fitness.Models;

namespace Nhom05_Health_Fitness.Controllers
{
    public class AccountController : Controller
    {
       
        HealthDataContext db = new HealthDataContext();

        // ==========================================================
        // 1. ĐĂNG NHẬP
        // ==========================================================
        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(string TenDangNhap, string MatKhau)
        {
            if (string.IsNullOrEmpty(TenDangNhap) || string.IsNullOrEmpty(MatKhau))
            {
                ViewBag.Error = "Vui lòng nhập tên đăng nhập và mật khẩu!";
                return View();
            }

            try
            {
                // 1. Gọi Stored Procedure usp_DangNhap qua LINQ
                var user = db.usp_DangNhap(TenDangNhap).FirstOrDefault();

                if (user != null)
                {
                    // 2. Kiểm tra mật khẩu 
                    if (user.MatKhau != MatKhau)
                    {
                        ViewBag.Error = "Mật khẩu không chính xác!";
                        return View();
                    }

                    // 3. Lưu thông tin vào Session
                    string role = user.TenVaiTro.Trim();
                    Session["NguoiDungID"] = user.NguoiDungID.Trim();
                    Session["TenDangNhap"] = user.TenDangNhap;
                    Session["Email"] = user.Email;
                    Session["VaiTro"] = role;

                    Session["TenHienThi"] = !string.IsNullOrEmpty(user.TenDangNhap) ? user.TenDangNhap : user.Email;

                    // =====================================================================
                    // 4. LOGIC PHÂN QUYỀN SQL (SỬA MẬT KHẨU)
                    // =====================================================================
                    string userSpecificConnString = DatabaseConfiguration.ForRole(role);

                    Session["UserConnectionString"] = userSpecificConnString;

                    if (role == "HLV")
                    {
                        var hlvInfo = db.HuanLuyenViens.SingleOrDefault(h => h.NguoiDung_ID.Trim() == user.NguoiDungID.Trim());
                        if (hlvInfo != null)
                        {
                            Session["HLVInfo"] = hlvInfo;
                            Session["TenHLV"] = hlvInfo.HoTen;
                        }
                    }

                    // 5. Điều hướng
                    switch (role)
                    {
                        case "Admin":
                            return RedirectToAction("Admin_TrangChu", "Admin");
                        case "HLV":
                            return RedirectToAction("HLVTrangChu", "HLV");
                        default:
                            return RedirectToAction("Index", "User");
                    }
                }
                else
                {
                    ViewBag.Error = "Tài khoản không tồn tại!";
                }
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Lỗi đăng nhập: " + ex.Message;
            }

            return View();
        }

        // ==========================================================
        // 2. ĐĂNG KÝ
        // ==========================================================
        [HttpGet]
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Register(string TenDangNhap, string Email, string MatKhau, string XacNhanMatKhau, string HoTen)
        {
            if (string.IsNullOrEmpty(TenDangNhap) || string.IsNullOrEmpty(Email) || string.IsNullOrEmpty(MatKhau))
            {
                ViewBag.Error = "Vui lòng nhập đầy đủ thông tin bắt buộc!";
                return View();
            }

            if (MatKhau != XacNhanMatKhau)
            {
                ViewBag.Error = "Mật khẩu xác nhận không khớp!";
                return View();
            }

            try
            {
                var result = db.usp_DangKyNguoiDung(
                    TenDangNhap,
                    Email,
                    MatKhau,
                    HoTen,
                    null,
                    null,
                    null,
                    null
                ).FirstOrDefault();

                if (result != null)
                {
                    if (result.Result == 1)
                    {
                        TempData["Success"] = "Đăng ký thành công! Vui lòng đăng nhập.";
                        return RedirectToAction("Login");
                    }
                    else
                    {
                        ViewBag.Error = result.Message;
                    }
                }
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Lỗi hệ thống: " + ex.Message;
            }

            return View();
        }

        // ==========================================================
        // 3. ĐĂNG XUẤT
        // ==========================================================
        public ActionResult Logout()
        {
            Session.Clear();
            Session.Abandon();
            return RedirectToAction("Login");
        }

        public ActionResult AccessDenied()
        {
            return View();
        }

        // ==========================================================
        // 4. HÀM HỖ TRỢ (Mapping SQL Login)
        // ==========================================================
    }
}
