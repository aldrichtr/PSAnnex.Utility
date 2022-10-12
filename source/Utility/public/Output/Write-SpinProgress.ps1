
function Write-SpinProgress {
    <#
    .SYNOPSIS
        Output a retro spinning progress indicator
    #>
    [CmdletBinding()]
    param(
        # Total length of the progress bar
        [Parameter(
            Mandatory
        )]
        [int]$Length
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $controls = @( "`u{2014}", '\', '|', '/' )
        $reps = 5 # how many spins before advancing
        $pause = 40 # how many milliseconds to wait before "deleting" the char
    }
    process {
        Write-Host "`e[?25l" -NoNewline

        foreach ($step in 0..$length) {
            foreach ($rep in 0..$reps) {
                foreach ($char in 0..3) {
                    # print the char, sleep, backspace, stay on the line
                    Write-Host "$($controls[$char])$(Start-Sleep -Milliseconds $pause)`e[1D" -NoNewline
                }
            }
            Write-Host "." -NoNewline
        }
    }
    end {
        Write-Host ' Done' -fg DarkGreen
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
