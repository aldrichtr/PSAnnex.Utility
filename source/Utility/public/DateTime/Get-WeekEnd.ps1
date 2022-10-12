
function Get-WeekEnd {
    <#
    .SYNOPSIS
        Return the date of the given date's last day of week according to the regional settings
    #>
    [CmdletBinding()]
    param(
        # The date in the week to calculate the start from
        [Parameter(
            ValueFromPipeline
        )]
        [System.DateTime]$Date
    )

    <#
        the first day's value is known, so if we find the first day and then add 6 days to it, we get the end of
        the week.  Not the most elegant, but should work in all cases
    #>
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $now = Get-Date
    }
    process {
        if (-not($PSBoundParameters['Date'])) {
            $Date = $now
            Write-Verbose "  No date given, so using today ($Date)"
        }
        $first_day = Get-WeekStart $Date
    }
    end {
        Get-Date $first_day.AddDays(6) -Hour 23 -Minute 59 -Second 59
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
