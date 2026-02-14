# Put this profile file into %userprofile%\[My] Documents\WindowsPowerShell for yoursef only.
# Put this profile file into $windir%\system32\WindowsPowerShell\v1.0 for everyone in your computer


# Set the $BasePath to the directory which your tools are placed
# Warn that this profile only add every subdirectory in the $BasePath to your PATH envionment, exclude the $BasePath itself
$BasePath = new-object System.IO.DirectoryInfo "C:\tools"

# If you want add the $BasePath, please uncomment the comment
$Env:Path = $Env:Path + ";" + $BasePath

Get-ChildItem $BasePath | ForEach-Object -Process {
if($_ -is [System.IO.DirectoryInfo]) {
    $Env:Path=$Env:Path + ";" + $BasePath.FullName + "\" + $_.Name;
    }
}

# Run the program as adminstrator
function Invoke-Admin() {
    param ( [string]$program = $(throw "Please specify a program"),
            [string]$argumentString = "",
            [switch]$waitForExit )

    $psi = new-object "Diagnostics.ProcessStartInfo"
    $psi.FileName = $program
    $psi.Arguments = $argumentString
    $psi.Verb = "runas"
    $proc = [Diagnostics.Process]::Start($psi)
    if ( $waitForExit ) {
        $proc.WaitForExit();
    }
}

Set-Alias which where.exe
