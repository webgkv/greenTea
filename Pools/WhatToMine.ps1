<#
THIS IS A ADVANCED POOL, NOT FOR NOOB.

THIS IS A VIRTUAL POOL, STATISTICS ARE TAKEN FROM WHATTOMINE AND RECALCULATED WITH YOUR BENCHMARKS HashRate, YOU CAN SET DESTINATION POOL YOU WANT FOR EACH COIN, BUT REMEMBER YOU MUST HAVE AND ACOUNT IF DESTINATION POOL IS NOT ANONYMOUS POOL
#>

param(
    [Parameter(Mandatory = $true)]
    [String]$Querymode = $null,
    [Parameter(Mandatory = $false)]
    [PSCustomObject]$Info
)

# . .\..\Include.ps1

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName
$ActiveOnManualMode = $false
$ActiveOnAutomaticMode = $true
$ActiveOnAutomatic24hMode = $true
$WalletMode = "MIXED"
$RewardType = "PPS"
$Result = @()

if ($Querymode -eq "info") {
    $Result = [PSCustomObject]@{
        Disclaimer               = "Based on WhatToMine statistics, you must have account on Suprnova a wallets for each coin on config.ini "
        ActiveOnManualMode       = $ActiveOnManualMode
        ActiveOnAutomaticMode    = $ActiveOnAutomaticMode
        ActiveOnAutomatic24hMode = $ActiveOnAutomatic24hMode
        ApiData                  = $true
        AbbName                  = 'WTM'
        WalletMode               = $WalletMode
        RewardType               = $RewardType
    }
}

if (($Querymode -eq "speed") ) {
    if ($PoolRealName -ne $null) {
        $Info.PoolName = $PoolRealName
        $Result = Get-Pools -Querymode "speed" -PoolsFilterList $Info.PoolName -Info $Info
    }
}

if (($Querymode -eq "wallet") -or ($Querymode -eq "APIKEY")) {
    if ($PoolRealName -ne $null) {
        $Info.PoolName = $PoolRealName
        $Result = Get-Pools -Querymode $info.WalletMode -PoolsFilterList $Info.PoolName -Info $Info | select-object Pool, currency, balance
    }
}

