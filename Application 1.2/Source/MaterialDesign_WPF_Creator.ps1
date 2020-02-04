#========================================================================
#
# Tool Name	: ThemeManager for WPF
# Author 	: Jérôme Bezet-Torres
# Date 		: 27/08/2019
# Website	: http://JM2K69.github.io/
# Twitter	: https://twitter.com/JM2K69
#
#========================================================================

[String]$ScriptDirectory = split-path $myinvocation.mycommand.path

[System.void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  				
[System.void][System.Reflection.Assembly]::LoadWithPartialName("presentationframework") 				
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\MahApps.Metro.dll") 
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\ControlzEx.dll") 
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\MahApps.Metro.IconPacks.dll") 
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\MahApps.Metro.IconPacks.FontAwesome.dll") 
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\MahApps.Metro.IconPacks.Material.dll") 
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\MahApps.Metro.IconPacks.MaterialLight.dll") 
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\MahApps.Metro.IconPacks.Modern.dll") 
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\System.Windows.Interactivity.dll") 
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\RadialMenu.dll")        
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\MaterialDesignThemes.Wpf.dll") 			
[System.void][System.Reflection.Assembly]::LoadFrom("$ScriptDirectory\MaterialDesignColors.dll")       			



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

  $Global:My_accent = ""
  $Global:My_Primary = ""
  $Global:Theme = "Dark"
  $Global:ReziseMode = ""
  $Global:Flyout = $false
  $Global:MTheme = "BaseLight"
  $Global:IconPacks = $False

# Close Main menu
$WPF_Close.Add_Click({
   $WPF_MainMenu.IsOpen = $false
   $WPF_M_Choice.IsOpen = $true
})
$WPF_Drag_Drop.add_PreviewMouseLeftButtonDown({
  $_.handled=$true
  $Form.DragMove()   
})

$WPF_M_Drag_Drop.add_PreviewMouseLeftButtonDown({
   $_.handled=$true
   $Form.DragMove()   
 })
 

$WPF_F_Drag_Drop.add_PreviewMouseLeftButtonDown({
   $_.handled=$true
   $Form.DragMove()   
 })
 
$WPF_Open_Windows_Properties.add_Click({
   
    $WPF_MainMenu.IsOpen = $false

    [XML]$xaml=@"
    
    <Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Width="750"
    WindowStyle = "None"
    WindowStartupLocation="CenterScreen"
    FontFamily="{DynamicResource MaterialDesignFont}"
    TextElement.FontSize="13"
    TextOptions.TextFormattingMode="Ideal"
    TextOptions.TextRenderingMode="Auto"
    AllowsTransparency = "true"
    Background="Transparent">
 <Window.Resources>
    <ResourceDictionary>
       <ResourceDictionary.MergedDictionaries>
          <materialDesign:BundledTheme BaseTheme="Light" PrimaryColor="Cyan" SecondaryColor="Lime" />
          <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Defaults.xaml" />
 </ResourceDictionary.MergedDictionaries>
    </ResourceDictionary>
 </Window.Resources>
 <Grid>
 <GroupBox Margin="16" Name="G1" Header="Windows Properties" Style="{DynamicResource MaterialDesignCardGroupBox}">
    <GroupBox.HeaderTemplate>
       <DataTemplate>
          <StackPanel Orientation="Horizontal">
             <materialDesign:PackIcon Width="32" Height="32" VerticalAlignment="Center" Kind="WindowRestore"/>
             <TextBlock Margin="8,0,0,0" VerticalAlignment="Center" Style="{StaticResource MaterialDesignSubheadingTextBlock}" Text="{Binding}"/>
          </StackPanel>
       </DataTemplate>
    </GroupBox.HeaderTemplate>
    <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Vertical">
       <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Horizontal">
          <StackPanel HorizontalAlignment="Center" Margin="0 0 30 0 " Orientation="Vertical">
             <GroupBox Height="315">
                <GroupBox.HeaderTemplate>
                   <DataTemplate>
                      <StackPanel Orientation="Horizontal">
                         <materialDesign:PackIcon Width="34" Height="34" Margin="0 0 5 0" Kind="MoveResizeVariant"/>
                         <TextBlock HorizontalAlignment="Center" Margin="5 10 0 0" Style="{StaticResource MaterialDesignTitleTextBlock}" Text="Windows Size">
                         </TextBlock>
                      </StackPanel>
                   </DataTemplate>
                </GroupBox.HeaderTemplate>
                <StackPanel HorizontalAlignment="Left" VerticalAlignment="Center" Orientation="Vertical">
                   <StackPanel Orientation="Horizontal">
                      <Slider
                         Name="Slider_H"
                         Height="200"
                         Margin="0 30 0 0 "
                         Maximum="1200"
                         Minimum="300"
                         Orientation="Vertical"
                         TickFrequency="200"
                         TickPlacement="BottomRight"
                         Value="600"/>
                      <Slider
                         Name="Slider_W"
                         Width="200"
                         Margin="-20 0 0 0 "
                         Maximum="1200"
                         Minimum="300"
                         Orientation="Horizontal"
                         TickFrequency="200"
                         TickPlacement="BottomRight"
                         Value="600"/>
                      <StackPanel HorizontalAlignment="Left" Orientation="Vertical">
                         <TextBlock HorizontalAlignment="Center" Margin="-180 90 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="{Binding ElementName=Slider_W, Path=Value, StringFormat=Width: {0:0}}">
                         </TextBlock>
                         <TextBlock HorizontalAlignment="Center" Margin="-180 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="{Binding ElementName=Slider_H, Path=Value, StringFormat=Height: {0:0}}">
                         </TextBlock>
                      </StackPanel>
                   </StackPanel>
                   <StackPanel Orientation="Horizontal">
                   </StackPanel>
                </StackPanel>
             </GroupBox>
          </StackPanel>
          <StackPanel HorizontalAlignment="Center" Orientation="Vertical">
             <GroupBox Height="315">
                <GroupBox.HeaderTemplate>
                   <DataTemplate>
                      <StackPanel Orientation="Horizontal">
                         <materialDesign:PackIcon Width="34" Height="34" Margin="0 0 5 0" Kind="WindowRestore"/>
                         <TextBlock HorizontalAlignment="Center" Margin="5 10 0 0" Style="{StaticResource MaterialDesignTitleTextBlock}" Text="Windows Title">
                         </TextBlock>
                      </StackPanel>
                   </DataTemplate>
                </GroupBox.HeaderTemplate>
                <StackPanel HorizontalAlignment="Left" VerticalAlignment="Center" Orientation="Vertical">
                   <StackPanel Orientation="Horizontal">
                      <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="Title :">
                      </TextBlock>
                      <TextBox Name="NameTextBox" Margin="10 0 0 0 " materialDesign:HintAssist.Hint="Title"/>
                   </StackPanel>
                   <StackPanel Orientation="Horizontal">
                      <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="ResizeMode : ">
                      </TextBlock>
                      <StackPanel>
                         <StackPanel Orientation="Horizontal">
                            <ComboBox Name="CB_ResizeM" HorizontalAlignment="Left" Margin="0 8 0 8" materialDesign:ComboBoxAssist.ShowSelectedItem="{Binding ElementName=DisplaySelectedItemCheckBox, Path=IsChecked}">
                               <ComboBoxItem Name="NoResize" IsSelected="True">
                                 NoResize
                               
                               </ComboBoxItem>
                               <ComboBoxItem Name="CanMinimize">
                                 CanMinimize
                               
                               </ComboBoxItem>
                               <ComboBoxItem Name="CanResize">
                                 CanResize
                               
                               </ComboBoxItem>
                               <ComboBoxItem Name="CanResizeWithGrip">
                                 CanResizeWithGrip
                               
                               </ComboBoxItem>
                            </ComboBox>
                            <CheckBox Name="DisplaySelectedItemCheckBox" Margin="2 8 0 0" IsChecked="True" IsThreeState="False" Visibility="Hidden">
                            </CheckBox>
                         </StackPanel>
                      </StackPanel>
                   </StackPanel>
                   <StackPanel Orientation="Horizontal">
                      <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="WindowStartupLocation : ">
                      </TextBlock>
                      <StackPanel>
                         <StackPanel Orientation="Horizontal">
                            <ComboBox Name="CB_WindowsStartupLocation" HorizontalAlignment="Left" Margin="0 8 0 8" materialDesign:ComboBoxAssist.ShowSelectedItem="{Binding ElementName=DisplaySelectedItemCheckBox, Path=IsChecked}">
                               <ComboBoxItem Name="Manual" IsSelected="True">
                                 Manual
                               
                               </ComboBoxItem>
                               <ComboBoxItem Name="CenterScreen">
                                 CenterScreen
                               
                               </ComboBoxItem>
                               <ComboBoxItem Name="CenterOwner">
                                 CenterOwner
                               
                               </ComboBoxItem>
                            </ComboBox>
                            <CheckBox Name="DisplaySelectedItemCheckBox3" Margin="2 8 0 0" IsChecked="True" IsThreeState="False" Visibility="Hidden">
                            </CheckBox>
                         </StackPanel>
                      </StackPanel>
                   </StackPanel>
                   <StackPanel Orientation="Horizontal">
                      <StackPanel Orientation="Horizontal" Margin="2 0 0 0">
                         <TextBlock HorizontalAlignment="Center" Margin="0 10 0 5" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="Theme  : ">
                      </TextBlock>
                        <TextBox IsReadOnly="True" Margin="5 0 0 5">Light</TextBox>
                           <ToggleButton Margin=" 5 10 0 0" Name="Mode" Style="{StaticResource MaterialDesignSwitchToggleButton}" />
                           <TextBox IsReadOnly="True" Margin="10 0 0 5">Dark</TextBox>
                       </StackPanel>
                      <StackPanel>   
                      </StackPanel>
                   </StackPanel>
                   <StackPanel Orientation="Horizontal">
                      <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="Primary : ">
                      </TextBlock>
                      <StackPanel>
                         <StackPanel Orientation="Horizontal">
                         <ComboBox Name="CBX_Primary" materialDesign:HintAssist.Hint="Primary" HorizontalAlignment="Left" Margin="0 8 0 8" materialDesign:ComboBoxAssist.ShowSelectedItem="{Binding ElementName=DisplaySelectedItemCheckBox, Path=IsChecked}" SelectedIndex="7" />
                         </StackPanel>
                      </StackPanel>
                   </StackPanel>
                   <StackPanel Orientation="Horizontal">
                      <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="Accent : ">
                      </TextBlock>
                      <StackPanel>
                         <StackPanel Orientation="Horizontal">
                         <ComboBox Name="CBX_Accent" materialDesign:HintAssist.Hint="Accent" HorizontalAlignment="Left" Margin="0 8 0 8" materialDesign:ComboBoxAssist.ShowSelectedItem="{Binding ElementName=DisplaySelectedItemCheckBox, Path=IsChecked}" SelectedIndex="11" />
                         </StackPanel>
                      </StackPanel>
                   </StackPanel>
                </StackPanel>
             </GroupBox>
          </StackPanel>
       </StackPanel>
       <Button Name="Save" Width="40" Height="40" Margin="0 25 0 0" ToolTip="Save Setting" Style="{StaticResource MaterialDesignFloatingActionAccentButton}">
          <materialDesign:PackIcon Width="24" Height="24" Kind="ContentSaveSettings"/>
       </Button>
    </StackPanel>
 </GroupBox>
 </Grid>
 </Window>
"@
$Child_Properties = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))

$Close = $Child_Properties.findname("Save")
$Mode = $Child_Properties.findname("Mode")
$Slider_W = $Child_Properties.findname("Slider_W")
$Slider_H = $Child_Properties.findname("Slider_H")
$Title = $Child_Properties.findname("NameTextBox")
$NoResize = $Child_Properties.findname("NoResize")
$CanMinimize = $Child_Properties.findname("CanMinimize")
$CanResize = $Child_Properties.findname("CanResize")
$CanResizeWithGrip = $Child_Properties.findname("CanResizeWithGrip")
$Manual = $Child_Properties.findname("Manual")
$CenterScreen = $Child_Properties.findname("CenterScreen")
$CenterOwner = $Child_Properties.findname("CenterOwner")
$ComboBoxPrimary = $Child_Properties.findname("CBX_Primary")
$ComboBoxAccent = $Child_Properties.findname("CBX_Accent")

$CPrimary=@()
$CSecondarys= @()
$CPrimary = [System.Enum]::GetNames([MaterialDesignColors.PrimaryColor])
$CSecondarys=  [System.Enum]::GetNames([MaterialDesignColors.SecondaryColor])

$ComboBoxPrimary | Get-Member
foreach ($item in $CPrimary)
{
    $ComboBoxPrimary.Items.Add($item)
}
foreach ($item in $CSecondarys)
{
    $ComboBoxAccent.Items.Add($item)
}

$ComboBoxPrimary.Add_SelectionChanged({

$theme = [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::GetTheme($Child_Properties.Resources)
$Primary = [MaterialDesignColors.SwatchHelper]::Lookup[$ComboBoxPrimary.SelectedValue]
[MaterialDesignThemes.Wpf.ThemeExtensions]::SetPrimaryColor($theme, $Primary)
[MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::SetTheme($Child_Properties.Resources, $theme)

$Global:My_Primary = $ComboBoxPrimary.SelectedValue

})

$ComboBoxAccent.Add_SelectionChanged({

   $theme = [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::GetTheme($Child_Properties.Resources)
   $Accent = [MaterialDesignColors.SwatchHelper]::Lookup[$ComboBoxAccent.SelectedValue]
   [MaterialDesignThemes.Wpf.ThemeExtensions]::SetSecondaryColor($theme, $Accent)
   [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::SetTheme($Child_Properties.Resources, $theme)
   
   $Global:My_accent = $ComboBoxAccent.SelectedValue
   
   })
   

$Mode.add_Click({

   $theme = [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::GetTheme($Child_Properties.Resources)
   
   if ($Mode.IsChecked -eq $true) {
     [MaterialDesignThemes.Wpf.ThemeExtensions]::SetBaseTheme($theme, [MaterialDesignThemes.Wpf.Theme]::Dark)
     $Global:Theme = "Dark"

   }
   if ($Mode.IsChecked -eq $False) {
     [MaterialDesignThemes.Wpf.ThemeExtensions]::SetBaseTheme($theme, [MaterialDesignThemes.Wpf.Theme]::Light)

     $Global:Theme = "Light"

   }
   [MaterialDesignThemes.Wpf.ResourceDictionaryExtensions]::SetTheme($Child_Properties.Resources, $theme)


})

$Close.add_Click({

  $Global:ProjectTitle = $Title.Text
  [INT]$Global:Width = $Slider_W.Value
  [INT]$Global:Height = $Slider_H.Value

  # Set Rezise Mode
  if ($NoResize.IsSelected -eq $true )
  {
   $Global:ReziseMode = "NoResize"
  } 
  if ($CanMinimize.IsSelected -eq $true )
  {
   $Global:ReziseMode = "CanMinimize"
  } 
  if ($CanResize.IsSelected -eq $true )
  {
   $Global:ReziseMode = "CanResize"
  } 
  if ($CanResizeWithGrip.IsSelected -eq $true )
  {
   $Global:ReziseMode = "CanResizeWithGrip"
  } 

  # Set WindowStartupLocation

  if ($Manual.IsSelected -eq $true )
  {
   $Global:WindowStartupLocation = "Manual"
  } 
  if ($CenterScreen.IsSelected -eq $true )
  {
   $Global:WindowStartupLocation = "CenterScreen"
  } 
  if ($CenterOwner.IsSelected -eq $true )
  {
   $Global:WindowStartupLocation = "CenterOwner"
  } 



  $Global:My_accent = $ComboBoxAccent.SelectedValue

  $Global:My_Primary = $ComboBoxPrimary.SelectedValue

  if ($Mode.IsChecked -eq $true) {
   $Global:Theme = "Dark"

 }
 if ($Mode.IsChecked -eq $False) {

   $Global:Theme = "Light"

 }



  $Child_Properties.Close() 

  $WPF_MainMenu.IsOpen = $true
  $WPF_Create_Project.IsEnabled = $true
})
  
 
$Child_Properties.ShowDialog() 
#End WPF_Open_Windows_Properties.add_Click
})


$WPF_Open_Apps_Info.add_Click({

  $WPF_MainMenu.IsOpen = $false
  $WPF_M_Choice.IsOpen = $False

  [XML]$xaml1=@"
 
<Window
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
Width="650"
WindowStartupLocation="CenterScreen"
FontFamily="{DynamicResource MaterialDesignFont}"
TextElement.FontSize="13"
TextOptions.TextFormattingMode="Ideal"
TextOptions.TextRenderingMode="Auto"
WindowStyle = "None"
AllowsTransparency = "true"
Background="Transparent">
<Window.Resources>
   <ResourceDictionary>
      <ResourceDictionary.MergedDictionaries>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Light.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Defaults.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Primary/MaterialDesignColor.Cyan.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Accent/MaterialDesignColor.Lime.xaml"/>
      </ResourceDictionary.MergedDictionaries>
   </ResourceDictionary>
</Window.Resources>
   <Grid>
   <StackPanel Orientation="Vertical">
      <materialDesign:ColorZone
         Width="290"
         Height="440"
         Margin=" 10 0 0 0 "
         CornerRadius="12"
         materialDesign:ShadowAssist.ShadowDepth="Depth5"
         Mode="PrimaryLight">
      </materialDesign:ColorZone>
      <Button Name="App_Close" Margin="0 -65 0 0" Style="{StaticResource MaterialDesignFloatingActionMiniDarkButton}" ToolTip="Exit">
         <materialDesign:PackIcon Width="27" Height="27" Kind="CloseBoxOutline"/>
      </Button>
   </StackPanel>
   <StackPanel Orientation="Vertical">
      <materialDesign:ColorZone
         Width="250"
         Height="250"
         Margin=" 10 10 0 0 "
         CornerRadius="12"
         materialDesign:ShadowAssist.ShadowDepth="Depth5"
         Mode="Standard">
         <Grid>
            <Grid.RowDefinitions>
               <RowDefinition Height="140"/>
               <RowDefinition Height="*"/>
               <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
               <Border  Margin="2 2 3 2" Height="Auto" Width="Auto" CornerRadius="10,10,10,10"  BorderBrush="Black" BorderThickness="1">
                  <Border.Effect>
                     <DropShadowEffect ShadowDepth="2"/>
                  </Border.Effect>
                  <Border.Background>
                     <ImageBrush ImageSource="$ScriptDirectory\pwsh.jpg" />
                  </Border.Background>
               </Border>
            <StackPanel Grid.Row="1" Margin="8 15 8 0">
               <TextBlock FontWeight="Bold">@JM2K69
               </TextBlock>
               <TextBlock VerticalAlignment="Center" TextWrapping="Wrap"> 
         Microsoft Certified Trainer 7 Year / PowerShell / PowerCli / Deployment / MDT / XAML / WPF / Automation
               </TextBlock>
            </StackPanel>
            <StackPanel Grid.Row="2" HorizontalAlignment="Right" Margin="5" Orientation="Horizontal">
            </StackPanel>
         </Grid>
      </materialDesign:ColorZone>
      <materialDesign:ColorZone
         Width="250"
         Height="110"
         Margin=" 10 10 0 0 "
         CornerRadius="12"
         materialDesign:ShadowAssist.ShadowDepth="Depth3"
         Mode="Light">
         <Grid>
            <StackPanel Grid.Row="1" HorizontalAlignment="Center" Margin="8 10 8 0" VerticalAlignment="Top">
               <TextBlock FontWeight="Bold">	Follow Me on different social networks
               </TextBlock>
               <StackPanel HorizontalAlignment="Center" Margin="0 15 0 0" Orientation="Horizontal">
                  <Button
                     Name="Twitter_P"
                     Grid.Row="0"
                     HorizontalAlignment="Left"
                     Margin="0 5 16 -20"
                     VerticalAlignment="Top"
                     Style="{StaticResource MaterialDesignFloatingActionMiniAccentButton}"
                     ToolTip="Twitter Profile">
                     <materialDesign:PackIcon Width="20" Height="20" Kind="Twitter"/>
                  </Button>
                  <Button
                     Name="Github_P"
                     Grid.Row="0"
                     HorizontalAlignment="Left"
                     Margin="0 5 16 -20"
                     VerticalAlignment="Top"
                     Style="{StaticResource MaterialDesignFloatingActionMiniAccentButton}"
                     ToolTip="Github Profile">
                     <materialDesign:PackIcon Width="20" Height="20" Kind="GithubBox"/>
                  </Button>
                  <Button
                     Name="Youtube_P"
                     Grid.Row="0"
                     HorizontalAlignment="Left"
                     Margin="0 5 16 -20"
                     VerticalAlignment="Top"
                     Style="{StaticResource MaterialDesignFloatingActionMiniAccentButton}"
                     ToolTip="Youtube Chaine">
                     <materialDesign:PackIcon Width="20" Height="20" Kind="YoutubePlay"/>
                  </Button>
               </StackPanel>
            </StackPanel>
         </Grid>
      </materialDesign:ColorZone>
   </StackPanel>
</Grid>
</Window>
"@

$Child_Apps = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml1))

$Close = $Child_Apps.findname("App_Close") 
$Twitter_P=  $Child_Apps.findname("Twitter_P") 
$Github_P=  $Child_Apps.findname("Github_P") 
$Youtube_P=  $Child_Apps.findname("Youtube_P") 

$Close.add_Click({

  $Child_Apps.Close() 
  $WPF_M_Choice.IsOpen = $true
})

$Twitter_P.add_Click({

  start-process https://twitter.com/JM2K69 

})

$Github_P.add_Click({

  Start-Process https://github.com/JM2K69

})

$Youtube_P.add_Click({

  Start-Process https://www.youtube.com/channel/UCw0FgKxddLugh9EpxccqZ4Q

})


$Child_Apps.ShowDialog()


})

$WPF_Open_Project_Settings.add_Click({

  $WPF_MainMenu.IsOpen = $false

  [XML]$xaml2=@"
 <Window
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Width="450"
  Height="450"
  WindowStyle = "None"
  WindowStartupLocation="CenterScreen"
  FontFamily="{DynamicResource MaterialDesignFont}"
  TextElement.FontSize="13"
  TextOptions.TextFormattingMode="Ideal"
  TextOptions.TextRenderingMode="Auto"
  AllowsTransparency = "true"
  Background="Transparent">
  <Window.Resources>
     <ResourceDictionary>
        <ResourceDictionary.MergedDictionaries>
           <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Light.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Defaults.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Primary/MaterialDesignColor.Cyan.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Accent/MaterialDesignColor.Lime.xaml"/>
          </ResourceDictionary.MergedDictionaries>
     </ResourceDictionary>
  </Window.Resources>
 <Grid>
     <GroupBox Margin="16" Header="Project Properties" Style="{DynamicResource MaterialDesignCardGroupBox}" Width="450">
        <GroupBox.HeaderTemplate>
           <DataTemplate>
              <StackPanel Orientation="Horizontal">
                 <materialDesign:PackIcon Width="32" Height="32" VerticalAlignment="Center" Kind="WindowRestore"/>
                 <TextBlock Margin="8,0,0,0" VerticalAlignment="Center" Style="{StaticResource MaterialDesignTitleTextBlock}" Text="{Binding}"/>
              </StackPanel>
           </DataTemplate>
        </GroupBox.HeaderTemplate>
        <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Vertical">
           <StackPanel VerticalAlignment="Center" Orientation="Horizontal">
             <StackPanel HorizontalAlignment="Left" Orientation="Vertical">
                 <GroupBox Margin="-20 0 0 0" Height="205" Width="250">
                    <GroupBox.HeaderTemplate>
                       <DataTemplate>
                          <StackPanel Orientation="Horizontal">
                             <materialDesign:PackIcon Width="34" Height="34" Margin="0 0 5 0" Kind="WindowRestore"/>
                             <TextBlock HorizontalAlignment="Left" Margin="5 10 0 0" Style="{StaticResource MaterialDesignSubheadingTextBlock}" Text="Project Settings">
                             </TextBlock>
                          </StackPanel>
                       </DataTemplate>
                    </GroupBox.HeaderTemplate>
                    <StackPanel HorizontalAlignment="Left" VerticalAlignment="Center" Orientation="Vertical">
                       <StackPanel Orientation="Horizontal">
                          <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="Project name :">
                          </TextBlock>
                          <TextBox Name="NameProject" Margin="10 0 0 0 " materialDesign:HintAssist.Hint="Name"/>
                       </StackPanel>
                      <StackPanel Orientation="Horizontal">
                          <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="Author :">
                          </TextBlock>
                          <TextBox Name="Author" Margin="10 0 0 0 " materialDesign:HintAssist.Hint="Author"/>
                       </StackPanel>
                    </StackPanel>
                 </GroupBox>
              </StackPanel>
           </StackPanel>
           <Button Name="Save" Width="100" Height="40" Margin="0 25 0 0" ToolTip="Save Setting">
              <materialDesign:PackIcon Width="24" Height="24" Kind="ContentSaveSettings"/>
           </Button>
        </StackPanel>
     </GroupBox>
  </Grid>

</Window>
"@
  
  $Child_Project = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml2))
  $Save = $Child_Project.findname("Save") 
  $Projectname = $Child_Project.findname("NameProject")
  $Author = $Child_Project.findname("Author")


  $Save.add_Click({

    $Global:Author = $Author.Text
    $Global:ProjectName = $Projectname.Text
    $Child_Project.Close() 
    $WPF_MainMenu.IsOpen = $true

  })
  

  $Child_Project.ShowDialog()


})

