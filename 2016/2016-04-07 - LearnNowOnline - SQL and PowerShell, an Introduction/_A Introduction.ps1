<#
.SYNOPSIS
   Presentation on PowerShell and SQL LearnNowOnline by David Cobb
.DESCRIPTION
   By adding PowerShell to our toolset when working with data, DBAs and developers can go 
   beyond Management Studio and T-SQL, applying a powerful scripting language that 
   leverages .Net objects and Windows server capabilities, enabling us to simplify 
   management of servers and databases, automate recurring processes, and access 
   and manipulate data. We'll discuss PowerShell basics and concepts useful 
   for DBAs and Developers, as well as PowerShell community resources that can help you 
   take your work with data to the next level.

.GOALS & OUTLINE
    Inspire you to start or continue your journey learning PowerShell, and provide guidance and resources
    A quick and gentle introduction to PowerShell for SQL pros
    Introduction to using PowerShell with SQL
    Demonstrate useful examples
    Point out useful tools and learning resources
    Questions and Next Steps

.SPEAKER
   David Cobb

.WEBSITE
   daveslog.com

.EMAIL
   david@davidcobb.net

.MAIN TECHNOLOGIES
   SQL
   PowerShell
   .Net

.ROLES
   SQL Consultant/Trainer/Developer
   System Architect at CheckAlt.com

.FUNCTIONALITY
   Learn and apply technology

#>
function Present-PowerShellAndSQL
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter]
        [Alias("p1")] 
        $Param1
      
    )

    Begin
    {
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            Clear-Host
            Write-Host -ForegroundColor Yellow -Object "Hello! `nWelcome to SQL and PowerShell,`npresented for LearnNowOnline by David Cobb"
        }
    }
    End
    {
    }
}

#Test Cmdlet
Present-PowerShellAndSQL