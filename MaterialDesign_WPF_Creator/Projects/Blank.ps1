#========================================================================
#
# Tool Name	: @ProjectName@
# Author 	: @Autor@
#
#========================================================================

##Initialize######
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       			| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignThemes.Wpf.dll') 			| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignColors.dll')       			| out-null
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

$Form.ShowDialog() | Out-Null

