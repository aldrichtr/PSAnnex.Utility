
function Invoke-ReplaceToken {
    <#
    .SYNOPSIS
        Replace the given token with the value specified in the file.
    .DESCRIPTION
        Replace-Token replaces every occurance of Token with Value in the file given in Path.
    .EXAMPLE
        PS > Get-Content file.txt
        [TOKEN] World

        PS > file.txt | '\[TOKEN\]' 'hello'
        hello World


    #>
    [CmdletBinding(
    )]
    param(
        # File(s) to replace tokens in
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [Alias('PSPath')]
        [string[]]$Path,

        # The token to replace, written as a regular-expression
        [Parameter(
            Position = 0,
            Mandatory
        )]
        [string]$Token,

        # The value to replace the token with
        [Parameter(
            Position = 1,
            Mandatory
        )]
        [string]$Value
    )
    begin {
    }
    process {
        foreach ($file in $Path) {
            Write-Verbose "Processing tokens in $file"
            try {
                foreach ($line in (Get-Content $file)) {
                    $line -replace $token, $tokenValue | Write-Output
                }
            } catch {
                $PSCmdlet.ThrowTerminatingError($_)
            }
        }
    }
    end {
    }
}
