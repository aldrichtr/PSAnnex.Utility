
function Find-SearchPattern {
    <#
    .SYNOPSIS
        Find the given regex pattern in the given path
    .DESCRIPTION
        `Find-SearchPattern` will look for the given regular expression in the path provided.  It is intended to be
        used with the `grep` alias.
    .EXAMPLE
        Find-SearchPattern '^function' "*.ps1"
    #>
    [CmdletBinding()]
    param(
        # A regular expression to look for
        [Parameter(
            Position = 0,
            Mandatory
        )]
        [string]$Pattern,

        # The path to search in, the current directory is used if not specified
        [Parameter(
            Position = 1,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('PSPath')]
        [string]$Path,

        # A filter to apply to the path
        [Parameter(
        )]
        [string]$Filter,

        # Optionally recurse into children
        [Parameter(
        )]
        [switch]$Recurse
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"

    }
    process {
        if ($PSBoundParameters.Keys -notcontains 'Path') {
            $Path = Get-Location
        }
        Get-ChildItem $Path -Filter:$Filter -Recurse:$Recurse | Select-String -Pattern $Pattern
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
