param(
    [ValidateRange(1025,65535)][int]$Port = 5085,
    [string]$IISExpressPath,
    [switch]$KhongMoTrinhDuyet
)
$ErrorActionPreference = 'Stop'
$projectDirectory = Join-Path $PSScriptRoot 'Nhom05_Health_Fitness'
if (-not (Test-Path -LiteralPath (Join-Path $projectDirectory 'Database.Local.config'))) {
    throw 'Chua khoi tao du lieu. Chay KhoiTao.ps1 theo README truoc. Lenh chay khong tu nap de database.'
}
if (-not $IISExpressPath) {
    foreach ($programDirectory in @($env:ProgramFiles, ${env:ProgramFiles(x86)})) {
        if ($programDirectory) {
            $candidate = Join-Path $programDirectory 'IIS Express\iisexpress.exe'
            if (Test-Path -LiteralPath $candidate) { $IISExpressPath = $candidate; break }
        }
    }
}
if (-not $IISExpressPath -or -not (Test-Path -LiteralPath $IISExpressPath -PathType Leaf)) {
    throw 'Thieu IIS Express 10. Cai tu https://www.microsoft.com/download/details.aspx?id=48264 (ban amd64 cho Windows 64-bit), hoac cai Visual Studio voi ASP.NET and web development.'
}
$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $Port)
try { $listener.Start() }
catch { throw "Cong $Port dang duoc dung. Dung lan chay cu hoac chay .\Chay.ps1 -Port 5086." }
finally { $listener.Stop() }
& (Join-Path $PSScriptRoot 'BienDich.ps1')
$url = 'http://localhost:' + $Port + '/Account/Login'
Write-Host ('Mo: ' + $url)
Write-Host 'De dung website: bam Q trong cua so nay. Neu VS Code bao task dang chay, dung task cu truoc.'
$browserJob = $null
try {
    if (-not $KhongMoTrinhDuyet) {
        $browserJob = Start-Job -ArgumentList $url,$Port -ScriptBlock {
            param($Address,$ServerPort)
            for ($attempt=0; $attempt -lt 60; $attempt++) {
                $client = New-Object Net.Sockets.TcpClient
                try {
                    $client.Connect('localhost',$ServerPort)
                    Start-Process $Address
                    return
                } catch { Start-Sleep -Milliseconds 250 }
                finally { $client.Dispose() }
            }
        }
    }
    # Run IIS in this terminal so stopping the task also stops the web server.
    & $IISExpressPath ('/path:' + $projectDirectory) ('/port:' + $Port) '/clr:v4.0' '/systray:false'
    if ($LASTEXITCODE -ne 0) { throw ('IIS Express dung voi ma loi ' + $LASTEXITCODE) }
} finally {
    if ($browserJob) {
        Stop-Job $browserJob -ErrorAction SilentlyContinue
        Remove-Job $browserJob -Force -ErrorAction SilentlyContinue
    }
}
