
function New-RandomString {
    <#
    .SYNOPSIS
        Generate a random characterset, useful for passwords
    .EXAMPLE
        PS > New-RandomString
    #>
    [CmdletBinding()]
    param(
        # Length of the string to generate. Defaults to 24
        [Parameter(
        )]
        [int]$Length = 24,

        # Number of lowercase letters. Defaults to 8
        [Parameter(
        )]
        [int]$Lower = 8,

        # Number of uppercase letters. Defaults to 8
        [Parameter(
        )]
        [int]$Upper = 8,

        # Number of digits (numbers). Defaults to 4
        [Parameter(
        )]
        [int]$Digits = 4,

        # Number of special characters. Defaults to 4
        [Parameter(
        )]
        [int]$Special = 4
    )
    begin {
        [char[]]$lowerChars   = 'abcdefghijklmnopqrstuvwxyz'
        [char[]]$upperChars   = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        [char[]]$digitChars   = '0123456789'
        [char[]]$specialChars = '!@#$%^&*(){}[].,<>?=+\/-_'
    }
    process {
        $password  = ($lowerChars     | Get-Random -Count $Lower   ) -join ''
        $password += ($upperChars     | Get-Random -Count $Upper   ) -join ''
        $password += ($digitChars     | Get-Random -Count $Digits  ) -join ''
        $password += ($specialChars   | Get-Random -Count $Special ) -join ''

        $passwordarray = $password.tochararray()
        $scrambledpassword = ($passwordarray | Get-Random -Count $Length) -join ''
    }
    end {
        $scrambledpassword
    }
}
