
function Get-WeekOfYear {
    <#
    .SYNOPSIS
        Return the Week Number of the given date
    #>
    [CmdletBinding()]
    param(
        # The date to use when finding the last day of the year
        [Parameter(
            ValueFromPipeline
        )]
        [datetime]$Date
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        if (-not($PSBoundParameters['Date'])) {
            $Date = Get-Date
            Write-Verbose "  No date given so using today ($Date)"
        }
    }
    end {
        Get-Date $Date -UFormat '%V'
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