$WPF_Create_Project.Add_Click({
 
   $WPF_MainMenu.IsOpen = $true

  #Create The Project Folder

  try{New-Item -Name "Projects" -Path "$env:HOMEDRIVE\Users\$env:USERNAME\desktop" -ItemType Directory}
  catch{}
  New-Item -Name  "$Global:ProjectName" -Path "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\" -ItemType Directory 
  New-Item -Name  "Assembly" -Path "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\" -ItemType Directory 

  # Copy assembly
  Copy-Item -Path "$ScriptDirectory\*.dll" -Exclude RadialMenu.dll,MahApps.Metro.IconPacks.dll,MahApps.Metro.IconPacks.FontAwesome.dll,MahApps.Metro.IconPacks.Material.dll,MahApps.Metro.IconPacks.MaterialLight.dll,MahApps.Metro.IconPacks.Modern.dll -Destination "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\Assembly" 

  # Create the Powershell Project
  $File_Pwsh = Get-Content "$ScriptDirectory\MDBlank.Ps1" -raw
  $File_Pwsh.replace("@ProjectName@", $Global:ProjectName).replace("@Autor@", $Global:Author)  | Out-File -FilePath "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\$Global:ProjectName.ps1"

  #Create XAML File
  $File_XAML =  "$ScriptDirectory\MDMain.xaml" 
  $XAML_file =  "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\Main.xaml"
  (Get-Content $File_XAML) | ForEach-Object {
		$_.replace("@Title@", $Global:ProjectTitle).replace("@Height@", $Global:Height).replace("@Width@", $Global:Width).replace("@WindowStratupLocation@", $Global:WindowStartupLocation).replace("@ReziseMode@", $Global:ReziseMode).replace("@theme@", $Global:Theme).replace("@Primary@", $Global:My_Primary).replace("@accent@", $Global:My_accent)
	 } | Set-Content $XAML_file	

    $WPF_Launch_Project.IsEnabled = $true

})

