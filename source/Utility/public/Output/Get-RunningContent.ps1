
function Get-RunningContent {
    <#
    .SYNOPSIS
        Get the contents of the given file and wait for additional lines
    .DESCRIPTION
        A specialization of the `Get-Content` function to use with the alias 'tail'
    .EXAMPLE
        tail .\output.log
    #>
    [CmdletBinding()]
    param(
        # Path to the file to get content from
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('PSPath')]
        [string[]]$Path,

        # Specifies the number of lines from the end of a file or other item. You can use the Tail parameter name or
        # its alias, Last
        [Parameter(
        )]
        [Alias('Last')]
        [int32]$Tail = 100
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        Get-Content -Path $Path -Tail $Tail -Wait
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
