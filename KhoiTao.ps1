param(
    [string]$SqlServer = '.\SQLEXPRESS',
    [ValidatePattern('^[A-Za-z][A-Za-z0-9_]{0,63}$')][string]$Database = 'HEALTH',
    [switch]$SuDungDuLieuHienCo
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Data
$projectDirectory = Join-Path $PSScriptRoot 'Nhom05_Health_Fitness'
$configPath = Join-Path $projectDirectory 'Database.Local.config'
$isHealth = Test-Path -LiteralPath (Join-Path $PSScriptRoot 'database\02_PhanQuyen.sql')
$builder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
$builder['Data Source'] = $SqlServer
$builder['Initial Catalog'] = 'master'
$builder['Integrated Security'] = $true
$builder['TrustServerCertificate'] = $true
$builder['Connect Timeout'] = 10
$connection = New-Object System.Data.SqlClient.SqlConnection($builder.ConnectionString)
$defaultName = if ($isHealth) { 'HEALTHConnectionString' } else { 'QL_NGOAINGU' }
$previousDefault = $null
if (Test-Path -LiteralPath $configPath) {
    [xml]$existingConfig = [IO.File]::ReadAllText($configPath)
    $defaults = @($existingConfig.connectionStrings.add | Where-Object name -eq $defaultName)
    if ($defaults.Count -ne 1) { throw 'Cau hinh cu thieu ket noi mac dinh; giu nguyen tep cu.' }
    $existingBuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder([string]$defaults[0].connectionString)
    if ($existingBuilder['Data Source'] -ne $SqlServer -or $existingBuilder['Initial Catalog'] -ne $Database) {
        throw 'Cau hinh cu tro toi may/database khac. Sao luu va doi ten tep cu truoc khi khoi tao noi nhan moi.'
    }
    $previousDefault = $existingBuilder.ConnectionString
}

function Invoke-Sql([string]$Text, [hashtable]$Values = @{}, [switch]$Scalar) {
    $command = $connection.CreateCommand()
    $command.CommandText = $Text
    $command.CommandTimeout = 120
    foreach ($key in $Values.Keys) { [void]$command.Parameters.AddWithValue('@' + $key, $Values[$key]) }
    try {
        if ($Scalar) { return $command.ExecuteScalar() }
        [void]$command.ExecuteNonQuery()
    } finally { $command.Dispose() }
}

function Invoke-SqlFile([string]$Path) {
    $raw = [IO.File]::ReadAllText($Path)
    foreach ($batch in [regex]::Split($raw, '(?im)^\s*GO\s*(?:--[^\r\n]*)?\r?$')) {
        if (-not [string]::IsNullOrWhiteSpace($batch)) { Invoke-Sql $batch }
    }
}

function New-Password {
    $bytes = New-Object byte[] 24
    $rng = [Security.Cryptography.RandomNumberGenerator]::Create()
    try { $rng.GetBytes($bytes); return 'Aa1!' + [Convert]::ToBase64String($bytes) }
    finally { $rng.Dispose(); [Array]::Clear($bytes, 0, $bytes.Length) }
}

try {
    $connection.Open()
    $exists = Invoke-Sql 'SELECT COUNT(*) FROM sys.databases WHERE name=@name' @{name=$Database} -Scalar
    if ($exists -and -not $SuDungDuLieuHienCo) {
        throw "Database $Database da ton tai. Khong ghi de. Neu dung dung du lieu nay, chay lai voi -SuDungDuLieuHienCo."
    }
    if (-not $exists) {
        Invoke-Sql ("CREATE DATABASE [$Database]")
        $connection.ChangeDatabase($Database)
        Invoke-Sql 'SET QUOTED_IDENTIFIER ON; SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT ON; SET CONCAT_NULL_YIELDS_NULL ON; SET NUMERIC_ROUNDABORT OFF;'
        Invoke-SqlFile (Join-Path $PSScriptRoot 'database\01_KhoiTao.sql')
        Write-Host "Da tao database mau: $Database."
    } else {
        $connection.ChangeDatabase($Database)
        $required = if ($isHealth) { @('NguoiDung', 'VaiTro', 'HoSo') } else { @('TaiKhoan', 'ThiSinh', 'KyThi') }
        foreach ($table in $required) {
            if (-not (Invoke-Sql 'SELECT COUNT(*) FROM sys.tables WHERE name=@name AND schema_id=SCHEMA_ID(N''dbo'')' @{name=$table} -Scalar)) {
                throw "Database hien co khong dung cau truc du an: thieu $table. Khong sua du lieu."
            }
        }
        Write-Host "Giu nguyen du lieu trong database: $Database."
    }

    $builder['Initial Catalog'] = $Database
    $settings = [ordered]@{}
    $settings[$defaultName] = if ($previousDefault) { $previousDefault } else { $builder.ConnectionString }
    if ($isHealth) {
        $roleCount = Invoke-Sql "SELECT COUNT(*) FROM sys.database_principals WHERE type='R' AND name IN ('ROLE_ADMIN','ROLE_HUANLUYENVIEN','ROLE_HOIVIEN')" -Scalar
        if ($roleCount -eq 0) { Invoke-SqlFile (Join-Path $PSScriptRoot 'database\02_PhanQuyen.sql') }
        elseif ($roleCount -ne 3) { throw 'Database chi co mot phan nhom quyen. Khong tu ghi de quyen hien co.' }
        $essential = Invoke-Sql "SELECT COUNT(*) FROM sys.database_permissions p JOIN sys.database_principals r ON p.grantee_principal_id=r.principal_id WHERE p.state IN ('G','W') AND ((r.name='ROLE_ADMIN' AND p.class=0 AND p.permission_name='CONTROL') OR (r.name='ROLE_HUANLUYENVIEN' AND p.major_id=OBJECT_ID('dbo.BaiTap') AND p.permission_name='SELECT') OR (r.name='ROLE_HOIVIEN' AND p.major_id=OBJECT_ID('dbo.usp_DangNhap') AND p.permission_name='EXECUTE'))" -Scalar
        if ($essential -ne 3) { throw 'Quyen hien co chua day du de chay du an. Khong tu cap lai hay ghi de quyen da sua.' }
        $roles = [ordered]@{Admin='ROLE_ADMIN';HLV='ROLE_HUANLUYENVIEN';User='ROLE_HOIVIEN'}
        if (Test-Path -LiteralPath $configPath) {
            [xml]$previous = [IO.File]::ReadAllText($configPath)
            foreach ($role in $roles.Keys) {
                $entry = @($previous.connectionStrings.add | Where-Object name -eq ('HEALTH.' + $role))
                if ($entry.Count -ne 1) { throw 'Cau hinh cu thieu ket noi theo vai tro; giu nguyen tep cu.' }
                $saved = New-Object System.Data.SqlClient.SqlConnectionStringBuilder([string]$entry[0].connectionString)
                if ($saved['Data Source'] -ne $SqlServer -or $saved['Initial Catalog'] -ne $Database) {
                    throw 'Tep cau hinh cu tro toi may/database khac. Sao luu va doi ten tep cu truoc khi khoi tao noi nhan moi.'
                }
                $valid = Invoke-Sql 'SELECT COUNT(*) FROM master.sys.sql_logins WHERE name=@name AND PWDCOMPARE(@password,password_hash)=1' @{name=$saved['User ID'];password=$saved['Password']} -Scalar
                $mapped = Invoke-Sql 'SELECT COUNT(*) FROM sys.database_principals p JOIN sys.server_principals s ON p.sid=s.sid JOIN sys.database_role_members m ON m.member_principal_id=p.principal_id JOIN sys.database_principals r ON r.principal_id=m.role_principal_id WHERE s.name=@login AND r.name=@role' @{login=$saved['User ID'];role=$roles[$role]} -Scalar
                if (-not $valid -or -not $mapped) { throw 'SQL login hoac quyen trong cau hinh cu khong khop. Khong tu doi mat khau hay quyen hien co.' }
                $settings['HEALTH.' + $role] = $saved.ConnectionString
            }
        } else {
            foreach ($role in $roles.Keys) {
                $login = 'HF_' + $Database + '_' + $role + '_' + [Guid]::NewGuid().ToString('N').Substring(0,8)
                $password = New-Password
                $literal = $password.Replace("'", "''")
                Invoke-Sql ("CREATE LOGIN [$login] WITH PASSWORD=N'$literal', CHECK_POLICY=ON, CHECK_EXPIRATION=OFF;")
                Invoke-Sql ("CREATE USER [$login] FOR LOGIN [$login]; ALTER ROLE [$($roles[$role])] ADD MEMBER [$login];")
                $roleBuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder($builder.ConnectionString)
                $roleBuilder['Integrated Security'] = $false
                $roleBuilder['User ID'] = $login
                $roleBuilder['Password'] = $password
                $settings['HEALTH.' + $role] = $roleBuilder.ConnectionString
                $password = $null
                $literal = $null
            }
        }
    }

    $xml = New-Object xml
    [void]$xml.AppendChild($xml.CreateXmlDeclaration('1.0','utf-8',$null))
    $root = $xml.CreateElement('connectionStrings')
    [void]$xml.AppendChild($root)
    foreach ($name in $settings.Keys) {
        $entry = $xml.CreateElement('add')
        $entry.SetAttribute('name',$name)
        $entry.SetAttribute('connectionString',$settings[$name])
        $entry.SetAttribute('providerName','System.Data.SqlClient')
        [void]$root.AppendChild($entry)
    }
    $temporary = $configPath + '.tmp'
    $xml.Save($temporary)
    Move-Item -LiteralPath $temporary -Destination $configPath -Force
    Write-Host "Da luu cau hinh rieng tai: $configPath"
    if ($isHealth) {
        $connection.ChangeDatabase('master')
        if (Invoke-Sql "SELECT CONVERT(int,SERVERPROPERTY('IsIntegratedSecurityOnly'))" -Scalar) {
            Write-Warning 'SQL Server dang chi cho Windows Authentication. Can bat SQL Server and Windows Authentication (Mixed Mode) va khoi dong lai dich vu truoc khi dang nhap cac trang theo vai tro. Script khong tu doi che do may chu.'
        }
    }
    Write-Host 'Mo solution bang Visual Studio, Restore NuGet, Build va F5. Khong dua Database.Local.config len GitHub.'
} finally {
    $connection.Dispose()
}
