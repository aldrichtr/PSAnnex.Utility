
function Resize-Text {
    <#
    .SYNOPSIS
        Wrap Text at the given Length
    .DESCRIPTION
        `Resize-Text` will re-format input text so that lines longer than 'Length' are "wrapped" to the next line.

        Text is split at the last ' ' (space character) prior to 'Length'.
    .EXAMPLE
        Resize-Text "This text is 45 characters long but i want 40" -Length 40

        This text is 45 characters long but i
        want 40
    .EXAMPLE
        Resize-Text "thistextwillnotwrap" -Length 10

        (throws an error)
    ,help-.EXAMPLE
        Resize-Text "thistextwillnotwrap" -Length 10 -Force

        thistextwi
        llnotwrap
    #>
    [CmdletBinding()]
    param(
        # The text to resize
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [AllowEmptyString()]
        [string[]]$Text,

        # The length to wrap lines on
        [Parameter(
            Mandatory
        )]
        [int]$Length,

        # Wrap at 'Length' even if it is not a ' ' character
        [Parameter(
        )]
        [switch]$Force
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        function getSplitIndex {
            <#
            .DESCRIPTION
                Start at "Length" and walk backwards until we find a ' ' character, then return that
                index number.
            #>
            param(
                [Parameter()][string]$Text,

                [Parameter()][int]$Length
            )
            $split_at_character = ' '
            Write-Debug "  Going to find the splitindex number in string '$Text' for $Length width"
            $keep_part = $Text.Substring(0, $Length)
            Write-Debug "  keeping '$keep_part'"

            $keep_part.LastIndexOf($split_at_character)
        }

        $remaining_text = ''
    }
    process {
        foreach ($line in $Text) {
            $original_line = $line
            if (-not([string]::IsNullOrEmpty($remaining_text))) {
                $line = -join ($remaining_text, ' ', $line)
                $remaining_text = ''
            }

            if ($line.Length -gt $Length) {
                <#
                    we want to split on the last space prior to the 'Length'
                    if there isnt one for some reason, then
                    split the line at the 'Length' if 'Force' is set.
                    otherwise, we throw an error.
                #>
                $last_space = getSplitIndex -Text $line -Length $Length

                if ($last_space -lt 0) {
                    if ($Force) {
                        $remaining_text = $line.Substring($Length, ($line.Length - $Length))
                        $line = $line.Substring(0, $Length)
                    } else {
                        throw "$line cannot be split at $Length.  Use '-Force' to split within a word"
                    }
                } else {
                    $remaining_text = $line.Substring($last_space, ($line.Length - $last_space))
                    $line = $line.Substring(0, $last_space)
                }
                Write-Debug "  - original line was '$original_line'"
                Write-Debug "  - new line is       '$line'"
                Write-Debug "  - remaining text is '$remaining_text'"
            }
            $line.Trim() | Write-Output
        }
        # if there is something left in remaining text, we need to print that out too
        # by recursively calling resize text until remaining text is empty
        if (-not([string]::IsNullOrEmpty($remaining_text))) {
            Resize-Text -Text $remaining_text -Length $Length -Force:$Force
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
