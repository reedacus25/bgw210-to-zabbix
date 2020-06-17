# bgw210-to-zabbix
Ingesting VDSL line statistics into Zabbix

This script will parse the VDSL2 statistics from the Arris BGW210-700 RG
and store them in an Zabbix monitoring environment.
This script is tailored towards VDSL2 installs, not GPON/Fiber or ADSL[2+].
I have not tested this script in a single-pair VDSL2 installation, YMMV.

It has been tested working against the following firmware revisions:
2.6.4
1.10.9
1.9.16
1.8.18

It is known to *NOT* work with firmware versions including and prior to:
1.5.12

This script is written in bash, and has the following dependencies
curl
wget
findutils
zabbix_sender (installed by zabbix-agent package)

While this script doesn't depend on a Zabbix Server or Proxy being installed where this is run,
this script assumes you have an existing Zabbix environment configured.

You will first need to create a host for the modem scraper to push the stats to.
In my usecase, the hostname is BGW210.
Whatever your hostname is in Zabbix, will need to reflect in the $zabbixName variable.

I have created a template for this to add to the host and properly handle the units and the items.
I have NOT created any TRIGGERS for this template, and you can add them yourself if you want them.

The template was created in v5.0, however there should be nothing preventing the template from being used in an older environment.

I recommend running this in cron, at whichever interval you prefer.
