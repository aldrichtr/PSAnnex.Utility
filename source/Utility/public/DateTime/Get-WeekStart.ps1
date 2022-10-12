
function Get-WeekStart {
    <#
    .SYNOPSIS
        Return the date of the given date's first day of week according to the regional settings
    #>
    [CmdletBinding()]
    param(
        # The date in the week to calculate the start from
        [Parameter(
            ValueFromPipeline
        )]
        [System.DateTime]$Date
    )

    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $FirstDaySetting = Get-Culture |
            Select-Object -ExpandProperty DateTimeFormat | Select-Object -ExpandProperty FirstDayOfWeek
        $now = Get-Date
    }
    process {
        if (-not($PSBoundParameters['Date'])) {
            $Date = $now
            Write-Verbose "  No date given, so using today ($Date)"
        }
    }
    end {
        Get-Date $Date.AddDays(
            $FirstDaySetting.value__ - $Date.DayOfWeek.value__
        )
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
