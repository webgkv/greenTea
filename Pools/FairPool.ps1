param(
    [Parameter(Mandatory = $true)]
    [String]$Querymode = $null,
    [Parameter(Mandatory = $false)]
    [PSCustomObject]$Info
)

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName
$ActiveOnManualMode = $true
$ActiveOnAutomaticMode = $false
$AbbName = 'FAIR'
$WalletMode = "WALLET"
$RewardType = "PPLS"
$Result = @()

if ($Querymode -eq "info") {
    $Result = [PSCustomObject]@{
        Disclaimer            = "Must set wallet for each coin on web, set login on config.ini file"
        ActiveOnManualMode    = $ActiveOnManualMode
        ActiveOnAutomaticMode = $ActiveOnAutomaticMode
        ApiData               = $true
        AbbName               = $AbbName
        WalletMode            = $WalletMode
        RewardType            = $RewardType
    }
}

if ($Querymode -eq "speed") {
    $Request = Invoke-APIRequest -Url $("https://" + $Info.Symbol + ".fairpool.cloud/api/stats?login=" + ($Info.user -split "\+")[0]) -Retry 1

    if ($Request -and $Request.Workers) {
        $Request.Workers | ForEach-Object {
            $Result += [PSCustomObject]@{
                PoolName   = $name
                WorkerName = $_[0]
                HashRate   = $_[1]
            }
        }
        Remove-Variable Request
    }
}

if ($Querymode -eq "wallet") {
    $Request = Invoke-APIRequest -Url $("https://" + $Info.Symbol + ".fairpool.cloud/api/stats?login=" + ($Info.User -split "\+")[0]) -Retry 3
    if ($Request) {
        switch ($Info.Symbol) {
            'pasl' { $Divisor = 1e4 }
            'sumo' { $Divisor = 1e9}
            'loki' { $Divisor = 1e9}
            'xhv' { $Divisor = 1e12}
            'xrn' { $Divisor = 1e9}
            'bloc' { $Divisor = 1e4}
            'purk' { $Divisor = 1e6}
            Default { $Divisor = 1e9 }
        }
        $Result = [PSCustomObject]@{
            Pool     = $name
            currency = $Info.Symbol
            balance  = ($Request.balance + $Request.unconfirmed ) / $Divisor
        }
        Remove-Variable Request
    }
}

if (($Querymode -eq "core" ) -or ($Querymode -eq "Menu")) {
    $Pools = @()

    $Pools += [PSCustomObject]@{coin = "Akroma"; algo = "Ethash"; symbol = "AKA"; port = 2222; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "Dogethereum"; algo = "Ethash"; symbol = "DOGX"; port = 7788; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "EthereumClassic"; algo = "Ethash"; symbol = "ETC"; port = 4444; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "Metaverse"; algo = "Ethash"; symbol = "ETP"; port = 6666; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "Nekonium"; algo = "Ethash"; symbol = "NUKO"; port = 7777; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "Pegascoin"; algo = "Ethash"; symbol = "PGC"; port = 1111; fee = 0.01}

    $Pools += [PSCustomObject]@{coin = "PascalLite"; algo = "Pascal"; symbol = "PASL"; port = 4009; fee = 0.02}
    $Pools += [PSCustomObject]@{coin = "PURK"; algo = "WildKeccakPurk"; symbol = "PURK"; port = 2244; fee = 0.01}

    $Pools += [PSCustomObject]@{coin = "BLOC.money"; algo = "CnHeavy"; symbol = "BLOC"; port = 6010; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "Haven"; algo = "CnHaven"; symbol = "XHV"; port = 5566; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "Loki"; algo = "CnHeavy"; symbol = "LOKI"; port = 5577; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "PrivatePay"; algo = "CnFast"; symbol = "XPP"; port = 6050; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "Quantum R L"; algo = "CnV7"; symbol = "QRL"; port = 6010; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "RYO"; algo = "CnHeavy"; symbol = "RYO"; port = 5555; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "Saronite"; algo = "CnHeavy"; symbol = "XRN"; port = 5599; fee = 0.01}
    $Pools += [PSCustomObject]@{coin = "SolaceCoin"; algo = "CnHeavy"; symbol = "SOLACE"; port = 5588; fee = 0.01}

    $Pools | ForEach-Object {
        if ($CoinsWallets.($_.symbol)) {
            $Result += [PSCustomObject]@{
                Algorithm             = $_.Algo
                Info                  = $_.Coin
                Protocol              = "stratum+tcp"
                Host                  = "mine." + $_.symbol + ".fairpool.cloud"
                Port                  = $_.Port
                User                  = $CoinsWallets.($_.symbol) + "+#WorkerName#"
                Pass                  = "x"
                Location              = "US"
                SSL                   = $false
                Symbol                = $_.symbol
                AbbName               = $AbbName
                ActiveOnManualMode    = $ActiveOnManualMode
                ActiveOnAutomaticMode = $ActiveOnAutomaticMode
                PoolName              = $Name
                WalletMode            = $WalletMode
                WalletSymbol          = $_.Symbol
                Fee                   = $_.Fee
                RewardType            = $RewardType
            }
        }
    }
    Remove-Variable Pools
}

$Result | ConvertTo-Json | Set-Content $info.SharedFile
Remove-Variable Result
