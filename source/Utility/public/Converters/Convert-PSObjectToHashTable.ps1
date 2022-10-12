function Convert-PSObjectToHashTable {
    <#
    .SYNOPSIS
        Converts a PSObject to a hash table.
    .DESCRIPTION
        Converts a System.Management.Automation.PSObject to a System.Collections.Hashtable.
#>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline
        )][ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSObject]$InputObject
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $hashTable = @{}
    }
    process {
        $InputObject.PSObject.Properties | ForEach-Object {
            $hashTable.Add($_.Name, $_.Value)
        }
        $hashTable | Write-Output

    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
