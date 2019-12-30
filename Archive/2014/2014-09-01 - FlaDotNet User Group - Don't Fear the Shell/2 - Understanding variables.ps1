<#
#######################
Understanding Variables
#######################
We are working the PowerShell console.
It's a command shell and scripting environment.

Let's look at how variables work, and the Get-Member Cmdlet to understand them

#>

# We have variables. How can we see what variables we have in our PowerShell session?
Get-Variable


# Let's define a few new variables
$message = "Hello Dave"
$date = Get-Date
$result = 10 * 10

# We didn't define a type for these variables. What types are they?
# Type $message.GetT [TAB] to use autocomplete

$message.GetType()
$date.GetType()
$result.GetType()

# PowerShell variables are dynamically typed. 
# Recognize the type? They're .Net objects! Everything is a .Net object in PowerShell
# .Net objects and all their capabilities are built in

# PowerShell can describe these objects with the Get-Member Cmdlet
# We will use a pipe '|' to send the variable to this cmdlet
$message | Get-Member
# In PowerShell, the pipe is key, as we'll soon see.

# let's use one of the methods on $message
$message.ToUpper()

# and $date
$date | Get-Member
$date = $date.AddDays(30)

#and $result
$result | Get-Member

# We can type our variables when we declare them
[string]$datestring = Get-Date

# but $datestring is a string, can't use AddDays method
$datestring.AddDays(30) # fails


######################################
# ADVANCED SECTION FOR .NET DEVELOPERS
######################################

# We can use .Net objects and their methods to convert this string to a date
# http://msdn.microsoft.com/en-us/library/System.DateTime_methods(v=vs.110).aspx
# Remove-Variable date2
$date2 = New-Object -TypeName System.DateTime
$date2 | Get-Member
# type [System.DateTime]:: then hit [TAB] to see the static methods available to us.
[System.DateTime]::TryParse($datestring,[ref] $date2)
$date2
$date2 | Get-Member

# OK, I know .Net, but how do I learn about all these Cmdlets?
