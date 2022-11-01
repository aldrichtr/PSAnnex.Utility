
Function Show-ProcessUsing {
    <#
    .SYNOPSIS
        Show the top $Count processes and the CPU used
    #>
    [CmdletBinding()]
    param(
        # How many processes to list, 10 by default
        [Parameter()]
        [int]$Count = 10
    )
    Get-Counter -ErrorAction SilentlyContinue '\Process(*)\% Processor Time' |
        Select-Object -ExpandProperty countersamples |
            Select-Object -Property instancename, cookedvalue |
                Where-Object { $_.instanceName -notmatch '^(idle|_total|system)$' } |
                    Sort-Object -Property cookedvalue -Descending |
                        Select-Object -First $Count |
                            Format-Table InstanceName, @{L = 'CPU'; E = { ($_.Cookedvalue / 100 / $env:NUMBER_OF_PROCESSORS).toString('P') } } -AutoSize
}
