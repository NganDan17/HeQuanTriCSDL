using System;
using System.Configuration;

namespace Nhom05_Health_Fitness.Models
{
    internal static class DatabaseConfiguration
    {
        public static string DefaultConnectionString
        {
            get
            {
                var environment = Environment.GetEnvironmentVariable("HEALTH_CONNECTION_STRING");
                return string.IsNullOrWhiteSpace(environment) ? Read("HEALTHConnectionString") : environment;
            }
        }

        public static string ForRole(string role)
        {
            if (role != "Admin" && role != "HLV" && role != "User")
                throw new InvalidOperationException("Vai trò đăng nhập không hợp lệ.");
            return Read("HEALTH." + role);
        }

        private static string Read(string name)
        {
            var setting = ConfigurationManager.ConnectionStrings[name];
            if (setting == null || string.IsNullOrWhiteSpace(setting.ConnectionString))
                throw new InvalidOperationException("Chưa có cấu hình cơ sở dữ liệu. Chạy KhoiTao.ps1 trước khi mở website.");
            return setting.ConnectionString;
        }
    }

    public partial class HealthDataContext
    {
        public HealthDataContext() : base(DatabaseConfiguration.DefaultConnectionString, mappingSource)
        {
            OnCreated();
        }
    }
}
