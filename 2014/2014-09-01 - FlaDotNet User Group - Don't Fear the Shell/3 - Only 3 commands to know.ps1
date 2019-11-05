<#
#######################
Only 3 commands to know
#######################
PowerShell is designed to be discoverable. 

There are dozens of Cmdlets built in, and hundreds more available as modules or scripts online.
You only need 3 commands to understand them all.

#>

# 1. GET-MEMBER
# We've looked at the Get-Member Cmdlet to examine the contents of any object
# Here's a string object
"Test" | Get-Member

# 2. GET-COMMAND
# How can we see all the Cmdlets available?
Get-Command

#That's too many, how can we narrow it down? 
#Let's use Get-Command with the -name parameter
Get-Command -name *variable
Get-Command -name *object
#Wildcards in parameters make Cmdlets very flexible
Get-Command Write-*

#notice we left out the -name, but it still worked. Why?
#Let's use our third command to learn more

# 3. GET-HELP
Get-Help Get-Command
# PowerShell help is updateable, can use Update-Help to refresh with the latest version

# A little hard to read, we could pipe to more as in cmd.exe
# more doesn't work in the ISE
Get-Help Get-Command | more

# Can't we pop out the help from the console?
Get-Help Get-Command 
# Discuss syntax, parameter sets, help options
Get-Help Get-Command -Examples | more
Get-Help Get-Command -Details | more
Get-Help Get-Command -Full | more
Get-Help Get-Command -Online


# Want a reference book on PowerShell? Pick a topic!
Get-Help about_*

# WITH THESE THREE COMMANDS YOU CAN DISCOVER AND UNLOCK ALL OF POWERSHELL
