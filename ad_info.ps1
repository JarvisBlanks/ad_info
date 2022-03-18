$ad = @(
    [pscustomobject]@{AD='ServerName';IP='X.X.X.X'}
   )

$fnc = @(
    [pscustomobject]@{Desc="1) Lookup Employee ID.";Name="elookup"}
    [pscustomobject]@{Desc="2) List Users' Groups.";Name="glookup"}
    [pscustomobject]@{Desc="3) Lookup SID.";Name="slookup"}
    [pscustomobject]@{Desc="4) List Users in a Group.";Name="grlookup"}
    [pscustomobject]@{Desc="5) Lookup Email Address.";Name="emlookup"}
    [pscustomobject]@{Desc="6) List Home Drive Path.";Name="hdlookup"}
)
function welcome{
    Write-Host "What would you like to do?"
    foreach ($opt in $fnc){
        Write-Host "$($opt.Desc)"
    }
    $option = Read-Host "Make a selection (1-$($fnc.count))"
    $option = $option -as [int]
    $selection = $option - 1
    if ($selection -ne -1) {
        &$fnc.Name[$selection]
    }
    else{
        Write-Host "No Matching variable";Exit
    }
}
function elookup {
    $emp_id = Read-Host "Please enter the employee ID"
    foreach ($server in $ad) {
        $cmd = get-aduser -server $($server.IP) -Filter {CN -eq $emp_id} -Properties *
        if ($cmd){
            write-host "$($server.AD): $($cmd.CN) $($cmd.GivenName) $($cmd.Surname)"
        }
        else{
            Write-Host "$($server.AD): No match"
        }
    }
}

function glookup {
    $emp_id = Read-Host "Please enter the employee ID"
    foreach ($server in $ad) {
        $cmd = get-aduser -server $($server.IP) -Filter {CN -eq $emp_id} -Properties *
        if ($cmd){
            write-host "$($server.AD):"
            foreach($line in $cmd.MemberOf){
                $CharArray = $line.Split("=");$grp = $CharArray[1];$CharArray = $grp.Split(",");write-host $CharArray[0]
            }
        }
        else{
            Write-Host "$($server.AD): No match"
        }
    }
}

function slookup {
    $emp_id = Read-Host "Please enter the SID"
    foreach ($server in $ad) {
        $cmd = get-aduser -server $($server.IP) -Filter {SID -eq $emp_id} -Properties *
        if ($cmd){
            "$($server.AD): $($cmd.CN) $($cmd.GivenName) $($cmd.Surname)"
        }
        else{
            Write-Host "$($server.AD): No match"
        }
    }
}
function grlookup {
    $emp_id = Read-Host "Please enter the group name"
    $emp_id = "*$emp_id*"
    foreach ($server in $ad) {
        $cmd = Get-ADGroup -server "$($server.IP)" -Filter {name -like $emp_id} | Get-ADGroupMember | Get-ADUser -Properties CN, GivenName, Surname
        if ($cmd){
            write-host "$($server.AD):"
            foreach($line in $cmd){
                Write-Host $line.CN $line.GivenName $line.Surname
            }
        }
        else{
            Write-Host "$($server.AD): No match"
        }
    }
}
function emlookup {
    $emp_id = Read-Host "Please enter the email address"
    foreach ($server in $ad) {
        $cmd = get-aduser -server "$($server.IP)" -Filter {emailaddress -eq $emp_id} -Properties *
        if ($cmd){"$($server.AD): $($cmd.CN) $($cmd.GivenName) $($cmd.Surname)"}
            else{Write-Host "$($server.AD): No match"}
    }
}

function hdlookup {
    $emp_id = Read-Host "Please enter the employee ID"
    foreach ($server in $ad) {
        $cmd = get-aduser -server $($server.IP) -Filter {CN -eq $emp_id} -Properties *
        if ($cmd){
            write-host "$($server.AD): $($cmd.CN) $($cmd.GivenName) $($cmd.Surname) $($cmd.HomeDirectory)"
        }
        else{
            Write-Host "$($server.AD): No match"
        }
    }
}

&welcome
Write-Host "Would you like to run again or exit?"
$cont = Read-Host "Please Type 'Y' or 'N' Default: (N)"
if ($cont = "Y"){&welcome}else{Write-Host "Goodbye!"}