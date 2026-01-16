<#
###############
Common Cmdlets
###############

Let's try out some useful Cmdlets, explore parameters, and start using the pipe to combine them.
#>

#Commands that start with Get
Get-Command Get-*

#GET-EVENTLOG
#Let's start with the EventLog
Get-Command *-EventLog 
Get-Help Get-EventLog -Examples

#The application log is large
Get-EventLog -LogName Application 
# Press Control-C to break. Too much data, let's limit the results
Get-EventLog -LogName Application -Newest 10
# What if I just want errors?
Get-EventLog -LogName Application -Newest 10 -EntryType Error
# What if I want errors and warnings? Can I get more than one type?
Get-Help Get-EventLog -Parameter entrytype
# Note that this parameter accepts String[], or an array of strings, simple in PowerShell
Get-EventLog -LogName Application -Newest 10 -EntryType Error,Warning

# I can store that in a variable
$events = Get-EventLog -LogName Application -Newest 10 -EntryType Error,Warning
$events
# What are the properties of an event?
$events | Get-Member

# What if I want to send that result to a csv? Is there a command for that?
Get-Command *CSV
Get-EventLog -LogName A+pplication -Newest 10 -EntryType Error,Warning  | 
    Export-Csv C:\MyScripts\appevents.csv

# If Excel is installed, I can use the file association to open that CSV
Invoke-Item C:\MyScripts\appevents.csv
#Alternately can open with notepad. 
notepad C:\MyScripts\appevents.csv

#GET-PROCESS
Get-Command *-Process
Get-Help Get-Process -Examples
Get-Process
# Just see a few columns, there's more to see
Get-Process | Get-Member
# See all the properties with Select-Object
Get-Process | Select-Object *
# Too many columns to see in a table, so they're listed.
#Is there a better way to output this data? 
Get-Command Out-*
#GRIDVIEW!
Get-Process | Select-Object * | Out-GridView

#How do I control processes?
#Let's start notepad
Start-Process notepad
#Is notepad running?
Get-Process -Name notepad
#Let's close notepad with PowerShell
Stop-Process notepad #doesn't work, needs a Process object
#What gives us a process object?
Get-Process | Get-Member
#Let's use these two commands together
#Save your work in notepad first!
Get-Process -Name notepad | Stop-Process
#Notepad is closed
Get-Process -Name notepad