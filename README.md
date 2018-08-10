# greenTea
greenTea forked from Forager by yuzi-co , who forked it from Megaminer by tutulino, who forked it from MultiPoolMiner by aaronsauce. :)

<br><br>
greenTea pack called up to try for max testing NVIDIA miners.


<h2>Changes from Forager</h2>

- Full tests under win 10 with Cuda 9.2<br>
- Provide additional pack for Cuda 9.1 with tests under win7<br>
- Optimization all NVIDIA miner jsons files for max stability and fast tests<br>
- Add links for same additional miners for Cuda 9.1<br>
- Del all AMD miners 
<br><br>
small fixes, code optimizations and formatting changes
<br><br>
Donations are welcome
<br><br>
BTC - 32emys3R2nj34wwJ1zYhBjgY2fbuqbwLL9b<br>
ETH - 0x2f231A68566B942DBF9231B378e30EC1d6Eb0cfB<br>
LTC - Lhx4kTj8wBtXG2XfaAfr8mSQf6GpvPvnw7
<br><br>
Original author's wallets listed at the end of original readme below
<br><br>
Original readme file below<br>
<h2>---- POOLS SUPORTED ---------------------------------------</h2>

AHASHPOOL -- Anonymous, autoexchange to selected coin in config.txt ALTMINER -- Anonymous, no autoexchange, must set a wallet for each coin BLAZEPOOL -- Anonymous, autoexchange to selected coin in config.txt BLOCKSFACTORY -- Registration required, one registration for all pools, no autoexchange BSOD.PW -- Anonymous, no autoexchange, must set a wallet for each coin FLYPOOL -- Anonymous, manual mode only HASHREFINERY -- Anonymous, autoexchange to selected coin in config.txt ITALYIIMP -- Anonymous, autoexchange to selected coin in config.txt MININGPOOLHUB -- registration required, autoexchange to selected coin on pool´s web. NANOPOOL -- Anonymous, no autoexchange, must set a wallet for each coin NICEHASH-- Anonymous, autoexchange to BTC SUPRNOVA -- Registration required, one registration for all pools except bitcoin cash, no autoexchange UNIMINING -- No registration, No autoexchange, need wallet for each coin on config.txt WHATTOMINE (virtual) - Based on statistics of whattomine, it use MPH and Suprnova servers to mine most profitable coin, you must configure wallets on config.cfg and also have an account on Suprnova to us YIIMP -- Anonymous, no autoexchange, must set a wallet for each coin ZERGPOOL -- Anonymous, autoexchange to selected coin in config.txt ZPOOL -- Anonymous, autoexchange to selected coin in config.txt

<h2>---- INSTRUCTIONS ----------------------------------------------</h2>

