
function Get-MonthStart {
    [CmdletBinding()]
    param(
        # The date to use when finding the first day of the month
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
        Get-Date $Date -Day 1 -Hour 0 -Minute 0 -Second 0
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
