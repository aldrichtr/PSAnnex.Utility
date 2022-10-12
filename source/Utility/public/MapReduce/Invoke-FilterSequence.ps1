
function Invoke-FilterSequence {
    <#
    .SYNOPSIS
        Filter objects from the sequence by returning only objects where the expression evaluates to true
    .DESCRIPTION
        `Invoke-FilterSequence` applies the Expression to each object and returns the object if the result is true
    .LINK
        Invoke-MapSequence
        Invoke-ReduceSequence
    .EXAMPLE
        Invoke-FilterSequence { param($x) $x % 2 -eq 0 } @(1,2,3,4,5,6)

        2
        4
        6
    .EXAMPLE
        @(1,2,3,4,5,6) | Invoke-FilterSequence { param($x) $x % 2 -eq 0 }

        2
        4
        6
    #>

    [CmdletBinding()]
    param(
        # The expression to apply to each object in sequence
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [scriptblock]$Expression,

        # The objects to apply the filter to
        [Parameter(
            ValueFromPipeline
        )]
        [object[]]$Sequence
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        $Sequence | Where-Object { &$Expression $_ -EQ $true } | Write-Output
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
