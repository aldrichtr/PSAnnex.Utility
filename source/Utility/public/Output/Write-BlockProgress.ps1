
function Write-BlockProgress {
    [CmdletBinding()]
    param(
        # Total length of the progress bar
        [Parameter(
            Mandatory
        )]
        [int]$Length,

        # The progress message to display
        [Parameter(
        )]
        [string]$Message
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $blocks = @(
            ' ',
            "`u{258F}",
            "`u{258E}",
            "`u{258D}",
            "`u{258C}",
            "`u{258B}",
            "`u{258A}",
            "`u{2589}",
            "`u{2588}"
        )
        $pause = 4
    }
    process {
        $chunks = $Length / 8
        Write-Host "`e[?25l" -NoNewline
        Write-Host ("{0} [`e[s{1}]`e[u" -f $Message, (' ' * ($chunks - 2))) -NoNewline
        $end_of_line = (($Message.Length) + (1 + 2) + ($chunks - 2) +1)

        foreach ($chunk in 0..$chunks) {
            for ($i = 0; $i -lt $blocks.Count; $i++) {
                Write-Host "$($blocks[$i])$(Start-Sleep -Milliseconds $pause)`e[1D" -NoNewline
            }
            Write-Host "$($blocks[8])" -NoNewline
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
