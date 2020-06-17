#!/bin/bash

#This script will parse the VDSL2 statistics from the Arris BGW210-700 RG
#and store them in an InfluxDB time series database.
#This script is tailored towards VDSL2 installs, not GPON/Fiber or ADSL[2+].
#I have not tested this script in a single-pair VDSL2 installation, YMMV.

#It has been tested working against the following firmware revisions:
#2.6.4
#1.10.9
#1.9.16
#1.8.18

#It is known to *NOT* work with firmware versions including and prior to:
#1.5.12

#This script is written in bash, and has the following dependencies
#curl
#wget
#findutils
#zabbix_sender (installed by zabbix-agent package)

#while this script doesn't depend on influxdb being installed where this is run,
#this script assumes you have an existing influxdb environment and database for storing data.

#general concept is that you know the line number of the metric you want
#head the number of lines to include the line you want
#tail 1 line to get the line you want
#cut to get the value you want
#pass through xargs to clean the data
#store all of this in a variable to pass to influxdb

#I recommend running this in cron, at whichever interval you prefer.

#Legend:
#DS = Downstream
#US = Upstream
#L1 = Line 1
#L2 = Line 2

#set location for where to pull the stats down to
workdir=/tmp
statsfile=broadbandstatistics.ha

#set zabbix server/proxy info
zabbixServer=localhost
zabbixName=BGW210


#pull down the stats file to working directory and set variable to the stats file
modemaddress=192.168.1.254
modemstatspath="cgi-bin/broadbandstatistics.ha"
wget http://$modemaddress/$modemstatspath  -O $workdir/$statsfile
html=$workdir/$statsfile

#command to post to zabbix
post2zabbix='/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"'

#comments for 'variableName - lineNumber'

#VDSL2 Line Sync Rates
#line1syncDS - 159
line1syncDS=$(head -n158 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.ds.sync"
zabbixValue=$line1syncDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2syncDS - 160
line2syncDS=$(head -n159 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.ds.sync"
zabbixValue=$line2syncDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1syncUS - 163
line1syncUS=$(head -n162 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.us.sync"
zabbixValue=$line1syncUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2syncUS - 164
line2syncUS=$(head -n163 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.us.sync"
zabbixValue=$line2syncUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1maxDS - 167
line1maxDS=$(head -n166 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.ds.max"
zabbixValue=$line1maxDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2maxDS - 168
line2maxDS=$(head -n167 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.ds.max"
zabbixValue=$line2maxDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1maxUS - 171
line1maxUS=$(head -n170 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.us.max"
zabbixValue=$line1maxUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2maxUS - 172
line2maxUS=$(head -n171 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.us.max"
zabbixValue=$line2maxUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#bothsyncDS - 376
bothsyncDS=$(head -n375 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.both.ds.sync"
zabbixValue=$bothsyncDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#bothsyncUS - 380
bothsyncUS=$(head -n379 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.both.us.sync"
zabbixValue=$bothsyncUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

#VDSL2 Line SNR values
#line1snrDS - 190
line1snrDS=$(head -n189 $html | tail -n1 | xargs)
zabbixKey="bgw210.l1.ds.snr"
zabbixValue=$line1snrDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1snrUS - 193
line1snrUS=$(head -n192 $html | tail -n1 | xargs)
zabbixKey="bgw210.l1.us.snr"
zabbixValue=$line1snrUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2snrDS - 196
line2snrDS=$(head -n195 $html | tail -n1 | xargs)
zabbixKey="bgw210.l2.ds.snr"
zabbixValue=$line2snrDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2snrUS - 199
line2snrUS=$(head -n198 $html | tail -n1 | xargs)
zabbixKey="bgw210.l2.us.snr"
zabbixValue=$line2snrUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

#VDSL2 Line Attenuation values
#line1attenDS - 204
line1attenDS=$(head -n203 $html | tail -n1 | xargs)
zabbixKey="bgw210.l1.ds.atten"
zabbixValue=$line1attenDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1attenUS - 207
line1attenUS=$(head -n206 $html | tail -n1 | xargs)
zabbixKey="bgw210.l1.us.atten"
zabbixValue=$line1attenUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2attenDS - 210
line2attenDS=$(head -n209 $html | tail -n1 | xargs)
zabbixKey="bgw210.l2.ds.atten"
zabbixValue=$line2attenDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2attenUS - 213
line2attenUS=$(head -n212 $html | tail -n1 | xargs)
zabbixKey="bgw210.l2.us.atten"
zabbixValue=$line2attenUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

#VDSL2 Line Upstream/Downstream Power Level values
#line1powerDS - 218
line1powerDS=$(head -n217 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.ds.power"
zabbixValue=$line1powerDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1powerUS - 220
line1powerUS=$(head -n219 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.us.power"
zabbixValue=$line1powerUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2powerDS - 222
line2powerDS=$(head -n221 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.ds.power"
zabbixValue=$line2powerDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2powerUS - 224
line2powerUS=$(head -n223 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.us.power"
zabbixValue=$line2powerUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

#VDSL2 Line Forward Error Correction values
#line1fecDS - 258
line1fecDS=$(head -n257 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.ds.fec"
zabbixValue=$line1fecDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1fecUS - 260
line1fecUS=$(head -n259 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.us.fec"
zabbixValue=$line1fecUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2fecDS - 262
line2fecDS=$(head -n261 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.ds.fec"
zabbixValue=$line2fecDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2fecUS - 264
line2fecUS=$(head -n263 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.us.fec"
zabbixValue=$line2fecUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

#VDSL2 Line CRC Error values
#line1crcDS - 268
line1crcDS=$(head -n267 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.ds.crc"
zabbixValue=$line1crcDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1crcUS - 270
line1crcUS=$(head -n269 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.us.crc"
zabbixValue=$line1crcUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2crcDS - 272
line2crcDS=$(head -n271 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.ds.crc"
zabbixValue=$line2crcDS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2crcUS - 274
line2crcUS=$(head -n273 $html | tail -n1 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.us.crc"
zabbixValue=$line2crcUS
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

#VDSL2 Line Errored Seconds
#line1errsec15m - 292
line1errsec15m=$(head -n291 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.15m.errsec"
zabbixValue=$line1errsec15m
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2errsec15m - 298
line2errsec15m=$(head -n297 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.15m.errsec"
zabbixValue=$line2errsec15m
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1errsecsev15m - 305
line1errsecsev15m=$(head -n304 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.15m.errsecsev"
zabbixValue=$line1errsecsev15m
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2errsecsev15m - 311
line2errsecsev15m=$(head -n310 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.15m.errsecsev"
zabbixValue=$line2errsecsev15m
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line1unavail15m - 318
line1unavail15m=$(head -n317 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l1.15m.unavail"
zabbixValue=$line1unavail15m
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
#line2unavail15m - 324
line2unavail15m=$(head -n323 $html | tail -n1 | cut -d\> -f2 | cut -d\< -f1 | xargs)
zabbixKey="bgw210.l2.15m.unavail"
zabbixValue=$line2unavail15m
/usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"


#cleanup the statsfile
rm $html
