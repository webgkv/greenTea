param(
    [Parameter(Mandatory = $true)]
    [String]$Querymode = $null,
    [Parameter(Mandatory = $false)]
    [PSCustomObject]$Info
)

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName
$ActiveOnManualMode = $true
$ActiveOnAutomaticMode = $false
$AbbName = 'MY'
$WalletMode = "NONE"
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

if (($Querymode -eq "core" ) -or ($Querymode -eq "Menu")) {
    $Pools = @()

      $Pools += [PSCustomObject]@{coin = "Aeon"; algo = "CnLiteV7"; symbol = "AEON"; server = "mine.aeon-pool.com"; port = 5555; fee = 0.01; user = $CoinsWallets.AEON}
      $Pools += [PSCustomObject]@{coin = "HPPcoin"; algo = "Lyra2h"; symbol = "HPP"; server = "pool.hppcoin.com"; port = 3008; fee = 0.02; user = "$UserName.#WorkerName#"}
      $Pools += [PSCustomObject]@{coin = "Dallar"; algo = "Throestl"; symbol = "DAL"; server = "pool.dallar.org"; port = 3032; fee = 0.01; user = $CoinsWallets.DAL}
      $Pools += [PSCustomObject]@{coin = "Cryply"; algo = "YesPower"; symbol = "CRP"; server = "cryply.luckypool.org"; port = 9997; fee = 0; user = "$UserName.#WorkerName#"}

    $Pools | ForEach-Object {
        $Result += [PSCustomObject]@{
            Algorithm             = $_.Algo
            Info                  = $_.Coin
            Protocol              = "stratum+tcp"
            Host                  = $_.Server
            Port                  = $_.Port
            User                  = $_.User
            Pass                  = if ([string]::IsNullOrEmpty($_.Pass)) {"x"} else {$_.Pass}
            Location              = "EU"
            SSL                   = $false
            Symbol                = $_.symbol
            AbbName               = $AbbName
            ActiveOnManualMode    = $ActiveOnManualMode
            ActiveOnAutomaticMode = $ActiveOnAutomaticMode
            PoolName              = $Name
            WalletMode            = $WalletMode
            Fee                   = $_.Fee
            RewardType            = $RewardType
        }
    }
    Remove-Variable Pools
}

$Result | ConvertTo-Json | Set-Content $Info.SharedFile
Remove-Variable result
