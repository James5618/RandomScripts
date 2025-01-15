$source = $PSScriptRoot
$username = $Env:UserName
cp -force "Normal.dotm" "C:\Users\$username\AppData\Roaming\Microsoft\Templates\"
cp -force "NormalEmail.dotm" "C:\Users\$username\AppData\Roaming\Microsoft\Templates\"