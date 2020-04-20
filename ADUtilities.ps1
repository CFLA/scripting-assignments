<#
    PowerShell Lab 7
    Creating and changing groups, OUs, and group membership
    Date: 4/17/2020
    Created by: Lars Andersland
#>

Clear-Host
Import-Module activedirectory
$theoptions = "a","b","c","d","e","f","g","h","i","j","k","l","m","n"

Write-Host "Choose from the following Menu Items:"
Write-Host "`tA. VIEW one OU           B. VIEW all OUs"
Write-Host "`tC. VIEW one group        D. VIEW all groups"
Write-Host "`tE. VIEW one user         F. VIEW all users"
Write-Host "`n"

Write-Host "`tG. CREATE one OU         H. CREATE one group"
Write-Host "`tI. CREATE one user `t     J. CREATE users from CSVfile"
Write-Host "`n"

Write-Host "`tK. ADD user to group     L. REMOVE user from group"
Write-Host "`n"

Write-Host "`tM. DELETE one group      N. DELETE one user"
Write-Host "`n"

$selection = "a" <#placeholder variable#>

while($theoptions -contains $selection) {
$selection = Read-Host "Enter anything other than A - N to quit"
    if($selection -eq "a") {
        $ouname = "Enter the name of the OU you want to view"
        Get-ADOrganizationalUnit -Identity $ouname | Format-Table -Property Name, DistinguishedName
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "b") {
        Get-ADOrganizationalUnit -Filter "Name -ne 'Domain Controllers'" | Format-Table -Property Name, DistinguishedName
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "c") {
        $groupname = Read-Host "Enter a group name: "
        Get-ADGroup -filter {name -eq $groupname} | Format-Table -Property Name, GroupScope, GroupCategory
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "d") {
        Get-ADGroup | Format-Table -Property Name, GroupScope, GroupCategory
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "e") {
        $nameofuser = Read-Host "Enter the name of the user you want to view: "
        Get-ADUser -Identity $nameofuser | Format-Table -Property Name, DistinguishedName
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "f") {
        Get-ADUser | Format-Table -Property Name, DistinguishedName, FirstName, LastName
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "g") {
        $ouname = Read-Host "Enter the name of the OU to be created: "
        New-ADOrganizationalUnit -Name $ouname
        Get-ADOrganizationalUnit -Filter {name -eq $ouname} | Format-Table -Property Name, DistinguishedName
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "h") {
        $groupname = Read-Host "Enter the name of the group to be created: "
        New-ADGroup -Name $groupname
        Get-ADGroup -Identity $groupname | Format-Table -Property Name, GroupScope, GroupCategory
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "i") {
        $nameofuser = Read-Host "Enter the name of the user to be created: "
        $givenname = Read-Host "Enter the user's given name: "
        $surname = Read-Host "Enter the user's surname: "
        $address = Read-Host "Enter the user's address: "
        $city = Read-Host "Enter the user's city: "
        $state = Read-Host "Enter the user's state: "
        $postalcode = Read-Host "Enter the user's ZIP code: "
        $company = Read-Host "Enter the user's company: "
        $division = Read-Host "Enter the user's division: "
        $yn = Read-Host "Will this user be part of the Users container? (Y/N) "
        if ($yn -eq "y") {
            New-ADUser -Name $nameofuser -Path "OU=Users" -SamAccountName $nameofuser -UserPrincipalName $nameofuser + "@yourdomain.com" -GivenName $givenname -Surname $surname -StreetAddress $address -City $city -PostalCode $postalcode -Company $company -Division $division
        }
        else {
            $oupath = Read-Host "Enter the name of the OU you want to put the user in"
            New-ADUser -Name $nameofuser -Path $oupath -SamAccountName $nameofuser -UserPrincipalName $nameofuser + "@yourdomain.com" -GivenName $givenname -Surname $surname -StreetAddress $address -City $city -PostalCode $postalcode -Company $company -Division $division
        }
        Get-ADUser -Identity $nameofuser | Format-Table -Property Name, DistinguishedName
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "j") {
        $file = Read-Host "Enter the name of the csv: "
        $password = Read-Host "Enter the password: "
        $securepass = (ConvertTo-SecureString -String $password -AsPlainText -Force)
        $users = Import-Csv -Path $env:USERPROFILE\usercreation.csv
        $users | New-ADUser -AccountPassword $securepass -Enabled $true
        Get-ADUser | Format-List -Property Name, SamAccountName, UserPrincipalName, GivenName, Surname, City, State, PostalCode, Company, Division
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "k") {
        $groupname = Read-Host "Enter a group name: "
        $nameofuser = Read-Host "Enter the name of the user who will be added to this group: "
        Add-ADGroupMember -Identity $groupname -Members $nameofuser
        Get-ADGroupMember | Format-Table -Property SamAccountName, DistinguishedName
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "l") {
        $groupname = Read-Host "Enter a group name: "
        Get-ADGroup -Identity $groupname | Format-Table -Property SamAccountName
        $response = Read-Host "Would you like to remove a user account? (Y/N)"
        if ($response -eq "y") {
            $nameofuser = Read-Host "Enter the name of the user to remove: "
            Remove-ADUser -Identity $nameofuser
            Get-ADGroup -Identity $groupname | Format-Table -Property Name, GroupScope, GroupCategory
            Read-Host "Press Enter to Continue..."
            }
        else {
            Read-Host "Press Enter to Continue..."
        }
    }

    elseif($selection -eq "m") {
        $groupname = Read-Host "Enter the name of the group you want to delete: "
        Remove-ADGroup -Identity $groupname
        Get-ADGroup | Format-Table -Property Name, GroupScope, GroupCategory
        Read-Host "Press Enter to Continue..."
    }

    elseif($selection -eq "n") {
        $nameofuser = Read-Host "Enter the name of the user you want to delete: "
        Remove-ADUser -Identity $nameofuser
        Get-ADUser | Format-Table -Property Name, DistinguishedName
        Read-Host "Press Enter to Continue..."
    }

    else{
        Write-Host "`nGoodbye!"
    }
}