
Zabbix Slack AlertScript
========================


About
-----
This is simply a Bash script that uses the custom alert script functionality within [Zabbix](http://www.zabbix.com/) along with the incoming web-hook feature of [Slack](https://slack.com/) that I got a chance to write for my employer since I could not find any already existing/similar scripts. This most likely only works with Zabbix 2.0 or greater - it has not been tested with Zabbix 1.8 or earlier.


Installation
------------
The ["slack.sh" Bash script](https://github.com/ericoc/zabbix-slack-alertscript/blob/master/slack.sh) needs to be placed in the "AlertScriptsPath" directory that is specified within the Zabbix servers' configuration file (zabbix_server.conf) and must be executable by the user (usually "zabbix") running the zabbix_server binary on the Zabbix server before restarting the Zabbix server software:

	[root@zabbix ~]# grep AlertScriptsPath /etc/zabbix/zabbix_server.conf
	### Option: AlertScriptsPath
	AlertScriptsPath=/usr/local/share/zabbix/alertscripts

	[root@zabbix ~]# ls -lh /usr/local/share/zabbix/alertscripts/slack.sh
	-rwxr-xr-x 1 root root 1.7K Dec 27 13:25 /usr/local/share/zabbix/alertscripts/slack.sh

An incoming web-hook integration must be created within your Slack.com account which can be done at https://slack.com/services/new/incoming-webhook


TODO: screenshots/better explanation of the set-up on both slack.com and within the zabbix web interface


More Information
----------------
 * [Zabbix (2.2) custom alertscripts documentation](https://www.zabbix.com/documentation/2.2/manual/config/notifications/media/script)
