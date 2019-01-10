#========================================================================
#
# Tool Name	: Material Design Apps project WPF
# Author 	: Jérôme Bezet-Torres
# Date 		: 10/01/2019
# Website	: http://JM2K69.github.io/
# Twitter	: https://twitter.com/JM2K69
#
#========================================================================

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\ControlzEx.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.FontAwesome.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.Material.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.MaterialLight.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.Modern.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\RadialMenu.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignThemes.Wpf.dll') 			| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignColors.dll')       			| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MaterialDesignThemes.MahApps.dll')       			| out-null
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
 # Get-FormVariables

  $Global:My_accent = ""
  $Global:My_Primary = ""
  $Global:Theme = 'Dark'
  $Global:ReziseMode = ""
  $Global:ProjectName= "@#"

  # Close Main menu
$WPF_Close.Add_Click({
	break
})
$WPF_Drag_Drop.add_PreviewMouseLeftButtonDown({
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
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Steel.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Light.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Defaults.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Primary/MaterialDesignColor.Purple.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Accent/MaterialDesignColor.blue.xaml"/>
      </ResourceDictionary.MergedDictionaries>
   </ResourceDictionary>
</Window.Resources>
<Grid>
<GroupBox Margin="16" Header="Windows Properties" Style="{DynamicResource MaterialDesignCardGroupBox}">
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
                          <ToggleButton Margin=" 5 10 0 0" Name="Theme" Style="{StaticResource MaterialDesignSwitchToggleButton}" IsChecked="True" />
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
                           <ComboBox HorizontalAlignment="Left" Margin="0 8 0 8" materialDesign:ComboBoxAssist.ShowSelectedItem="{Binding ElementName=DisplaySelectedItemCheckBox, Path=IsChecked}">
                              <ComboBoxItem Name="P_Yellow" IsSelected="True">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\yellow.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="Yellow">Yellow
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Amber">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\amber.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#ffd54f">Amber
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Deeporange">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\deeporange.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#ffab91">Deeporange
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_LightBlue">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\lightblue.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#81d4fa">Lightblue
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Teal">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\teal.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="Teal">Teal
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Cyan">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\cyan.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#80deea">Cyan
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Pink">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\pink.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="pink">Pink
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Green">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\green.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="green">Green
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Deeppurple">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\deeppurple.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#673ab7">Deeppurple
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Indigo">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\indigo.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#5c6bc0">Indigo
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_LightGreen">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\lightgreen.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#8bc34a">LightGreen
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Blue">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\blue.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="blue">Blue
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Lime">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\lime.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#cddc39">Lime
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Red">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\red.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="red">Red
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Orange">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\orange.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="orange">orange
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Purple">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\purple.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="purple">purple
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Bluegrey">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\bluegrey.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#FFC3CDD0">Bluegrey
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Grey">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\grey.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#FFD7D5D5">Grey
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="P_Brown">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Primary\brown.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#FFB4710A">Brown
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                           </ComboBox>
                        </StackPanel>
                     </StackPanel>
                  </StackPanel>
                  <StackPanel Orientation="Horizontal">
                     <TextBlock HorizontalAlignment="Center" Margin="0 10 0 0" Style="{DynamicResource MaterialDesignTitleTextBlock}" Text="Accent : ">
                     </TextBlock>
                     <StackPanel>
                        <StackPanel Orientation="Horizontal">
                           <ComboBox HorizontalAlignment="Left" Margin="0 8 0 8" materialDesign:ComboBoxAssist.ShowSelectedItem="{Binding ElementName=DisplaySelectedItemCheckBox, Path=IsChecked}">
                              <ComboBoxItem Name="A_Yellow" IsSelected="True">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\yellow.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="Yellow">Yellow
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Amber">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\amber.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#ffc400">Amber
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Deeporange">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\deeporange.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#ff6e40">Deeporange
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Lightblue">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\lightblue.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#40c4ff">Lightblue
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Teal">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\teal.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#64ffda">Teal
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Cyan">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\cyan.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="cyan">Cyan
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Pink">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\pink.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="pink">Pink
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Green">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\green.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="green">Green
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Deeppurple">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\deeppurple.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#7c4dff">Deeppurple
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Indigo">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\indigo.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="indigo">Indigo
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_LightGreen">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\lightgreen.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="green">LightGreen
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Blue">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\blue.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="blue">Blue
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Lime">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\lime.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#c6ff00">Lime
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Red">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\red.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="red">Red
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Orange">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\orange.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="orange">Orange
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Purple">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\purple.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="purple">Purple
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                              <ComboBoxItem Name="A_Bluegrey">
                                 <StackPanel Orientation="Horizontal">
                                    <Image Source="$ScriptDirectory\Colors\Accent\bluegrey.png"/>
                                    <TextBlock Margin="10,0,0,0" Foreground="#FFC3CDD0">Bluegrey
                                    </TextBlock>
                                 </StackPanel>
                              </ComboBoxItem>
                           </ComboBox>
                        </StackPanel>
                     </StackPanel>
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
$Child_Properties = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))

