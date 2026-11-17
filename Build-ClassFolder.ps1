# Builds the upload-ready folder "baa-class" on your Desktop.
# Usage: put this script and the baa-class folder (from the zip) on your Desktop, then run:
#   powershell -ExecutionPolicy Bypass -File .\Build-ClassFolder.ps1
param(
  [string]$StudentFile = "$env:USERPROFILE\Desktop\democlass1-student.html",
  [string]$Folder      = "$env:USERPROFILE\Desktop\baa-class"
)
if (-not (Test-Path $StudentFile)) { Write-Error "Not found: $StudentFile"; exit 1 }
$html = Get-Content $StudentFile -Raw -Encoding UTF8
if ($html -match 'sk-ant|PEXELS|pexels_key|Authorization') { Write-Warning "This file may contain an API key. Check before uploading." }
if ($html -match 'Ms\. Elena|Boston, USA') { Write-Warning "Placeholder teacher name/city still present. Re-run Make-StudentDemo.ps1 with -TeacherName and -TeacherCity first." }

$tags = @'
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="BAA Class">
<meta name="theme-color" content="#1f4e79">
<link rel="apple-touch-icon" href="apple-touch-icon.png">
<link rel="manifest" href="manifest.webmanifest">
'@
if ($html -notmatch 'apple-touch-icon') {
  $html = [regex]::Replace($html, '</head>', "$tags</head>", 'IgnoreCase')
}
New-Item -ItemType Directory -Force -Path $Folder | Out-Null
[System.IO.File]::WriteAllText("$Folder\index.html", $html, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Done. Drag '$Folder' onto https://app.netlify.com/drop"
