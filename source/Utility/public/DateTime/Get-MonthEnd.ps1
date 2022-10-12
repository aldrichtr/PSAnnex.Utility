
function Get-MonthEnd {
    [CmdletBinding()]
    param(
        # The date to use when finding the last day of the month
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
        $first_day = Get-MonthStart $Date
    }
    end {
        Get-Date ($first_day.AddMonths(1).AddSeconds(-1))
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
