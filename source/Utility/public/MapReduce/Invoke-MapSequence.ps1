
function Invoke-MapSequence {
    <#
    .SYNOPSIS
        Implement the 'map' function on the given sequence
    .DESCRIPTION
        `Invoke-MapSequence` is an implementation of the well-known 'map' function.  It applies the given
        Expression to each Object in Sequence
    .LINK
        Invoke-ReduceSequence
    .EXAMPLE
        Invoke-MapSequence { param($x) $x + 2 } @(1,2,3)

        3
        4
        5
    .EXAMPLE
        @(1,2,3) | Invoke-MapSequence { param($x) $x + 10 }

        11
        12
        13
    #>
    [CmdletBinding()]
    param(
        # The lambda expression to apply to each object in the sequence
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [Scriptblock]$Expression,

        # The objects to perform the lambda expression on
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [Object[]]$Sequence
    )

    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"

    }
    process {
        $Sequence | ForEach-Object { &$Expression $_ }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