$WPF_Launch_Project.Add_Click({

   Set-Location "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName"
   $File = $(gci *.ps1).name
   powershell.exe -sta .\$File

})

$WPF_M_Launch_Project.Add_Click({

   Set-Location "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName"
   $File = $(gci *.ps1).name
   powershell.exe -sta .\$File

})


$WPF_MainMenu.IsOpen = $false
$WPF_M_Choice.IsOpen = $true

$WPF_M_Close.Add_Click({
	break
})

$WPF_MaterialD_Application.Add_Click({

   $WPF_M_Choice.IsOpen = $false
   $WPF_MainMenu.IsOpen = $true


})

$WPF_Mahapps_Application.Add_Click({

   $WPF_M_Choice.IsOpen = $false
   $WPF_Ma_MainMenu.IsOpen= $true

})

$WPF_M_Back.add_Click({

   $WPF_M_Choice.IsOpen = $true
   $WPF_Ma_MainMenu.IsOpen= $false

})


$WPF_M_Open_Project_Settings.add_Click({

   $WPF_MainMenu.IsOpen = $false
 
[XML]$xamlM=@"
<Controls:MetroWindow
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:Controls="http://metro.mahapps.com/winfx/xaml/controls"
  xmlns:iconPacks="http://metro.mahapps.com/winfx/xaml/iconpacks"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Width="380"
  Height="350"
 WindowStartupLocation="CenterScreen"
  AllowsTransparency = "true"
  UseNoneWindowStyle="True"
  WindowStyle="None">
  
  <Window.Resources>
   <ResourceDictionary>
      <ResourceDictionary.MergedDictionaries>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Cobalt.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml"/>
      </ResourceDictionary.MergedDictionaries>
   </ResourceDictionary>
</Window.Resources>
 <Grid>
     <GroupBox Header="Project Properties"  Width="380" Height="350">
        <GroupBox.HeaderTemplate>
           <DataTemplate>
              <StackPanel Orientation="Horizontal">
               <iconPacks:PackIconMaterial Kind="Application" Width="22" Height="22" />
                 <TextBlock Margin="8,0,0,0" VerticalAlignment="Center" Text="{Binding}"/>
              </StackPanel>
           </DataTemplate>
        </GroupBox.HeaderTemplate>
        <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Vertical">
           <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Horizontal">
             <StackPanel HorizontalAlignment="Center" Orientation="Vertical">
                 <GroupBox  Header="Project settings" Height="205" Width="250">
                    <GroupBox.HeaderTemplate>
                       <DataTemplate>
                          <StackPanel Orientation="Horizontal" HorizontalAlignment="Left" >
                           <iconPacks:PackIconMaterial Kind="Application" Margin="5 5 0 0" Width="18" Height="18"/>
                              <TextBlock Margin="8,5,0,0" VerticalAlignment="Center" Text="{Binding}" FontSize="12">
                             </TextBlock>
                          </StackPanel>
                       </DataTemplate>
                    </GroupBox.HeaderTemplate>
                    <StackPanel HorizontalAlignment="Left" VerticalAlignment="Center" Orientation="Vertical">
                       <StackPanel Orientation="Horizontal">
                          <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Text="Project name :" FontWeight="Bold" FontSize="14">
                          </TextBlock>
                          <TextBox Name="NameProject_Mahapps" Controls:TextBoxHelper.Watermark=" Project name" Margin="10 5 0 25 " Controls:TextBoxHelper.ClearTextButton="True" />
                       </StackPanel>
                      <StackPanel Orientation="Horizontal">
                          <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0"  Text="Author :" FontWeight="Bold" FontSize="14">
                          </TextBlock>
                          <TextBox Name="Author_Mahapps" Controls:TextBoxHelper.Watermark=" Author name" Margin="50 5 0 25 " Controls:TextBoxHelper.ClearTextButton="True" />
                       </StackPanel>
                    </StackPanel>
                 </GroupBox>
              </StackPanel>
           </StackPanel>
            <Button Name="M_PSave" Width="45" Height="45" Margin="-20 35 0 0" Style="{DynamicResource MahApps.Metro.Styles.MetroCircleButtonStyle}">
      <iconPacks:PackIconMaterial Kind="ContentSaveOutline" Width="20" Height="20"/>
</Button>
        </StackPanel>
     </GroupBox>
  </Grid>

</Controls:MetroWindow>
"@
   
   $Child_M_Project = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xamlM))
   $Save = $Child_M_Project.findname("M_PSave") 
   $Projectname = $Child_M_Project.findname("NameProject_Mahapps")
   $Author = $Child_M_Project.findname("Author_Mahapps")
  
   $Save.add_Click({
 
     $Global:Author = $Author.Text
     $Global:ProjectName = $Projectname.Text
     $Child_M_Project.Close() 
     $WPF_Ma_MainMenu.IsOpen = $true
 
   })
   
   $Child_M_Project.ShowDialog()
 
 })
 

 $WPF_M_Open_Windows_Properties.add_Click({
   
   $WPF_MainMenu.IsOpen = $false

   [XML]$xamlM1=@"
   <Controls:MetroWindow
   xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
   xmlns:Controls="http://metro.mahapps.com/winfx/xaml/controls"
   xmlns:iconPacks="http://metro.mahapps.com/winfx/xaml/iconpacks"
   xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
   Width="650"
   Height="620"
   WindowStartupLocation="CenterScreen"
   AllowsTransparency = "true"
   UseNoneWindowStyle="True"
   WindowStyle="None">
<Window.Resources>
   <ResourceDictionary>
      <ResourceDictionary.MergedDictionaries>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Cobalt.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml"/>
      </ResourceDictionary.MergedDictionaries>
   </ResourceDictionary>
</Window.Resources>

<Grid>
<GroupBox Margin="0" Header="Windows Properties">
   <GroupBox.HeaderTemplate>
      <DataTemplate>
         <StackPanel Orientation="Horizontal">
         <iconPacks:PackIconMaterial Kind="Application" />
            <TextBlock Margin="8,0,0,0" VerticalAlignment="Center"  Text="{Binding}"/>
         </StackPanel>
      </DataTemplate>
   </GroupBox.HeaderTemplate>
   <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Vertical">
      <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Horizontal">
         <StackPanel HorizontalAlignment="Center" Margin="0 0 30 0 " Orientation="Vertical">
            <GroupBox Height="315">
               <GroupBox.HeaderTemplate>
                  <DataTemplate>
                     <StackPanel Orientation="Horizontal">
                     <iconPacks:PackIconMaterial Kind="MoveResize" Margin="5 5 0 0" Width="24" Height="24" />
                        <TextBlock HorizontalAlignment="Center" Margin="5 10 0 0"  Text="Windows Size">
                        </TextBlock>
                     </StackPanel>
                  </DataTemplate>
               </GroupBox.HeaderTemplate>
               <StackPanel HorizontalAlignment="Left" VerticalAlignment="Center" Orientation="Vertical">
                  <StackPanel Orientation="Horizontal">
                     <Slider
                        Controls:SliderHelper.ChangeValueBy="LargeChange"
                        Controls:SliderHelper.EnableMouseWheel="MouseHover"
                        Name="M_Slider_H"
                        Height="200"
                        Margin="0 30 0 0 "
                        Maximum="1200"
                        Minimum="300"
                        Orientation="Vertical"
                        TickFrequency="200"
                        Value="600"/>
                     <Slider
                        Controls:SliderHelper.ChangeValueBy="LargeChange"
                        Controls:SliderHelper.EnableMouseWheel="MouseHover"
                        Name="M_Slider_W"
                        Width="200"
                        Margin="10 -220 0 0 "
                        Maximum="1200"
                        Minimum="300"
                        Orientation="Horizontal"
                        TickFrequency="200"
                        Value="600"/>
                     <StackPanel HorizontalAlignment="Left" Orientation="Vertical">
                        <TextBlock HorizontalAlignment="Center" Margin="-220 90 0 0" Text="{Binding ElementName=M_Slider_W, Path=Value, StringFormat=Width: {0:0}}" FontWeight="Bold" FontSize="14">
                        </TextBlock>
                        <TextBlock HorizontalAlignment="Center" Margin="-220 10 0 0" Text="{Binding ElementName=M_Slider_H, Path=Value, StringFormat=Height: {0:0}}" FontWeight="Bold" FontSize="14">
                        </TextBlock>
                     </StackPanel>
                  </StackPanel>
                  <StackPanel Orientation="Horizontal">
                  </StackPanel>
               </StackPanel>
            </GroupBox>
         </StackPanel>
         <StackPanel HorizontalAlignment="Center" VerticalAlignment="Top">
            <GroupBox Height="315">
               <GroupBox.HeaderTemplate>
                  <DataTemplate>
                     <StackPanel Orientation="Horizontal">
                     <iconPacks:PackIconMaterial Kind="FormatSize"  Margin="5 5 0 0" Width="24" Height="24" />
                        <TextBlock HorizontalAlignment="Center" Margin="5 10 0 0"  Text="Windows Title">
                        </TextBlock>
                     </StackPanel>
                  </DataTemplate>
               </GroupBox.HeaderTemplate>
               <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top" Orientation="Vertical">
                  <StackPanel Orientation="Horizontal">
                     <TextBlock HorizontalAlignment="Center" Margin="0 15 0 0"  Text="Title :" FontWeight="Bold" FontSize="14"/>
                     <TextBox Name="M_Title" Controls:TextBoxHelper.Watermark="Title" Controls:TextBoxHelper.ClearTextButton="True" Margin="10 12 0 15"  Width="100"/>
                  </StackPanel>
                  <StackPanel Orientation="Horizontal">
                     <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0"  Text="ResizeMode : " FontWeight="Bold" FontSize="14">
                     </TextBlock>
                     <StackPanel>
                        <StackPanel Orientation="Horizontal">
                           <ComboBox Name="M_CB_Resize" HorizontalAlignment="Left" Margin="0 8 0 15" >
                              <ComboBoxItem Name="NoResize" IsSelected="True">
                                NoResize
                              </ComboBoxItem>
                              <ComboBoxItem Name="CanMinimize">
                                CanMinimize
                              </ComboBoxItem>
                              <ComboBoxItem Name="CanResize">
                                CanResize
                              </ComboBoxItem>
                              <ComboBoxItem Name="CanResizeWithGrip">
                                CanResizeWithGrip
                              </ComboBoxItem>
                           </ComboBox>
                        </StackPanel>
                     </StackPanel>
                  </StackPanel>
                  <StackPanel Orientation="Horizontal">
                     <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0"  Text="WindowStartupLocation : " FontWeight="Bold" FontSize="14">
                     </TextBlock>
                     <StackPanel>
                        <StackPanel Orientation="Horizontal">
                           <ComboBox Name="M_CB_WindowsStartupLocation" HorizontalAlignment="Left" Margin="0 8 0 15">
                              <ComboBoxItem Name="Manual" IsSelected="True">
                                Manual
                              </ComboBoxItem>
                              <ComboBoxItem Name="CenterScreen">
                                CenterScreen
                              </ComboBoxItem>
                              <ComboBoxItem Name="CenterOwner">
                                CenterOwner
                              </ComboBoxItem>
                           </ComboBox>
                        </StackPanel>
                     </StackPanel>
                  </StackPanel>
                  <StackPanel Orientation="Horizontal">
                     <StackPanel Orientation="Horizontal" Margin="0 0 0 0">
                        <TextBlock HorizontalAlignment="Center" Margin="0 10 0 5" Text="Theme  : " FontWeight="Bold" FontSize="14">
                     </TextBlock>
                          <Controls:ToggleSwitch Margin=" 5 10 0 15" Name="M_Theme" OnLabel="Light" OffLabel="Dark" IsChecked="True" Style="{StaticResource MahApps.Metro.Styles.ToggleSwitch.Win10}" />
                      </StackPanel>
                     <StackPanel>   
                     </StackPanel>
                  </StackPanel>
                  <StackPanel Orientation="Horizontal">
                     <TextBlock HorizontalAlignment="Center" Margin="0 10 0 15"  Text="Accent : " FontWeight="Bold" FontSize="14">
                     </TextBlock>
                     <StackPanel>
                        <StackPanel Orientation="Horizontal">
                           <ComboBox Name="M_Accent" HorizontalAlignment="Left" Margin="0 8 0 8" SelectedIndex="9">
                           </ComboBox>
                        </StackPanel>
                     </StackPanel>
                  </StackPanel>
               </StackPanel>
            </GroupBox>
         </StackPanel>
      </StackPanel>
      <StackPanel HorizontalAlignment="Center" VerticalAlignment="Top">
            <GroupBox  Width="525" Margin="0 15 0 0">
               <GroupBox.HeaderTemplate>
                  <DataTemplate>
                     <StackPanel Orientation="Horizontal">
                     <iconPacks:PackIconMaterial Kind="Buffer" Margin="5 5 0 0" Width="24" Height="24"/>
                        <TextBlock HorizontalAlignment="Center" Margin="5 10 0 0"  Text="MahApps IconPacks">
                        </TextBlock>
                     </StackPanel>
                  </DataTemplate>
               </GroupBox.HeaderTemplate>
               <StackPanel  HorizontalAlignment="Left" VerticalAlignment="Top" Orientation="Vertical">
                  <StackPanel Orientation="Horizontal">
                     <TextBlock HorizontalAlignment="Center" Margin="0 15 0 0"  Text="Included IconPacks Mahapps : " FontWeight="Bold" FontSize="14"/>
                     <Controls:ToggleSwitch Margin=" 5 15 0 15" Name="IconPacks" OnLabel="Yes" OffLabel="No" IsChecked="False" Style="{StaticResource MahApps.Metro.Styles.ToggleSwitch.Win10}" />
                  </StackPanel>
                  <StackPanel Orientation="Horizontal">
                     <TextBlock HorizontalAlignment="Center" Margin="0 15 0 0"  Text="Enabled experimental option : " FontWeight="Bold" FontSize="14"/>
                     <CheckBox Name="E_Flyout" Margin="5 15 0 0"></CheckBox>
                  </StackPanel>
                  <StackPanel Name="SFlyout" Orientation="Horizontal" Visibility="Collapsed">
                     <TextBlock HorizontalAlignment="Center" Margin="0 15 0 0"  Text="Experimental dynamically theme Mahapps* : " FontWeight="Bold" FontSize="14"/>
                     <Controls:ToggleSwitch Margin=" 5 15 0 15" Name="Flyout" OnLabel="Yes" OffLabel="No" IsChecked="False" Style="{StaticResource MahApps.Metro.Styles.ToggleSwitch.Win10}" />
                  </StackPanel>
                  <StackPanel  Name="SFlyout1" Orientation="Horizontal" Visibility="Collapsed">
                     <TextBlock HorizontalAlignment="Center" Margin="0 -10 0 0"  Text="This feature will be available in a Flyout Controls" FontSize="10"/>
                  </StackPanel>
               </StackPanel>
            </GroupBox>
         </StackPanel>
      <Button Name="M_Save" Width="45" Height="45" Margin="-20 15 0 0" Style="{DynamicResource MahApps.Metro.Styles.MetroCircleButtonStyle}">
      <iconPacks:PackIconMaterial Kind="ContentSaveOutline" Width="20" Height="20"/>
</Button>
   </StackPanel>
</GroupBox>
</Grid>
</Controls:MetroWindow>
"@
$Child_MProperties = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xamlM1))

