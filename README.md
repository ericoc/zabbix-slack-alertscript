Zabbix Slack AlertScript
========================


About
-----
This is simply a Bash script that uses the custom alert script functionality within [Zabbix](http://www.zabbix.com/) along with the incoming web-hook feature of [Slack](https://slack.com/) that I got a chance to write since I could not find any already existing/similar scripts.

This most likely only works with Zabbix 2.0 or greater - it has not been tested with Zabbix 1.8 or earlier.


Installation
------------

### The script itself

The ["slack.sh" script](https://github.com/ericoc/zabbix-slack-alertscript/raw/master/slack.sh) needs to be placed in the "AlertScriptsPath" directory that is specified within the Zabbix servers' configuration file (zabbix_server.conf) and must be executable by the user (usually "zabbix") running the zabbix_server binary on the Zabbix server before restarting the Zabbix server software:

	[root@zabbix ~]# grep AlertScriptsPath /etc/zabbix/zabbix_server.conf
	### Option: AlertScriptsPath
	AlertScriptsPath=/usr/local/share/zabbix/alertscripts

	[root@zabbix ~]# ls -lh /usr/local/share/zabbix/alertscripts/slack.sh
	-rwxr-xr-x 1 root root 1.4K Dec 27 13:48 /usr/local/share/zabbix/alertscripts/slack.sh

Feel free to edit the variables at the top of the script while making sure that you specify an existing channel and your correct ".slack.com" sub-domain:

	# Slack sub-domain name (without '.slack.com'), user name, and the channel to send the message to
	subdomain='myorgname'
	username='Zabbix'
	channel='#alerts'


### At Slack.com

An incoming web-hook integration must be created within your Slack.com account which can be done at https://my.slack.com/services/new/incoming-webhook . After selecting which channel to post the notifications to, set the url variable on line 7 to the "Webhook URL".


### Within the Zabbix web interface

When logged in to the Zabbix servers web interface as a user with super-administrator privileges, click the "Create media type" button on the "Media types" sub-tab of the "Administration" tab.

You need to create a media type with the name "Slack", type of "Script", script name of "slack.sh" that is enabled like so:

![Zabbix Media Type](http://pictures.ericoc.com/github/zabbix-mediatype.png "Zabbix Media Type")

Then, create a "Slack" user on the "Users" sub-tab of the "Administration" tab within the Zabbix servers web interface and specify this users "Media" as the "Slack" media type that was just created.

Finally, an action can then be created on the "Actions" sub-tab of the "Configuration" tab within the Zabbix servers web interface to notify the Zabbix "Slack" user ensuring that the "Subject" is "PROBLEM" for "Default message" and "RECOVERY" should you choose to send a "Recovery message".

Keeping the messages short is probably a good idea - use something such as "{TRIGGER.STATUS} ::: {HOST.NAME1} ::: {TRIGGER.NAME})" for the contents of each message.


More Information
----------------
 * [Slack incoming web-hook functionality](https://my.slack.com/services/new/incoming-webhook)
 * [Zabbix (2.2) custom alertscripts documentation](https://www.zabbix.com/documentation/2.2/manual/config/notifications/media/script)
 * [Zabbix (2.4) custom alertscripts documentation](https://www.zabbix.com/documentation/2.4/manual/config/notifications/media/script)