$Close = $Child_Properties.findname("Save")
$Theme = $Child_Properties.findname("Theme")
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
#Accent Color MAterial Design
$A_amber  = $Child_Properties.findname("A_Amber") 
$A_blue = $Child_Properties.findname("A_Blue") 
$A_cyan = $Child_Properties.findname("A_Cyan") 
$A_deeporange  = $Child_Properties.findname("A_Deeporange") 
$A_deeppurple  = $Child_Properties.findname("A_Deeppurple") 
$A_green  = $Child_Properties.findname("A_Green") 
$A_indigo  = $Child_Properties.findname("A_Indigo") 
$A_lightblue  = $Child_Properties.findname("A_Lightblue") 
$A_lightgreen  = $Child_Properties.findname("A_Lightgreen") 
$A_lime  = $Child_Properties.findname("A_Lime") 
$A_orange  = $Child_Properties.findname("A_Orange") 
$A_pink  = $Child_Properties.findname("A_Pink") 
$A_purple  = $Child_Properties.findname("A_Purple") 
$A_red  = $Child_Properties.findname("A_Red") 
$A_teal  = $Child_Properties.findname("A_Teal") 
$A_yellow  = $Child_Properties.findname("A_Yellow") 
#Primary Color MAterial Design
$P_amber = $Child_Properties.findname("P_Amber") 
$P_blue = $Child_Properties.findname("P_Blue") 
$P_bluegrey = $Child_Properties.findname("P_Bluegrey") 
$P_brown = $Child_Properties.findname("P_Brown") 
$P_cyan = $Child_Properties.findname("P_Cyan") 
$P_deeporange = $Child_Properties.findname("P_Deeporange") 
$P_deeppurple = $Child_Properties.findname("P_Deeppurple") 
$P_green = $Child_Properties.findname("P_Green") 
$P_grey = $Child_Properties.findname("P_Grey") 
$P_indigo = $Child_Properties.findname("P_Indigo") 
$P_lightblue = $Child_Properties.findname("P_LightBlue") 
$P_lightgreen = $Child_Properties.findname("P_LightGreen") 
$P_lime = $Child_Properties.findname("P_Lime") 
$P_orange = $Child_Properties.findname("P_Orange") 
$P_pink = $Child_Properties.findname("P_Pink") 
$P_purple = $Child_Properties.findname("P_Purple") 
$P_red = $Child_Properties.findname("P_Red") 
$P_teal = $Child_Properties.findname("P_Teal") 
$P_yellow = $Child_Properties.findname("P_Yellow") 

$Theme.add_Click({

  if ($Theme.IsChecked -eq $true) 
  {
      $Global:Theme = 'Dark'
     
  }
  if ($Theme.IsChecked -eq $False) 
  {
      $Global:Theme = 'Light'
  }


})