$Close = $Child_MProperties.findname("M_Save")
$Mode = $Child_MProperties.findname("M_Theme")
$Slider_W = $Child_MProperties.findname("M_Slider_W")
$Slider_H = $Child_MProperties.findname("M_Slider_H")
$Title = $Child_MProperties.findname("M_Title")
$NoResize = $Child_MProperties.findname("NoResize")
$CanMinimize = $Child_MProperties.findname("CanMinimize")
$CanResize = $Child_MProperties.findname("CanResize")
$CanResizeWithGrip = $Child_MProperties.findname("CanResizeWithGrip")
$Manual = $Child_MProperties.findname("Manual")
$CenterScreen = $Child_MProperties.findname("CenterScreen")
$CenterOwner = $Child_MProperties.findname("CenterOwner")
$MAccent = $Child_MProperties.findname("M_Accent")
$IconPacks = $Child_MProperties.findname("IconPacks")
$Flyout = $Child_MProperties.findname("Flyout")
$E_Flyout = $Child_MProperties.findname("E_Flyout")
$SFlyout = $Child_MProperties.findname("SFlyout")
$SFlyout1 = $Child_MProperties.findname("SFlyout1")

$Accent = [MahApps.Metro.ThemeManager]::Accents
$AccentColors = $($Accent.Name)


