
function Get-YearEnd {
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
        $first_day = Get-MonthStart $Date
    }
    end {
        Get-Date $Date -Month 12 -Day 31 -Hour 23 -Minute 59 -Second 59
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
