<#
##############
Getting set up
##############

Pin both PowerShell Console and PowerShell ISE to taskbar
PowerShell Console
(In Win 7 click start button, 
    in the search field type PowerShell, 
    right click the icon and choose pin to taskbar)
(In Win 8 from Start screen type PowerShell, 
    right click the icon and choose pin to taskbar)

PowerShell ISE (not x86, let's use 64 bit)
(In Win 7 click start button, 
    in the search field type ISE, 
    right click the icon and choose pin to taskbar)
(In Win 8 from Start screen type PowerShell_ISE, 
    right click the icon and choose pin to taskbar)

#>

# Open PowerShell Console
# What version of PowerShell is installed?
# variables start with $
$PSVersionTable
# will look at more built in variables later on

# If $PSVersion is 2.0, you need to install Windows Management Framework 3 (aka WMF 3)
# The download is here:
# http://www.microsoft.com/en-us/download/details.aspx?id=34595

# Set your font size to a more readable size
# Click upper left corner, Properties, Fonts, and choose a larger font size

# Create and use C:\MyScripts
mkdir C:\MyScripts
cd C:\MyScripts
# Wait a minute let's do that in PowerShell!
# Type Get-A , then press TAB to autocomplete! i.e. Get-A [TAB]
Get-Alias cd
# Keep using autocomplete to save time and typos
# it's an alias for a command Set-Location
Get-Alias mkdir
# no alias, we're using the cmd.exe command. 
# Our old cmd.exe commands are all available

Set-Location C:\
Get-Alias rmdir
# The rmdir is an alias for the Remove-Item Cmdlet
Remove-Item -Path C:\MyScripts
# We create folders with New-Item
New-Item -type directory -Path c:\MyScripts
# Note the syntax for parameters, command -parameter1 param1value
Set-Location C:\MyScripts
# When we leave out the -parameter, we're passing parameters positionally, more on this later.

# We can see all the aliases in PowerShell, and create our own
Get-Alias
# Cmdlet comparison with Cmd shell and *nix shell
# http://en.wikipedia.org/wiki/Powershell#Comparison_of_cmdlets_with_similar_commands


# Create a transcript, so you can review these commands later
# Can't do in the ISE, only from PowerShell command prompt
Start-Transcript C:\MyScripts\transcript0.txt

# Note the commands we're using are called Cmdlets
# They are always in the form Verb-Noun, i.e. Get-Thing, Set-Thing
# Set up help documentation, requires internet, may take a while :)
Update-Help