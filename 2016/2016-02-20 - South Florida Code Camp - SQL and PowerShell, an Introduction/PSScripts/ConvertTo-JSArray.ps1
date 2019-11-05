Function ConvertTo-JSArray 
{
    <#
    .SYNOPSIS
    Convert an array of PSObjects to a javascript array.
    .DESCRIPTION
    Convert an array of PSObjects to a javascript array. Only NoteProperty values will be included in the results.
    .PARAMETER InputObject
    An array of psobjects to convert.
    .PARAMETER IncludeHeader
    This will add the NoteProperty Name as the topmost element of the array.
    .EXAMPLE
    DriveInfo | ConvertTo-JSArray -IncludeHeader
    .NOTES
        Version    : 1.0.0 12/16/2013
                     - First release
        Author     : Zachary Loeber
    .LINK
        http://www.the-little-things.net/
    .LINK
        http://nl.linkedin.com/in/zloeber
    #> 
    [cmdletbinding()]
    PARAM
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [PSObject]
        $InputObject,
        
        [switch]
        $IncludeHeader
    )

    BEGIN
    {
        #init array to dump all objects into
        $AllObjects = @()
        $jsarray = ''
        $header = ''
    }
    PROCESS
    {
        #if we're taking from pipeline and get more than one object, this will build up an array
        $AllObjects += $InputObject
    }
    END
    {
        $objcount = 0
        ForEach ($obj in $AllObjects) 
        {
            $properties = @($obj.psobject.properties | Where {$_.MemberType -eq 'NoteProperty'})
            if ($properties.Count -gt 0)
            {
                $propcount = 1
                $arrayelement = ''
                $objcount++
                ForEach($property in $properties)
                {
                    switch ($property.TypeNameOfValue)
                    {
                        'System.String' {
                            # escape the escape characters
                            $strval = ($property.Value).replace('\','\\')
                            #handle null
                            if ($property.Value -eq "null")
                            {
                                $arrayval = "$($strval)"  
                            }
                            else
                            {
                                $arrayval = "'$($strval)'"                                
                            }

                        }
                        default {
                            $arrayval = $property.Value
                        }
                    }
                    # if this is not the last property then add a comma
                    if ($properties.count -ne $propcount)
                    {
                        $arrayval = "$arrayval,"
                    }
                    $arrayelement = $arrayelement+$arrayval
                    $propcount++
                }
                $arrayelement = "[$arrayelement]"
                # if this is not the last property then add a comma
                if ($AllObjects.count -ne $objcount)
                {
                    $arrayelement = "$arrayelement,"
                }
                $jsarray = $jsarray + $arrayelement
            }
        }
        if ($IncludeHeader)
        {
            $headerpropcount = 0
            $headerprops = @(($AllObjects[0]).psobject.properties | Where {$_.MemberType -eq 'NoteProperty'} | %{$_.Name})
            Foreach ($headerprop in $headerprops)
            {
                $headerpropcount++
                $header = $header + "'$headerprop'"
                # if this is will be followed by array elements then add a comma
                if (($headerpropcount -ne $headerprops.count))
                {
                    $header = "$header,"
                }
            }
            if ($jsarray -eq '')
            {
                $header = "[$header]"
            }
            else
            {
                $header = "[$header],"
            }
        }
        return "[$($header)$($jsarray)]"
    }
}