if ($Querymode -eq "core" -or $Querymode -eq "Menu") {

    #Look for pools
    $ConfigOrder = (Get-ConfigVariable "WHATTOMINEPOOLORDER") -split ','
    $HPools = foreach ($PoolToSearch in $ConfigOrder) {
        $HPoolsTmp = Get-Pools -Querymode "core" -PoolsFilterList $PoolToSearch -location $Info.Location
        #Filter by minworkes variable (must be here for not selecting now a pool and after that discarded on core.ps1 filter)
        $HPoolsTmp | Where-Object {$_.Poolworkers -ge (Get-ConfigVariable "MINWORKERS") -or $_.Poolworkers -eq $null}
    }

    #Common Data from WTM

    #Add main page coins
    $WtmUrl = 'https://whattomine.com/coins.json?' +
    'bk14=true&factor[bk14_hr]=10&factor[bk14_p]=0&' + #Decred
    'cn=true&factor[cn_hr]=10&factor[cn_p]=0&' + #CryptoNight
    'cn7=true&factor[cn7_hr]=10&factor[cn7_p]=0&' + #CryptoNightV7
    'cnh=true&factor[cnh_hr]=10&factor[cnh_p]=0&' + #CryptoNightHeavy
    'eq=true&factor[eq_hr]=10&factor[eq_p]=0&' + #Equihash
    'eth=true&factor[eth_hr]=10&factor[eth_p]=0&' + #Ethash
    'grof=true&factor[gro_hr]=10&factor[gro_p]=0&' + #Groestl
    'l2z=true&factor[l2z_hr]=10&factor[l2z_p]=0&' + #Lyra2z
    'lbry=true&factor[lbry_hr]=10&factor[lbry_p]=0&' + #Lbry
    'lre=true&factor[lrev2_hr]=10&factor[lrev2_p]=0&' + #Lyra2v2
    'n5=true&factor[n5_hr]=10&factor[n5_p]=0&' + #Nist5
    'ns=true&factor[ns_hr]=10&factor[ns_p]=0&' + #NeoScrypt
    'pas=true&factor[pas_hr]=10&factor[pas_p]=0&' + #Pascal
    'phi=true&factor[phi_hr]=10&factor[phi_p]=0&' + #PHI
    'phi2=true&factor[phi2_hr]=10&factor[phi2_p]=0&' + #PHI2
    'skh=true&factor[skh_hr]=10&factor[skh_p]=0&' + #Skunk
    'x11gf=true&factor[x11g_hr]=10&factor[x11g_p]=0&' + #X11gost
    'x16r=true&factor[x16r_hr]=10&factor[x16r_p]=0&' + #X16r
    'xn=true&factor[xn_hr]=10&factor[xn_p]=0&' #Xevan
    'zh=true&factor[zh_hr]=10&factor[zh_p]=0' #ZHash (Equihash144)

    $WTMResponse = Invoke-APIRequest -Url $WtmUrl -Retry 3 | Select-Object -ExpandProperty coins
    if (!$WTMResponse) {
        Write-Host $Name 'API NOT RESPONDING...ABORTING'
        Exit
    }
    $WTMCoins = $WTMResponse.PSObject.Properties.Name | ForEach-Object {
        #convert response to collection
        $res = $WTMResponse.($_)
        $res | Add-Member name (Get-CoinUnifiedName $_)
        $res.Algorithm = Get-AlgoUnifiedName ($res.Algorithm)
        $res
    }
    Remove-Variable WTMResponse

    #Add secondary page coins
    $WTMResponse = Invoke-APIRequest -Url 'https://whattomine.com/calculators.json' -Retry 3 | Select-Object -ExpandProperty coins
    if ($WTMResponse) {
        $WTMSecondaryCoins = $WTMResponse.PSObject.Properties.Name | ForEach-Object {
            #convert response to collection
            $res = $WTMResponse.($_)
            $res | Add-Member name (Get-CoinUnifiedName $_)
            $res.Algorithm = Get-AlgoUnifiedName ($res.Algorithm)
            switch ($res.name) {
                'BitcoinZ' {$res.Algorithm = 'EquihashBTCZ'}
                'BitcoinGold' {$res.Algorithm = 'EquihashBTG'}
            }
            if ($res.Status -eq "Active") {$res}
        }
        Remove-Variable WTMResponse
    }

    #join pools and coins
    ForEach ($HPool in $HPools) {

        $HPool.Algorithm = Get-AlgoUnifiedName $HPool.Algorithm
        $HPool.Info = Get-CoinUnifiedName $HPool.Info

        switch ($HPool.Info) {
            'BitcoinZ' {$HPool.Algorithm = 'EquihashBTCZ'}
            'BitcoinGold' {$HPool.Algorithm = 'EquihashBTG'}
        }

        #we must add units for each algo, this value must be filled if we want a coin to be selected
        $WTMFactor = switch ($HPool.Algorithm) {
            "Bitcore" { 1000000 }
            "Blake2s" { 1000000 }
            "CnLiteV7" { 1 }
            "CnV7" { 1 }
            "CnHeavy" { 1 }
            "EquihashBTG" { 1 }
            "EquihashBTCZ" { 1 }
            "Ethash" { 1000000 }
            "Keccak" { 1000000 }
            "KeccakC" { 1000000 }
            "Lyra2v2" {1000}
            "Lyra2z" { 1000000 }
            "NeoScrypt" { 1000 }
            "Phi" { 1000000 }
            "Phi2" { 1000000 }
            "Skunk" { 1000000 }
            "Tensority" { 1 }
            "X16r" { 1000000 }
            "X16s" { 1000000 }
            "X17" { 1000 }
            "Yescrypt" { 1 }
            "Zero" { 1 }
            "Zhash" { 1 }
            default { $null }
        }

        if ($WTMFactor -and ($Result | Where-Object {$_.Info -eq $HPool.Info -and $_.Algorithm -eq $HPool.Algorithm}).count -eq 0) {
            #look that this coin is not included in result

            #look for this coin in main page coins
            $WtmCoin = $WTMCoins | Where-Object {
                $_.Name -eq $HPool.Info -and
                $_.Algorithm -eq $HPool.Algorithm
            }

            if (!$WtmCoin -and $WTMSecondaryCoins) {
                #look in secondary coins page
                $WtmSecCoin = $WTMSecondaryCoins | Where-Object {
                    $_.Name -eq $HPool.Info -and
                    $_.Algorithm -eq $HPool.Algorithm
                }
                if ($WtmSecCoin) {
                    $WtmCoin = Invoke-APIRequest -Url ('https://whattomine.com/coins/' + $WtmSecCoin.Id + '.json?hr=10&p=0&fee=0.0&cost=0.0&hcost=0.0') -Retry 3
                    if ($WtmCoin) {
                        if (-not [decimal]$WtmCoin.btc_revenue) {
                            if (!$CMCResponse) {
                                'Calling CoinMarketCap API' | Write-Host
                                $CMCResponse = Invoke-APIRequest -Url "https://api.coinmarketcap.com/v1/ticker/?limit=0" -MaxAge 60 -Retry 1
                            }
                            $CMCPrice = [decimal]($CMCResponse | Where-Object Symbol -eq $WtmCoin.tag | Select-Object -First 1 -ExpandProperty price_btc)
                            $WtmCoin.btc_revenue = $CMCPrice * [decimal]$WtmCoin.estimated_rewards
                        }
                        $WtmCoin | Add-Member btc_revenue24 $WtmCoin.btc_revenue
                    }
                }
            }
            if ($WtmCoin) {
                $Result += [PSCustomObject]@{
                    Info                  = $HPool.Info
                    Algorithm             = $HPool.Algorithm
                    Price                 = [decimal]$WtmCoin.btc_revenue / $WTMFactor / 10
                    Price24h              = [decimal]$WtmCoin.btc_revenue24 / $WTMFactor / 10
                    Symbol                = $WtmCoin.Tag
                    Host                  = $HPool.Host
                    HostSSL               = $HPool.HostSSL
                    Port                  = $HPool.Port
                    PortSSL               = $HPool.PortSSL
                    Location              = $HPool.Location
                    SSL                   = $HPool.SSL
                    Fee                   = $HPool.Fee
                    User                  = $HPool.User
                    Pass                  = $HPool.Pass
                    Protocol              = $HPool.Protocol
                    ProtocolSSL           = $HPool.ProtocolSSL
                    AbbName               = "W-" + $HPool.AbbName
                    WalletMode            = $HPool.WalletMode
                    EthStMode             = $HPool.EthStMode
                    WalletSymbol          = $HPool.WalletSymbol
                    PoolName              = $HPool.PoolName
                    PoolWorkers           = $HPool.PoolWorkers
                    PoolHashRate          = $HPool.PoolHashRate
                    RewardType            = $HPool.RewardType
                    ActiveOnManualMode    = $ActiveOnManualMode
                    ActiveOnAutomaticMode = $ActiveOnAutomaticMode
                }
            }
        }
    } #end foreach pool
    Remove-Variable HPools
}

$Result | ConvertTo-Json | Set-Content $Info.SharedFile
Remove-Variable Result
