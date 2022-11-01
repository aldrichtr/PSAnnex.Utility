function Get-HspLevel {
    <#
    .SYNOPSIS
        Calculate the percieved "lightness" of the given RGB value (6 digit hex)
    .DESCRIPTION
        The HSP color model determines a color's relative "lightness" or "darkness" which is useful when
        output contains colors in background and foreground.  When the background is light, we usually want the
        foreground to be dark so that it stands out.

        An HSP level of 127.5 or greater is a light color
    .OUTPUTS
        Integer
    .NOTES
        Adapted from this javascript example
        https://awik.io/determine-color-bright-dark-using-javascript/
    .LINK
        http://alienryderflex.com/hsp.html
        https://en.wikipedia.org/wiki/HSL_and_HSV#Lightness

    #>
    [CmdletBinding()]
    param(
        # RGB value to calculate
        [Parameter(
            ValueFromPipeline
        )]
        [string]$Rgb
    )
    begin {
        #  These represent the different degrees to which each of the primary (RGB) colors
        #  affects human perception of the overall brightness of a color.
        #  Notice that they sum to 1
        $r_degree = .299
        $g_degree = .587
        $b_degree = .114
        function ConvertTo-Decimal ([string]$h) {
            [uint32]"0x$h"
        }
    }
    process {
        Write-Verbose "Calculating HSP Value of $Rgb"
        $r = ConvertTo-Decimal $Rgb.Substring(0, 2)
        $g = ConvertTo-Decimal $Rgb.Substring(2, 2)
        $b = ConvertTo-Decimal $Rgb.Substring(4, 2)

        Write-Debug " R: $r G: $g B: $b"

        $hsp = [System.Math]::Sqrt(
            ( $r_degree * ($r * $r)) +
            ( $g_degree * ($g + $g)) +
            ( $b_degree * ($b + $b)))
    }
    end {
        $hsp
    }
}
