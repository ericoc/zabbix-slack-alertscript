Zabbix Slack AlertScript
========================


About
-----
This is simply a Bash script that uses the custom alert script functionality within [Zabbix](http://www.zabbix.com/) along with the incoming web-hook feature of [Slack](https://slack.com/) that I got a chance to write since I could not find any already existing/similar scripts.

#### Versions
This works with Zabbix 1.8.x or greater - including 2.2, 2.4 and 3.x!

#### Huge thanks and appreciation to:

* [Paul Reeves](https://github.com/pdareeves/) for the hint that Slack changed their API/URLs!
* [Igor Shishkin](https://github.com/teran) for the ability to message users as well as channels!
* Leslie at AspirationHosting for confirming that this script works on Zabbix 1.8.2!
* [Hiromu Yakura](https://github.com/hiromu) for escaping quotation marks in the fields received from Zabbix to have valid JSON!
* [Devlin Gonçalves](https://github.com/devlinrcg), [tkdywc](https://github.com/tkdywc), [damaarten](https://github.com/damaarten), and [lunchables](https://github.com/lunchables) for Zabbix 3.0 AlertScript documentation, suggestions and testing!

Installation
------------

### The script itself

This [`slack.sh` script](https://github.com/ericoc/zabbix-slack-alertscript/raw/master/slack.sh) needs to be placed in the `AlertScriptsPath` directory that is specified within the Zabbix servers' configuration file (`zabbix_server.conf`) and must be executable by the user running the zabbix_server binary (usually "zabbix") on the Zabbix server before restarting the Zabbix server software:

	[root@zabbix ~]# grep AlertScriptsPath /etc/zabbix/zabbix_server.conf
	### Option: AlertScriptsPath
	AlertScriptsPath=/usr/local/share/zabbix/alertscripts

	[root@zabbix ~]# ls -lh /usr/local/share/zabbix/alertscripts/slack.sh
	-rwxr-xr-x 1 root root 1.4K Dec 27 13:48 /usr/local/share/zabbix/alertscripts/slack.sh


Configuration
-------------

### Slack.com web-hook

An incoming web-hook integration must be created within your Slack.com account which can be done at [https://my.slack.com/services/new/incoming-webhook](https://my.slack.com/services/new/incoming-webhook) as shown below:

![Slack.com Incoming Web-hook Integration](https://pictures.ericoc.com/github/newapi/slack-integration.png "Slack.com Incoming Web-hook Integration")

Given the above screenshot, the incoming web-hook URL would be:

	https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
	
Make sure that you specify your correct Slack.com incoming web-hook URL and feel free to edit the sender user name at the top of the script:

	# Slack incoming web-hook URL and user name
	url='https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123'
	username='Zabbix'


### Within the Zabbix web interface

When logged in to the Zabbix servers web interface with super-administrator privileges, navigate to the "Administration" tab, access the "Media Types" sub-tab, and click the "Create media type" button.

You need to create a media type as follows:

* **Name**: Slack
* **Type**: Script
* **Script name**: slack.sh

...and ensure that it is enabled before clicking "Save", like so:

![Zabbix Media Type](https://pictures.ericoc.com/github/zabbix-mediatype.png "Zabbix Media Type")

However, on Zabbix 3.x and greater, media types are configured slightly differently and you must explicity define the parameters sent to the `slack.sh` script. On Zabbix 3.x, three script parameters should be added as follows:

* `{ALERT.SENDTO}`
* `{ALERT.SUBJECT}`
* `{ALERT.MESSAGE}`

...as shown here:

![Zabbix 3.x Media Type](https://pictures.ericoc.com/github/zabbix3-mediatype.png "Zabbix 3.x Media Type")

Then, create a "Slack" user on the "Users" sub-tab of the "Administration" tab within the Zabbix servers web interface and specify this users "Media" as the "Slack" media type that was just created with the Slack.com channel ("#alerts" in the example) or user name (such as "@ericoc") that you want messages to go to in the "Send to" field as seen below:

![Zabbix User](https://pictures.ericoc.com/github/zabbix-user.png "Zabbix User")

Finally, an action can then be created on the "Actions" sub-tab of the "Configuration" tab within the Zabbix servers web interface to notify the Zabbix "Slack" user ensuring that the "Subject" is "PROBLEM" for "Default message" and "RECOVERY" should you choose to send a "Recovery message".

Keeping the messages short is probably a good idea; use something such as the following for the contents of each message:

	{TRIGGER.NAME} - {HOSTNAME} ({IPADDRESS})

Additionally, you can have multiple different Zabbix users each with "Slack" media types that notify unique Slack users or channels upon different triggered Zabbix actions.

Zabbix 3.0+: as of [dmaarten](https://github.com/damaarten "damaarten") In addition, on Zabbix version 3.0+, you need to specify 3 script parameters when creating the new media:

Script parameters:

	{ALERT.SENDTO}
	{ALERT.SUBJECT}
	{ALERT.MESSAGE}



Testing
-------
Assuming that you have set a valid Slack web-hook URL within your "slack.sh" file, you can execute the script manually (as opposed to via Zabbix) from Bash on a terminal:

	$ bash slack.sh '@ericoc' PROBLEM 'Oh no! Something is wrong!'

Alerting a specific user name results in the message actually coming from the "slackbot" user using a sort-of "spoofed" user name within the message. A channel alert is sent as you would normally expect from whatever user name you specify in "slack.sh":

![Slack Testing](https://pictures.ericoc.com/github/slack-example.png "Slack Testing")


More Information
----------------
* [Slack incoming web-hook functionality](https://my.slack.com/services/new/incoming-webhook)
* [Zabbix 2.2 custom alertscripts documentation](https://www.zabbix.com/documentation/2.2/manual/config/notifications/media/script)
* [Zabbix 2.4 custom alertscripts documentation](https://www.zabbix.com/documentation/2.4/manual/config/notifications/media/script)
* [Zabbix 3.x custom alertscripts documentation](https://www.zabbix.com/documentation/3.0/manual/config/notifications/media/script)