$Close.add_Click({

  $Global:Title = $Title.Text
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


  if ($A_Amber.IsSelected -eq $true )
  {
   $Global:My_accent = "Amber"
  
  } 
  if ($A_blue.IsSelected -eq $true )
  {
   $Global:My_accent = "Blue"
  } 
  if ($A_cyan.IsSelected -eq $true )
  {
   $Global:My_accent = "Cyan"
  } 
  if ($A_deeporange.IsSelected -eq $true )
  {
   $Global:My_accent = "Deeporange"
  } 
  if ($A_deeppurple.IsSelected -eq $true )
  {
   $Global:My_accent = "Deeppurple"
  } 
  if ($A_yellow.IsSelected -eq $true )
  {
   $Global:My_accent = "yellow"
  } 
  if ($A_green.IsSelected -eq $true )
  {
   $Global:My_accent = "Green"
  } 
  if ($A_indigo.IsSelected -eq $true )
  {
   $Global:My_accent = "Indigo"
  } 
  if ($A_lightblue.IsSelected -eq $true )
  {
   $Global:My_accent = "Lightblue"
  } 
  if ($A_lightgreen.IsSelected -eq $true )
  {
   $Global:My_accent = "Lightgreen"
  } 
  if ($A_lime.IsSelected -eq $true )
  {
   $Global:My_accent = "Lime"
  } 
  if ($A_orange.IsSelected -eq $true )
  {
   $Global:My_accent = "Orange"
  } 
  if ($A_pink.IsSelected -eq $true )
  {
   $Global:My_accent = "Pink"
  } 
  if ($A_purple.IsSelected -eq $true )
  {
   $Global:My_accent = "Purple"
  } 
  if ($A_red.IsSelected -eq $true )
  {
   $Global:My_accent = "Red"
  } 
  if ($A_teal.IsSelected -eq $true )
  {
   $Global:My_accent = "Teal"
  } 

  if ($P_amber.IsSelected -eq $true )
  {
    $Global:My_Primary = "Amber"
  } 
  if ($P_blue.IsSelected -eq $true )
  {
   $Global:My_Primary = "Blue"
  } 
  if ($P_bluegrey.IsSelected -eq $true )
  {
   $Global:My_Primary = "Bluegrey"
  } 
  if ($P_brown.IsSelected -eq $true )
  {
   $Global:My_Primary = "Brown"
  } 
  if ($P_cyan.IsSelected -eq $true )
  {
   $Global:My_Primary = "Cyan"
  } 
  if ($P_deeporange.IsSelected -eq $true )
  {
   $Global:My_Primary = "Deeporange"
  } 
  if ($P_deeppurple.IsSelected -eq $true )
  {
   $Global:My_Primary = "Deeppurple"
  } 
  if ($P_green.IsSelected -eq $true )
  {
   $Global:My_Primary = "Green"
  } 
  if ($P_grey.IsSelected -eq $true )
  {
   $Global:My_Primary = "Grey"
  } 
  if ($P_indigo.IsSelected -eq $true )
  {
   $Global:My_Primary = "Indigo"
  } 
  if ($P_lightblue.IsSelected -eq $true )
  {
   $Global:My_Primary = "Lightblue"
  } 
  if ($P_lightgreen.IsSelected -eq $true )
  {
   $Global:My_Primary = "Lightgreen"
  } 
  if ($P_lime.IsSelected -eq $true )
  {
   $Global:My_Primary = "Lime"
  } 
  if ($P_orange.IsSelected -eq $true )
  {
   $Global:My_Primary = "Orange"
  } 
  if ($P_pink.IsSelected -eq $true )
  {
   $Global:My_Primary = "Pink"
  } 
  if ($P_purple.IsSelected -eq $true )
  {
   $Global:My_Primary = "Purple"
  } 
  if ($P_red.IsSelected -eq $true )
  {
   $Global:My_Primary = "Red"
  } 
  if ($P_teal.IsSelected -eq $true )
  {
   $Global:My_Primary = "Teal"
  } 
  if ($P_yellow.IsSelected -eq $true )
  {
   $Global:My_Primary = "Yellow"
  } 

  $Child_Properties.Close() | Out-Null

  $WPF_MainMenu.IsOpen = $true

  if ($Global:ProjectName -eq "@#") 
  {
   $WPF_Create_Project.IsEnabled = $False
  }
  else 
  {
   $WPF_Create_Project.IsEnabled = $true

  }

})
  
 
$Child_Properties.ShowDialog() 
#End WPF_Open_Windows_Properties.add_Click
})


