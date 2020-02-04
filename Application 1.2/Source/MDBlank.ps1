#========================================================================
#
# Tool Name	: @ProjectName@
# Author 	: @Autor@
#
#========================================================================

##Initialize######
[System.Void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll')
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignThemes.Wpf.dll')
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignColors.dll')
[String]$ScriptDirectory = split-path $myinvocation.mycommand.path

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("$ScriptDirectory\main.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)


$XamlMainWindow.SelectNodes("//*[@Name]") | %{
    try {Set-Variable -Name "$("WPF_"+$_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable *WPF*
}
  #Get-FormVariables


$WPF_App_Close.add_Click({

   $Form.Close()

})

# Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)
 
# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()


$Form.ShowDialog() | Out-Null

