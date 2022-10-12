
function Add-TextBorder {
    <#
    .SYNOPSIS
        Surround the given text in a border
    .DESCRIPTION
        `Add-TextBorder` takes text as input and draws a "text border" around it as output.  Without any Parameters
        (other than the text), `Add-TextBorder` will draw a box of '*' characters around the text as wide as it
        to surround the longest line of text given.

        If a 'Width' is given, the Text will be "wrapped" to conform to the box drawn at the given 'Width'.

        The 'Foreground' and 'Background' parameters accept a $PSStyle color name (you can use tab-completion to see
        the options)
    .EXAMPLE
        Get-QuoteOfTheDay | Add-TextBorder -Width 60 -Character =

        ============================================================
        = Knowledge is knowing a tomato is a fruit. Wisdom is      =
        = knowing not to put it in a fruit salad                   =
        ============================================================
    .LINK
        Resize-Text
    .LINK
        <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_ansi_terminals?view=powershell-7.2>
    #>
    [OutputType([System.String])]
    [CmdletBinding()]
    param(
        # The string of text to process
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline
        )]
        [AllowEmptyString()]
        [string[]]$Text,

        # The character to use for the border. It must be a single character.
        [Parameter()]
        [ValidateLength(1, 1)]
        [string]$Character = '*',

        # The foreground color of the border
        [Parameter(
        )]
        [Alias('bfg')]
        [string]$Foreground,

        # The background color of the border
        [Parameter(
        )]
        [Alias('bbg')]
        [string]$Background,

        # The width of the border
        [Parameter(
        )]
        [int]$Width,

        # The number of spaces between the border and the text
        # When setting Padding, use 'Pad' to set a uniform distance on all four sides
        # if used in conjunction with 'PadTop', 'PadBottom', 'PadLeft' or 'PadRight',
        # 'Pad' will be set first, and the individual sides will be adjusted if specified
        # for example:
        # `-Pad 1 -PadLeft 2` will set Top, Bottom and Right to '1 space', while Left will be '2 space'
        [Parameter(
        )]
        [int]$Pad = 0,

        # the number of spaces between the border and the top of the text
        [Parameter(
        )]
        [int]$PadTop = 0,

        # the number of spaces between the border and the bottom of the text
        [Parameter(
        )]
        [int]$PadBottom = 0,
        # the number of spaces between the border and left of the text
        [Parameter(
        )]
        [int]$PadLeft = 0,

        # the number of spaces between the border and right of the text
        [Parameter(
        )]
        [int]$PadRight = 0
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"

        function writeBorderLine {
            param(
                [Parameter()][string]$Character = '*',

                [Parameter()][string]$Foreground,

                [Parameter()][string]$Background,

                [Parameter()][int]$Width
            )
            $formatted_border = [System.Text.StringBuilder]::new()

            if ($PSBoundParameters.ContainsKey('Foreground')) {
                $formatted_border.Append(($PSStyle.Foreground).$Foreground) | Out-Null
            }
            if ($PSBoundParameters.ContainsKey('Background')) {
                $formatted_border.Append(($PSStyle.Background).$Background) | Out-Null
            }
            $formatted_border.Append(
                $Character * $Width
            ).Append(
                $PSStyle.Reset
            ) | Out-Null

            $formatted_border.ToString()
        }

        function writeContentLine {
            [CmdletBinding()]
            param(
                [Parameter(ValueFromPipeline)][AllowEmptyString()][string]$Text,

                [Parameter()][string]$Character = '*',

                [Parameter()][string]$Foreground,

                [Parameter()][string]$Background,

                [Parameter()][int]$Width,

                [Parameter()][int]$PadTop = 0,

                [Parameter()][int]$PadBottom = 0,

                [Parameter()][int]$PadLeft = 0,

                [Parameter()][int]$PadRight = 0
            )

            <#
            To properly format the Border, we need to account for the width of the border
            (Character) on both sides and the "Side" Padding
            #>
            $outline_width = ($Character.Length + $PadLeft + $PadRight + $Character.Length)
            <#
            Now that we know how much space is _inside_ the box, we can calculate how many
            spaces we need to append to the end of the Text to keep the right side strait
            #>
            $spaces = (($Width - $outline_width) - $Text.Length)

            $formatted_border = [System.Text.StringBuilder]::new()
            $out = [System.Text.StringBuilder]::new()

            if ($PSBoundParameters.ContainsKey('Foreground')) {
                $formatted_border.Append(($PSStyle.Foreground).$Foreground) | Out-Null
            }
            if ($PSBoundParameters.ContainsKey('Background')) {
                $formatted_border.Append(($PSStyle.Background).$Background) | Out-Null
            }
            $formatted_border.Append(
                $Character
            ).Append(
                $PSStyle.Reset
            ) | Out-Null

            $out.Append(
                $formatted_border.ToString()
            ).Append(
                ' ' * $PadLeft
            ).Append(
                $Text
            ).Append(
                ' ' * $spaces
            ).Append(
                ' ' * $PadRight
            ).Append(
                $formatted_border.ToString()
            ) | Out-Null
            $out.ToString()
        }


        <#------------------------------------------------------------------
        We can't know what the text will look like yet, which makes it
        hard to know how wide to make the first line (unless it was given)
        to us in the parameter?
        ------------------------------------------------------------------#>
        $outline_width = ($Character.Length + $PadLeft + $PadRight + $Character.Length)
        $widest_line = 0
        $content = @()

        if ($PSBoundParameters.ContainsKey('Pad')) {
            $PadTop = ($PSBoundParameters.ContainsKey('PadTop')) ? $PadTop : $Pad
            $PadBottom = ($PSBoundParameters.ContainsKey('PadBottom')) ? $PadBottom : $Pad
            $PadRight = ($PSBoundParameters.ContainsKey('PadRight')) ? $PadRight : $Pad
            $PadLeft = ($PSBoundParameters.ContainsKey('PadLeft')) ? $PadLeft : $Pad
        }
    }

    process {
        <#------------------------------------------------------------------
          1. Collect all of the given text line by line and make some
             measurements.
        ------------------------------------------------------------------#>
        foreach ($line in $Text) {
            Write-Debug "  this line is `n$line`n  Length $($line.Length)"
            if ($line.Length -gt $widest_line) {
                $widest_line = $line.Length
                $content += $line
            }
        }
    }
    end {
        Write-Debug "  widest line was $widest_line"
        if ($PSBoundParameters.ContainsKey('Width')) {
            Write-Debug "  Width was set to $Width formatting text"
            <#------------------------------------------------------------------
              if the text is wider than the
              (width - (the left borderchar + left pad + right borderchar +
              right pad)) then we need to resize the text first to that size
            ------------------------------------------------------------------#>
            $max_text_width = $Width - $outline_width
            if ($widest_line -gt $max_text_width) {
                Write-Debug '  text is wider than border width supports'
                $content = ($content | Resize-Text -Length $max_text_width)
            }
        } else {
            $Width = $widest_line + $outline_width
        }

        <#------------------------------------------------------------------
         finally, we are ready to output the text with the border
        ------------------------------------------------------------------#>

        <# ! Transcribing the parameters vice using $PSBoundParameters
        we may have adjusted the Width and Padding, so it doesn't make sense to
        just Clone $PSBoundParameters, even though it would seem convenient to just:
        `$content_options = $PSBoundParameters`
        #>
        $border_options = @{
            Character  = $Character
            Width      = $Width
            Foreground = $Foreground
            Background = $Background
        }

        $content_options = @{
            Character  = $Character
            Width      = $Width
            Foreground = $Foreground
            Background = $Background
            PadTop     = $PadTop
            PadBottom  = $PadBottom
            PadRight   = $PadRight
            PadLeft    = $PadLeft
        }

        writeBorderLine @border_options | Write-Output
        if ($PadTop -gt 0) {
            foreach ($top in 1..$PadTop) {
                '' | writeContentLine @content_options | Write-Output
            }
        }
        foreach ($line in $content) {
            $line | writeContentLine @content_options | Write-Output
        }
        if ($PadBottom -gt 0) {
            foreach ($bottom in 1..$PadBottom) {
                '' | writeContentLine @content_options | Write-Output
            }
        }
        writeBorderLine @border_options | Write-Output

        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}

Register-ArgumentCompleter -CommandName Add-TextBorder -ParameterName Foreground -ScriptBlock {
    $PSStyle.Foreground | Get-Member -MemberType Property | Select-Object -expand Name
}

Register-ArgumentCompleter -CommandName Add-TextBorder -ParameterName Background -ScriptBlock {
    $PSStyle.Background | Get-Member -MemberType Property | Select-Object -expand Name
}
