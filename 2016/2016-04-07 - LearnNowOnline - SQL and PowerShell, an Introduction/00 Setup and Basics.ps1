#PowerShell Environment
$PSVersionTable

#PowerShell variables
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
$y.Length
$y.Replace("A","Z")
#PowerShell handles variable expansions in strings very easily
#Notice the backtick ` escape character
$z = "`$x is $x and `$y is $y"
$z

#USING HELP
#Update-Help #Gets the latest help from the web
Get-Help
Get-Help Get-Member
Get-Help about_Variables -ShowWindow
Get-Help about*


#What commands are available?
Get-Command *sql*
#Aliases
Get-Command -CommandType Alias
Get-Alias -Definition Get-ChildItem

#Functions
Get-Command -CommandType Function
#Cmdlets
Get-Command -CommandType Cmdlet


#What Modules are available in PowerShell on my machine?
Get-Module -ListAvailable

#What Modules are available to download via NuGet?
$modules = Find-Module
$modules | Out-GridView
#let's look at publicly available modules 
#using Format-Table
$modules | Format-Table
#using a PIPE to Out-GridView
$modules | Out-GridView

#What .Net Types are avaiable in PowerShell?
$assemblies = [appdomain]::CurrentDomain.GetAssemblies()
$assemblies.Count

$assemblies | Select-Object ManifestModule | Sort-Object ManifestModule | Out-GridView


#I'm extending PowerShell ISE with VariableExplorer
#https://gallery.technet.microsoft.com/PowerShell-ISE-VariableExpl-fef9ff01
Import-Module VariableExplorer.psm1
#useful to inspect local variables