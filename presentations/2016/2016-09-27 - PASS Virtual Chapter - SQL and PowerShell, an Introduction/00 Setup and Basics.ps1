#PowerShell Environment
$PSVersionTable

<#
    I'm using PowerShell version 5, but most of what we cover works in PowerShell 2 and later
    Check Mike F Robbin's blog to see what PS versions are available 
    on what OS version and how to upgrade your PowerShell version
    http://mikefrobbins.com/2015/01/08/how-to-check-the-powershell-version-and-install-a-new-version/
#>
#I'm using PowerShell ISE for these demos, great tool to work with your scripts
#PROTIP: Don't use F5, it runs the WHOLE script!
#INSTEAD, put cursor on the line or select multiple lines and press F8

#PowerShell variables start with a $
$x = 1
$x
$y = 'ABC'
$y

#variables are objects, we can PIPE them to Get-Member to learn about them.
$x | Get-Member
$y | Get-Member
$y.Length
#They are .net classes! We can use the available methods and properties of a .Net class
$x.ToString() | Get-Member
$y.Replace("A","Z")
#PowerShell handles variable expansions in strings very easily
#Notice the backtick ` escape character
$z = "`$x is $x and `$y is $y"
$z
[string] $w = 'foo'
$w = 1
#USING HELP
#Update-Help #Gets the latest help from the web
#you might guess this command will get help
Get-Help
#show it in a window!
Get-Help -ShowWindow
#PROTIP: put cursor on a cmdlet and press F1 to get this window functionality also!
Get-Help Get-Member
#help on powershell topics like variables
Get-Help about_Variables -ShowWindow

#other topics available
Get-Help about*
#help on the Get-Command cmdlet, examples
Get-Help Get-Command -Examples
#or full help online to get latest help on technet site
Get-Help Get-Command -Online

#What commands are available that contain sql?
Get-Command *sql*
#same command with named parameter
Get-Command -Name *sql*
#Aliases
Get-Command -CommandType Alias
#I don't like remembering parameters, give me a GUI :)
Show-Command Get-Command
Get-Alias -Definition Get-ChildItem

#PowerShell modules give us additional cmdlets for working with various technologies 
#What cmdlets deal with modules?
Get-Command -Noun Module
#What Modules are available in PowerShell on my machine?
Get-Module -ListAvailable

#What Modules are available to download via PowerShellGet? 
#(added in PowerShell v5, but supported in v3)
#...takes some time to get all available modules...
#storing the result in a variable to reuse later
$modules = Find-Module
#let's look at publicly available modules 
#using Format-Table
$modules | Format-Table
#using a PIPE to Out-GridView
$modules | Out-GridView


#What .Net Types are available in PowerShell?
$assemblies = [appdomain]::CurrentDomain.GetAssemblies()
$assemblies.Count

$assemblies | Select-Object ManifestModule | Sort-Object ManifestModule | Out-GridView


#I'm extending PowerShell ISE with VariableExplorer
#https://gallery.technet.microsoft.com/PowerShell-ISE-VariableExpl-fef9ff01
Import-Module VariableExplorer.psm1
#useful to inspect local variables