#PowerShell Environment
$PSVersionTable

#PowerShell variables
$x = 1
$y = 'ABC'

#variables are objects, we can PIPE them to Get-Member to learn about them.
$x | Get-Member
$y | Get-Member
$y.Length
#They are .net classes! We can use the available methods and properties of a .Net class
$x.ToString() | Get-Member
$y.Length
$y.Replace("A","Z")

#USING HELP
Get-Help
Get-Help Get-Member
Get-Help about_Variables -ShowWindow
Get-Help about*


#What commands are available?
Get-Command
#Aliases
Get-Command -CommandType Alias
Get-Alias -Definition Get-ChildItem

#Functions
Get-Command -CommandType Function
#Cmdlets
Get-Command -CommandType Cmdlet


#What Modules are available in PowerShell?
Get-Module -ListAvailable


#What .Net Types are avaiable in PowerShell?
$assemblies = [appdomain]::CurrentDomain.GetAssemblies()
$assemblies.Count

$assemblies | Select-Object ManifestModule | Sort-Object ManifestModule | Out-GridView


#I'm extending PowerShell ISE with VariableExplorer
Import-Module VariableExplorer.psm1