foreach ($item in $AccentColors)
{
    $MAccent.Items.Add($item)
}

$E_Flyout.Add_Click({

   if ($E_Flyout.IsChecked -eq $True)
   {
      $Global:E_Flyout = $True

      #Enable Controls
      $SFlyout.Visibility = "Visible"
      $SFlyout1.Visibility = "Visible"


   }
   elseif  ($E_Flyout.IsChecked -eq $False)
   {
      #Hide Controls
      $SFlyout.Visibility = "Collapsed"
      $SFlyout1.Visibility = "Collapsed"
      
      #Disable Option
      $Flyout.IsChecked -eq $False
      $Global:Flyout = $False

   }


})


$IconPacks.Add_Click({

   if ($IconPacks.IsChecked -eq $True)
   {
      $Global:IconPacks = $True
   }
   elseif  ($IconPacks.IsChecked -eq $False)
   {
      $Global:IconPacks = $False
   }

})

$Flyout.Add_Click({

   if ($Flyout.IsChecked -eq $True)
   {
      $Global:Flyout = $True
   }
   elseif  ($Flyout.IsChecked -eq $False)
   {
      $Global:Flyout = $False
   }


})

$Mode.add_Click({

	$Theme = [MahApps.Metro.ThemeManager]::DetectAppStyle($Child_MProperties)	
    If ($Mode.IsChecked -eq $true) 
		{
         [MahApps.Metro.ThemeManager]::ChangeAppStyle($Child_MProperties, $Theme.Item2, [MahApps.Metro.ThemeManager]::GetAppTheme("BaseLight"));		
         
         $Global:MTheme = "BaseLight"
		} 
	Else 
		{	
         [MahApps.Metro.ThemeManager]::ChangeAppStyle($Child_MProperties, $Theme.Item2, [MahApps.Metro.ThemeManager]::GetAppTheme("BaseDark"));		
         
         $Global:MTheme = "BaseDark"

		}
})

