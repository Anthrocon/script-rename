Write-Host "This script renames .jpg files in the current directory for submission to Anthrocon."
Write-Host "Backup the directory before proceeding."
Write-Host ""
Write-Host "Working directory: $pwd"
Write-Host ""

while($true) {
    $year = Read-Host "Photo year"

    if($year -match '^[1-2]\d{3}$') {
        break
    } else {
        Write-Host "Year must be four digits."
        Write-Host ""
    }
}

while($true) {
    $artist = Read-Host "Photo artist"

    if($artist -match '^[^\\/:*?"<>|]+$') {
        break
    } else {
        Write-Host "Artist must be valid file name characters."
        Write-Host ""
    }
}

$recursive = Read-Host "Do you want to act recursively in sub-directories? (y/n)"
Write-Host ""

if($recursive -eq "y") {
    $files = Get-ChildItem -Path . -Recurse -Include *.jpg
} else {
    $files = Get-ChildItem -Path * -Include *.jpg
}

$totalFiles = $files.Count

if($totalFiles -le 5) {
    Write-Host "Preview of $($totalFiles) files to be renamed:"
} else {
    Write-Host "Preview of the first files to be renamed:"
}

for($i = 0; $i -lt 5 -and $i -lt $totalFiles; $i++) {
    $file = $files[$i]
    $newName = "$year $artist $($file.Name)"

    Write-Host "$($file.Name) -> $newName"
}

if($totalFiles -gt 5) {
    Write-Host "..."
}

Write-Host ""
Write-Host "Total number of .jpg files to be renamed: $totalFiles"
Write-Host ""

$confirm = Read-Host "Are these correct? (y/n)"
Write-Host ""

if($confirm -ne "y") {
    Write-Host "Nothing was changed. Exiting."

    return
}

$scriptName = $MyInvocation.MyCommand.Name
$logFile = "$pwd\$scriptName-$(Get-Date -Format yyyy-MM-dd-HH-mm-ss).log"

Add-Content -Path $logFile -Value "Directory: $pwd"
Add-Content -Path $logFile -Value "Year: $year"
Add-Content -Path $logFile -Value "Artist: $artist"
Add-Content -Path $logFile -Value "Recursive: $recursive"
Add-Content -Path $logFile -Value "Files: $totalFiles"
Add-Content -Path $logFile -Value ""

foreach($file in $files) {
    $newName = "$year $artist $($file.Name)"

    Rename-Item -LiteralPath $file.FullName -NewName $newName

    Add-Content -Path $logFile -Value "$($file.FullName) -> $newName"
}
