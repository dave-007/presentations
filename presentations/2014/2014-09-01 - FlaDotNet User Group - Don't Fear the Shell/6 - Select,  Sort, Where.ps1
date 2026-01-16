<#
###############
Select-Object, Sort-Object, Where Object
###############

Let's use these Cmdlets to get the data we want.
#>

#In PowerShell, everything's an object, what commands work with objects?
Get-Command *-Object
#alternatively
Get-Command -Noun Object

#Let's use data from the Application Eventlog to try out some of these Cmdlets
Get-Command *-EventLog 
Get-Help Get-EventLog -Examples

# The application log is large, let's store in a variable
$appEvents = Get-EventLog -LogName Application 
# How many events?
$appEvents.Count
# Let's use Select-Object to work with a subset of these events.

#SELECT-OBJECT
Get-Help Select-Object 
# What are the properties of an event?
$appEvents | Select-Object -First 1 | Get-Member
# How can I see the newest events first? 
# SORT-OBJECT
Get-Help Sort-Object
$appEvents | Sort-Object -Property TimeWritten | Select-Object -First 10

# What if I just want errors?
# WHERE-OBJECT
Get-Help Where-Object
$appEvents | Where-Object -Property EntryType -EQ Error | Select-Object -First 10