$WPF_Open_Apps_Info.add_Click({

  $WPF_MainMenu.IsOpen = $false

  [XML]$xaml1=@"
 
<Window
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
Width="750"
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
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Steel.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Light.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Defaults.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Primary/MaterialDesignColor.Purple.xaml"/>
         <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Accent/MaterialDesignColor.blue.xaml"/>
      </ResourceDictionary.MergedDictionaries>
   </ResourceDictionary>
</Window.Resources>
   <Grid>
   <StackPanel Orientation="Vertical">
      <materialDesign:ColorZone
         Width="300"
         Height="450"
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
            <Image Width="Auto" Height="140" Source="$ScriptDirectory\Images\pwsh.jpg" />
            <StackPanel Grid.Row="1" Margin="8 24 8 0">
               <TextBlock FontWeight="Bold">@JM2K69
               </TextBlock>
               <TextBlock VerticalAlignment="Center" TextWrapping="Wrap"> 
         Microsoft Certified Trainer 6 Year / PowerShell / PowerCli / Deployment / MDT / XAML / Automation
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

  $Child_Apps.Close() | Out-Null
  $WPF_MainMenu.IsOpen = $true
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
           <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Steel.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Light.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.Defaults.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Primary/MaterialDesignColor.Purple.xaml"/>
           <ResourceDictionary Source="pack://application:,,,/MaterialDesignColors;component/Themes/Recommended/Accent/MaterialDesignColor.blue.xaml"/>
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
           <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Orientation="Horizontal">
             <StackPanel HorizontalAlignment="Center" Orientation="Vertical">
                 <GroupBox Height="205" Width="250">
                    <GroupBox.HeaderTemplate>
                       <DataTemplate>
                          <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" >
                             <materialDesign:PackIcon Width="34" Height="34" Margin="0 0 5 0" Kind="WindowRestore"/>
                             <TextBlock HorizontalAlignment="Center" Margin="5 10 0 0" Style="{StaticResource MaterialDesignSubheadingTextBlock}" Text="Project Settings">
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
    $Child_Project.Close() | Out-Null
    $WPF_MainMenu.IsOpen = $true

  })
  

  $Child_Project.ShowDialog()


})

$WPF_Create_Project.Add_Click({
  $WPF_MainMenu.IsOpen = $true

  #Create The Project Folder

  New-Item -Name  "Assembly" -Path "$ScriptDirectory\Projects\$Global:ProjectName\" -ItemType Directory 

  # Copy assembly
  Copy-Item -Path "$ScriptDirectory\Assembly\*.*" -Exclude RadialMenu.dll,MahApps.Metro.IconPacks.dll,MahApps.Metro.IconPacks.FontAwesome.dll,MahApps.Metro.IconPacks.Material.dll,MahApps.Metro.IconPacks.MaterialLight.dll,MahApps.Metro.IconPacks.Modern.dll -Destination "$ScriptDirectory\Projects\$Global:ProjectName\Assembly" 

  # Create the Powershell Project
  $File_Pwsh = Get-Content "$ScriptDirectory\Projects\Blank.Ps1" -raw
  $File_Pwsh.replace('@ProjectName@', $Global:ProjectName).replace('@Autor@', $Global:Author)  | Out-File -FilePath "$ScriptDirectory\Projects\$Global:ProjectName\$Global:ProjectName.ps1"

  #Create XAML File
  $File_XAML =  "$ScriptDirectory\Projects\Main.xaml" 
  $XAML_file =  "$ScriptDirectory\Projects\$Global:ProjectName\Main.xaml"
  (Get-Content $File_XAML) | ForEach-Object {
		$_.replace('@Title@', $Global:Title).replace('@Height@', $Global:Height).replace('@Width@', $Global:Width).replace('@WindowStratupLocation@', $Global:WindowStartupLocation).replace('@ReziseMode@', $Global:ReziseMode).replace('@theme@', $Global:Theme).replace('@Primary@', $Global:My_Primary).replace('@accent@', $Global:My_accent)
	 } | Set-Content $XAML_file	

    $WPF_Launch_Project.IsEnabled = $true

})

$WPF_Launch_Project.Add_Click({

   Set-Location $ScriptDirectory\Projects\$Global:ProjectName

   powershell -sta .\$Global:ProjectName.ps1

})

$Form.ShowDialog() | Out-Null

