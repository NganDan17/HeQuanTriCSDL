param(
    [ValidateSet('Debug','Release')][string]$Configuration = 'Debug',
    [string]$ReferenceAssembliesPath
)
$ErrorActionPreference = 'Stop'
$project = Join-Path $PSScriptRoot 'Nhom05_Health_Fitness\Nhom05_Health_Fitness.csproj'
$compiler = Join-Path $PSScriptRoot 'packages\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.2.0.1\tools\RoslynLatest'
if (-not (Test-Path -LiteralPath (Join-Path $compiler 'csc.exe'))) {
    throw 'Thieu packages. Mo solution bang Visual Studio, chon Restore NuGet Packages roi thu lai.'
}
$msbuild = $null
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (Test-Path -LiteralPath $vswhere) {
    $found = @(& $vswhere -latest -products '*' -requires Microsoft.Component.MSBuild -find 'MSBuild\**\Bin\MSBuild.exe')
    if ($found.Count -gt 0) { $msbuild = $found[0] }
}
if (-not $msbuild) {
    $msbuild = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe'
    if (-not (Test-Path -LiteralPath $msbuild)) {
        $msbuild = Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319\MSBuild.exe'
    }
}
if (-not (Test-Path -LiteralPath $msbuild)) {
    throw 'Thieu MSBuild. Cai .NET Framework 4.7.2 Developer Pack hoac Visual Studio voi ASP.NET and web development.'
}
if (-not $ReferenceAssembliesPath) {
    $ReferenceAssembliesPath = Join-Path ${env:ProgramFiles(x86)} 'Reference Assemblies\Microsoft\Framework'
}
$referenceDll = Join-Path $ReferenceAssembliesPath '.NETFramework\v4.7.2\mscorlib.dll'
if (-not (Test-Path -LiteralPath $referenceDll)) {
    throw 'Thieu .NET Framework 4.7.2 Developer Pack (Targeting Pack). Cai tu https://dotnet.microsoft.com/download/dotnet-framework/net472 roi chay lai. Chi cai .NET SDK 8/10 la chua du.'
}
$arguments = @($project, '/nologo', '/t:Build', '/verbosity:minimal',
    ('/p:Configuration=' + $Configuration), '/p:BuildForVSCode=true',
    ('/p:TargetFrameworkRootPath=' + $ReferenceAssembliesPath.TrimEnd('\') + '\'),
    ('/p:FrameworkPathOverride=' + (Split-Path -Parent $referenceDll)),
    ('/p:CscToolPath=' + $compiler), '/p:UseSharedCompilation=false')
if ($msbuild -like '*\Microsoft.NET\Framework*') { $arguments += '/ToolsVersion:4.0' }
& $msbuild @arguments
if ($LASTEXITCODE -ne 0) { throw ('Bien dich that bai, ma loi ' + $LASTEXITCODE) }
if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'Nhom05_Health_Fitness\bin\Nhom05_Health_Fitness.dll'))) {
    throw 'Khong tim thay DLL sau bien dich. Khong khoi dong website.'
}
Write-Host 'Bien dich thanh cong.'
