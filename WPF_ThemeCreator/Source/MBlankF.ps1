#========================================================================
#
# Tool Name	: @ProjectName@
# Author 	: @Autor@
#
#========================================================================

##Initialize######
[System.Void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				
[System.Void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll') 
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.FontAwesome.dll')
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.Material.dll') 
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.MaterialLight.dll') 
[System.Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.Modern.dll') 


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

#Close the application
$WPF_Close.add_Click({

	$Form.Close()
 
 })

# Change the Theme to Dark or Light
 $WPF_Theme.Add_Click({
	 $Theme = [MahApps.Metro.ThemeManager]::DetectAppStyle($Form)	
	 $my_theme = ($Theme.Item1).name
	 If($my_theme -eq "BaseLight")
		 {
			 [MahApps.Metro.ThemeManager]::ChangeAppStyle($Form, $Theme.Item2, [MahApps.Metro.ThemeManager]::GetAppTheme("BaseDark"));		
				 
		 }
	 ElseIf($my_theme -eq "BaseDark")
		 {					
			 [MahApps.Metro.ThemeManager]::ChangeAppStyle($Form, $Theme.Item2, [MahApps.Metro.ThemeManager]::GetAppTheme("BaseLight"));			
		 }		
 })
 
 # Open Flyout
 $WPF_Accent.add_Click({
 
 $WPF_Flyout.IsOpen =$true
 
 })
 
  # Find All Accent
 $AccentD = [MahApps.Metro.ThemeManager]::Accents
 $AccentColors = $($AccentD.Name)
 
  # Populate Accent into the Conbobox
 foreach ($item in $AccentColors)
 {
	 $WPF_MAccent.Items.Add($item)| Out-Null
 }
 
# On change selection change Accent
 $WPF_MAccent.Add_SelectionChanged({
 
	 $MTheme = [MahApps.Metro.ThemeManager]::DetectAppStyle($Form)	
	 
	 $Value = $WPF_MAccent.SelectedValue
 
	 [MahApps.Metro.ThemeManager]::ChangeAppStyle($Form, [MahApps.Metro.ThemeManager]::GetAccent("$Value"), $MTheme.Item1);	
 
 })

 # Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)
 
# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()

 
 $Form.ShowDialog() | Out-Null
 
 