$MAccent.Add_SelectionChanged({

	$MTheme = [MahApps.Metro.ThemeManager]::DetectAppStyle($Child_MProperties)	
	
    $Value = $MAccent.SelectedValue

    [MahApps.Metro.ThemeManager]::ChangeAppStyle($Child_MProperties, [MahApps.Metro.ThemeManager]::GetAccent("$Value"), $MTheme.Item1);	

    $Global:My_accent = $MAccent.SelectedValue

})

$Close.add_Click({

 $Global:ProjectTitle = $Title.Text
 [INT]$Global:Width = $Slider_W.Value
 [INT]$Global:Height = $Slider_H.Value

 # Set Rezise Mode
 if ($NoResize.IsSelected -eq $true )
 {
  $Global:ReziseMode = "NoResize"
 } 
 if ($CanMinimize.IsSelected -eq $true )
 {
  $Global:ReziseMode = "CanMinimize"
 } 
 if ($CanResize.IsSelected -eq $true )
 {
  $Global:ReziseMode = "CanResize"
 } 
 if ($CanResizeWithGrip.IsSelected -eq $true )
 {
  $Global:ReziseMode = "CanResizeWithGrip"
 } 

 # Set WindowStartupLocation

 if ($Manual.IsSelected -eq $true )
 {
  $Global:WindowStartupLocation = "Manual"
 } 
 if ($CenterScreen.IsSelected -eq $true )
 {
  $Global:WindowStartupLocation = "CenterScreen"
 } 
 if ($CenterOwner.IsSelected -eq $true )
 {
  $Global:WindowStartupLocation = "CenterOwner"
 } 

 $Global:My_accent = $MAccent.SelectedValue

 $Child_MProperties.Close() 

 $WPF_M_Create_Project.IsEnabled = $true
})
 