Download and decompress source code from latest Release from github (you dont need executable file)
<br><br>
For AMD, Install Microsoft Visual C++ 2015 Redistributable https://www.microsoft.com/en-us/download/details.aspx?id=52685
<br><br>
For AMD, beta blockchain drivers are not recommended (gpus will not show in current screen and activity based watchdog will be disabled)
<br><br>
Edit CONFIG.TXT file before mining
<br><br>
Exec start.bat for manual selection or edit AutoStartExample.bat for automatic boot without user prompt, you can use this parameters on your batch
<br><br>
PoolsName = separated comma string of pools to run
MiningMode = Mode to check profit, note not all pools support all modes (Automatic/Automatic24h/Manual). If manual mode is selected one coin must be passed on Coinsname parameter
Algorithm = separated comma string of algorithms to run (optional)
CoinsName = separated comma string of Coins to run (optional)
Groupnames = Groups of gpu/cpu to run (based on your defined groups in config.txt @@Gpugroups section) (optional)
PercentToSwitch = Overrides config.txt config, percent to switch miner/algo, new miner/algo only will be launched if new profit is greater than actual profit in specified percent (optional)
First time, software will be donwloaded from miners github repositories
<br><br>
As usual, some miners are detected as virus by your Antivirus, to avoid this you must set your instalation directory as excluded. For Windows Defender MM path is excluded automatic
Your system will be benchmarked (long process)
<br><br>
Make profit
<br><br>
Except Nicehash (where you sell your power to indicated price), pools always overestimated profit, you must understand profit column as a way to get best algorithm. Your real profit will be lower.
Tuning (optional)
<br><br>
you can edit miners folders content to delete miners or to assign/unassign algos to miners.
you can edit pools folders content to delete pools
for advanced users, you can create miners or pools if are based on existing one.
Monitorize all your rigs from one machine using Farm Monitor
<br><br>
set @@APIPORT=9999 (or any number) in each monitorized machine
set a list of monitorized machines in @@FARMRIGS variable (only on monitor machine)
optional, set your mail cfg to get notifications when a rig goes offline
<h2>---- UPGRADE PROCEDURE ------------------------------------</h2>
<br><br>
Safest way is download new software and copy from old version "stats" folders and "config.txt" file. If new version has no miners update you can copy "bin" folder If there is a new miner version is recommended delete miner_algo_hashrate.txt files on miners folder to force benchmark again.
<br><br>
<h2>-------NEW FEATURES OVER BASE SOFTWARE -----------</h2>
<br><br>
-Menus system to choose coin/algo/pool and start mining
<br><br>
-One file config to start mining
<br><br>
-Can mine on "Virtual" Pool Whattomine, based on statistics of whattomine, it use MPH,Yiimp and Suprnova servers to mine most profitable coin, you must configure wallets on config.cfg and also have an account on Suprnova to use.
<br><br>
-Can mine on any of this pools (or all at same time): Ahashpool, Nanopool, YIIMP, Nicehash, Zpool, Unimining, Whattomine (virtual) HashRefinery, MPH with auto coin change based on pool profit for each algorithm with dual mining between different pools (ex. Eth on MPH and lbry on Zpool)
<br><br>
-Can mine on Suprnova,Nicehash, MPH, Flypool or BlocksFactory pool without autochange or profit calculation, manual coin selection
<br><br>
-Fastest miner for each algo/coin preselected for NVIDIA Pascal (08/01/2017) on all pools.
<br><br>
-Dual Mining between different pools (ex. Eth on MPH and lbry on Zpool)
<br><br>
-Profit info from Whattomine,Bittrex and Cryptopia (based on your real hashrate) for manual coin selection
<br><br>
-Unified software repository for all pools, no need one program for each pool
<br><br>
-On fail no wait for interval ends, instant relaunch.
<br><br>
-Auto Interval time for benchmarks, no need to change interval more.
<br><br>
-Local currency info on main screen
<br><br>
-Latest version of miners available
<br><br>
-GPU Info (AMD/NVIDIA) (Power, fan, temperatures, efficiency...)
<br><br>
-Pools Wallets actual and evolution info
<br><br>
-Option to autochange based on 24h statistics (on supported pools)
<br><br>
-Option for associate command to launch before run to each miner (NVIDIA inspector for example to set overclock)
<br><br>
-Miners and Pools fees are included in profit calculation
<br><br>
-For mixed rigs (or for testing purpose on same cards rigs) you can group your cards allowing each group work at its best algo and difficulty
<br><br>
-Option to switch miner only if profit is a percent upper than actual (defined by you)
<br><br>
-Automatic NVIDIA Gpu Power limit, you can define any power limit values (90%, 80%, etc) for each winner miner/algo MM checks what of that power limit point is more profitable at each interval based in power cost, hashrate and reward.
<br><br>
-Delayed miners closing, while new miner is starting, old one continue mining
<br><br>
-Api rest for other software integration
<br><br>
-Utility for Farm rigs monitoring/alert (see config.txt)

<h2>----- DISCLAIMER ---- ------------------------------------------</h2>

Tested on NVIDIA pascal 10X0 and AMD RX580
<br><br>
Only for Windows
<br><br>
Core for auto change pools is forked from AaronSace MultipoolMiner, you can read info at https://github.com/aaronsace/MultiPoolMiner
<br><br>
Profit calculations are estimates based on info provided by Pools/Whattomine for your benchmarked hashrate extrapolated to 24h. No real profit warranty except nicehash, where you are selling your power at indicated price.
<br><br>
Pools or Whattomine statistics are based on past (luck, difficulty, exchange-rate, pool hashrte, network hashrate, etc), it can be not very accurate, usually expected profit is near 50% pool indicates.
<br><br>
Local Currency exchange rate to BTC is taken from Coindesk, Local currency profit can vary from whattomine revenue (instant), BTC revenue must be exact.
<br><br>
Based 20% on aaronsace, 80% is new at latest release (aprox.) Donations to
<br><br>
Forager
<br><br>
BTC - 3FzmW9JMhgmRwipKkNnphxG73VPQMsYsN6<br>
ETH - 0x38973025136D1a5B773aE71c02cA24b365850A9A<br>
LTC - MM8RmXUgxDwHJxrC54muF7KHciSCFS3gx3
<br><br>
Megaminer
<br><br>
BTC: 1AVMHnFgc6SW33cwqrDyy2Fug9CsS8u6TM LTC: LVwuYbAvbMDVapheQBA7o2qQ2mKTEXVDbX BCH: 1N7wsg4JmWJLP6BuHUP5rwsAXnQjTWPBjr ETH: 0x9b7A01Bf5bD29c66d228d372B5bD1C43cDb78AcC

---- <h2>NO SCAM WARRANTY</h2> --------------------------------------------

You can audit .ps1 files, they are source code and running script (no compilation needed), miners are downloaded from github except not available that are downloaded from developer source and uploaded to my repository
