using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Nhom05_Health_Fitness.Filters
{
    /// <summary>
    /// Attribute phân quyền theo SQL Roles (Phần 7 trong Database)
    /// Mapping: Admin -> ROLE_ADMIN
    ///          User -> ROLE_HOIVIEN  
    ///          HLV -> ROLE_HUANLUYENVIEN
    /// </summary>
    public class CustomAuthorizeAttribute : AuthorizeAttribute
    {
        private readonly string[] allowedRoles;

        public CustomAuthorizeAttribute(params string[] roles)
        {
            this.allowedRoles = roles;
        }

        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            // Kiểm tra đã đăng nhập chưa
            if (httpContext.Session["NguoiDungID"] == null)
            {
                return false;
            }

            // Nếu không chỉ định role => cho phép tất cả user đã đăng nhập
            if (allowedRoles == null || allowedRoles.Length == 0)
            {
                return true;
            }

            // Lấy role từ Session
            string userRole = httpContext.Session["VaiTro"]?.ToString();

            // Kiểm tra quyền
            return allowedRoles.Contains(userRole);
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            if (filterContext.HttpContext.Session["NguoiDungID"] == null)
            {
                // Chưa đăng nhập => về trang Login
                filterContext.Result = new RedirectResult("~/Account/Login");
            }
            else
            {
                // Đã đăng nhập nhưng không đủ quyền => về trang AccessDenied
                filterContext.Result = new RedirectResult("~/Account/AccessDenied");
            }
        }
    }

    /// <summary>
    /// Helper kiểm tra quyền trong View
    /// </summary>
    public static class RoleHelper
    {
        public static bool IsInRole(string role)
        {
            var currentRole = HttpContext.Current.Session["VaiTro"]?.ToString();
            return currentRole == role;
        }

        public static bool IsAdmin()
        {
            return IsInRole("Admin");
        }

        public static bool IsHLV()
        {
            return IsInRole("HLV");
        }

        public static bool IsUser()
        {
            return IsInRole("User");
        }
    }
}