$Child_MProperties.ShowDialog() 
#End WPF_Open_Windows_Properties.add_Click
})


$WPF_M_Create_Project.Add_Click({
 
   #$WPF_MainMenu.IsOpen = $true

  #Create The Project Folder
  New-Item -Name "Projects" -Path "$env:HOMEDRIVE\Users\$env:USERNAME\desktop" -ItemType Directory 
  New-Item -Name  "Assembly" -Path "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\" -ItemType Directory 

  switch ($Global:IconPacks) {
     $true 
     { 
        # Copy assembly wit IconPacks
      Copy-Item -Path "$ScriptDirectory\*.dll" -Exclude RadialMenu.dll,MaterialDesignColors.dll,MaterialDesignThemes.Wpf.dll -Destination "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\Assembly" 

      }
     $false 
     {   
        # Copy assembly without IconPacks
      Copy-Item -Path "$ScriptDirectory\*.dll" -Exclude RadialMenu.dll,MahApps.Metro.IconPacks.dll,MahApps.Metro.IconPacks.FontAwesome.dll,MahApps.Metro.IconPacks.Material.dll,MahApps.Metro.IconPacks.MaterialLight.dll,MahApps.Metro.IconPacks.Modern.dll,MaterialDesignColors.dll,MaterialDesignThemes.Wpf.dll -Destination "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\Assembly" 
     }
     Default {}
  }

switch ($Global:Flyout) {
   $true 
   {  
      # Create the Powershell Project
      $File_Pwsh = Get-Content "$ScriptDirectory\MBlankF.Ps1" -raw
      $File_Pwsh.replace("@ProjectName@", $Global:ProjectName).replace("@Autor@", $Global:Author)  | Out-File -FilePath "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\$Global:ProjectName.ps1"

      #Create XAML File
      $File_XAML =  "$ScriptDirectory\MMainF.xaml" 
      $XAML_file =  "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\Main.xaml"
      (Get-Content $File_XAML) | ForEach-Object {
            $_.replace("@Title@", $Global:ProjectTitle).replace("@Height@", $Global:Height).replace("@Width@", $Global:Width).replace("@WindowStratupLocation@", $Global:WindowStartupLocation).replace("@ReziseMode@", $Global:ReziseMode).replace("@theme@", $Global:MTheme).replace("@Primary@", $Global:My_Primary).replace("@accent@", $Global:My_accent)
         } | Set-Content $XAML_file	

         $WPF_M_Launch_Project.IsEnabled = $true


   }
   $false 
   {
      # Create the Powershell Project
      $File_Pwsh = Get-Content "$ScriptDirectory\MBlank.Ps1" -raw
      write-host  "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\$Global:ProjectName.ps1"
      $File_Pwsh.replace("@ProjectName@", $Global:ProjectName).replace("@Autor@", $Global:Author)  | Out-File -FilePath "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\$Global:ProjectName.ps1"

      #Create XAML File
      $File_XAML =  "$ScriptDirectory\MMain.xaml" 
      $XAML_file =  "$env:HOMEDRIVE\Users\$env:USERNAME\desktop\Projects\$Global:ProjectName\Main.xaml"
      (Get-Content $File_XAML) | ForEach-Object {
            $_.replace("@Title@", $Global:ProjectTitle).replace("@Height@", $Global:Height).replace("@Width@", $Global:Width).replace("@WindowStratupLocation@", $Global:WindowStartupLocation).replace("@ReziseMode@", $Global:ReziseMode).replace("@theme@", $Global:MTheme).replace("@Primary@", $Global:My_Primary).replace("@accent@", $Global:My_accent)
         } | Set-Content $XAML_file	

         $WPF_M_Launch_Project.IsEnabled = $true

   
   }
   Default {}
}

})
<#
# Make PowerShell Disappear
$windowcode = "[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);"
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)
 
# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()
#>

 
$Form.ShowDialog() 

