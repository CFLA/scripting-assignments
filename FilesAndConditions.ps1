<#

Purpose: 3rd PowerShell lab. Practices use of:
    Here-Strings
    Piping commands
    Writing and Reading files
    Conditional Logic

Author: Lars Andersland
File: FilesAndConditions.ps1
Date: February 24, 2020

#>

#part 1
Clear-Host
Set-Location $env:userprofile
Get-ChildItem -Filter *.txt | Sort-Object -Property Name | Format-Table -Property Name, Length
#end part 1

#part 2
$menu = @"
What do you want to do?
    1. Write a contact entry to a file
    2. Display all files last written to after a given date
    3. Read a specified text file

"@
$menu
$selection = Read-Host "Type in 1, 2, or 3"
#end part 2

#part 3 and 4
if ($selection -eq 1) {
    Write-Output "Output 1 chosen"
    $cname = Read-Host "Enter the contact's full name: "
    $cphone = Read-Host "Enter the contact's phone number: "
    $caddress = Read-Host "Enter the contact's email address: "
    $fname = Read-Host "Enter the file name"
    Add-Content $env:userprofile/$fname.txt "$cname `n $cphone `n $caddress `n"
}

elseif ($selection -eq 2) {
    Write-Output "Output 2 chosen"
    $earliestdate = Read-Host "Earliest date of files to display: "
    Get-ChildItem | Where-Object {$_.LastWriteTime -ge $earliestdate} | Sort-Object -Property Name | Format-Table -Property Name, LastWriteTime
}

elseif ($selection -eq 3) {
    Write-Output "Output 3 chosen"
    $filename = Read-Host "Enter the file name you want to read: "
    $realfile = Test-Path $env:userprofile/$filename
    if ($realfile -eq $true) {
        Get-Content -Path "$env:userprofile/$filename"
    }
    else {
        Write-Output "File not found"
    }
}

else {
    Write-Output "Invalid selection entered on $env:COMPUTERNAME by $env:USERNAME"
}
#end part 3 and 4
