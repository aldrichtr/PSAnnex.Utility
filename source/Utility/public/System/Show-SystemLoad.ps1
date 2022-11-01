
function Show-SystemLoad {
    <#
    .SYNOPSIS
        Pretty-print Mem and CPU load
    #>
    [CmdletBinding()]
    param()
    Write-Host -ForegroundColor DarkGreen 'System Load:'
    'Memory: %{0:N}' -f (Get-Counter '\Memory\% committed bytes in use').CounterSamples.CookedValue
    Foreach ($cpu in  (Get-Counter '\Processor(*)\% Processor Time').CounterSamples) {
        'CPU {0:N}:  %{1:N}' -f $cpu.InstanceName, $cpu.CookedValue
    }
}
