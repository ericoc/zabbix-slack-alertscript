Zabbix Slack AlertScript
========================


About
-----
This is simply a Bash script that uses the custom alert script functionality within [Zabbix](http://www.zabbix.com/) along with the incoming web-hook feature of [Slack](https://slack.com/) that I got a chance to write for my employer since I could not find any already existing/similar scripts. This most likely only works with Zabbix 2.0 or greater - it has not been tested with Zabbix 1.8 or earlier.


Installation
------------
The ["slack.sh" script](https://github.com/ericoc/zabbix-slack-alertscript/raw/master/slack.sh) needs to be placed in the "AlertScriptsPath" directory that is specified within the Zabbix servers' configuration file (zabbix_server.conf) and must be executable by the user (usually "zabbix") running the zabbix_server binary on the Zabbix server before restarting the Zabbix server software:

	[root@zabbix ~]# grep AlertScriptsPath /etc/zabbix/zabbix_server.conf
	### Option: AlertScriptsPath
	AlertScriptsPath=/usr/local/share/zabbix/alertscripts

	[root@zabbix ~]# ls -lh /usr/local/share/zabbix/alertscripts/slack.sh
	-rwxr-xr-x 1 root root 1.4K Dec 27 13:48 /usr/local/share/zabbix/alertscripts/slack.sh

Feel free to edit the variables at the top of the script while making sure that you specify an existing channel and your correct .slack.com sub-domain:

	# Slack sub-domain name (without '.slack.com'), user name, and the channel to send the message to
	subdomain='myorgname'
	username='Zabbix'
	channel='#alerts'

An incoming web-hook integration must be created within your Slack.com account which can be done at https://slack.com/services/new/incoming-webhook as shown below:

![Slack.com Incoming Web-hook Integration](http://pictures.ericoc.com/slack-integration.png "Slack.com Incoming Web-hook Integration")

Given the above screenshot, the Slack incoming web-hook token would be "abc123BCA321etc".

When logged in to the Zabbix servers web interface as a user with super-administrator privileges, click the "Create media type" button on the "Media types" sub-tab of the "Administration" tab.
You need to create a media type with the name "Slack", type of "Script", script name of "slack.sh" that is enabled like so:

![Zabbix Media Type](http://pictures.ericoc.com/zabbix-mediatype.png "Zabbix Media Type")

Then, create a "Slack" user on the "Users" sub-tab of the "Administration" tab within the Zabbix servers web interface and specify this users "Media" as the "Slack" media type that was just created with the Slack.com incoming web-hook token in the "Send to" field as seen below:

![Zabbix User](http://pictures.ericoc.com/zabbix-user.png "Zabbix User")


TODO: more screenshots/further explanation of the set-up on both slack.com and within the zabbix web interface


More Information
----------------
 * [Zabbix (2.2) custom alertscripts documentation](https://www.zabbix.com/documentation/2.2/manual/config/notifications/media/script)
