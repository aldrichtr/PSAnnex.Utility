
function Invoke-ReduceSequence {
    <#
    .SYNOPSIS
        Implement the 'reduce' lambda function on the given sequence
    .DESCRIPTION
        `Invoke-ReduceSequence` invokes the well-known 'reduce' function on the sequence given
    .LINK
        Invoke-MapSequence
        Invoke-FilterSequence
    .EXAMPLE
        @(1,2,3,4,5,6) | Invoke-ReduceSequence { param($x, $y) $x + $y } # Add up the sum
        21
    #>

    [CmdletBinding()]
    param(
        # The expression to apply to each object in the sequence
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [scriptblock]$Expression,

        # The objects to apply the expression to
        [Parameter(
            ValueFromPipeline
        )]
        [object[]]$Sequence
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $accumulated = $null

    }
    process {
        foreach ($value in $Sequence) {
            $accumulated = &$Expression $accumulated $value
        }
    }
    end {
        Write-Debug "-- End $($MyInvocation.MyCommand.Name)"
        $accumulated
    }
}
