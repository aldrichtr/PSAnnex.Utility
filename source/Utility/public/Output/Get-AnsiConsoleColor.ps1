function Get-AnsiConsoleColor {
    <#
    .SYNOPSIS
        Print out ANSI console escape sequence color
    .DESCRIPTION
        Prints a message in the given ANSI escape sequence if given
        or a chart of all available if no parameters are given
    #>
    [CmdletBinding()]
    param(
        # Decimal value ANSI color
        [Parameter(
            ValueFromPipeline
        )]
        [ValidateRange(0, 255)]
        [int]$Code
    )
    begin {
        $sample_text = "'$Code' ANSI escape would make the text look like this"
        $padding = 4
        $colors_per_row = 16
    }
    process {
        $esc = $([char]27)
        if ($PSBoundParameters['Code']) {
            Write-Output "$esc[38;5;${Code}m$sample_text$esc[0m"
            Write-Output "$esc[48;5;${Code}m$sample_text$esc[0m"
        } else {
            Write-Output "`n$esc[1;4m256-Color Foreground & Background Charts$esc[0m"
            foreach ($fgbg in 38, 48) {
                # foreground/background switch
                foreach ($color in 0..255) {
                    # color range
                    #Display the colors
                    $field = "$color".PadLeft($padding)  # pad the chart boxes with spaces
                    Write-Host -NoNewLine "$esc[$fgbg;5;${color}m$field $esc[0m"
                    #Display 6 colors per line
                    if ( (($color + 1) % $colors_per_row) -eq $padding ) { Write-Output "`n" }
                }
                Write-Output `n
            }
        }
    }
    end {}
}
