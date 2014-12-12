#!/bin/bash

# Slack sub-domain name (without '.slack.com'), user name, and the channel to send the message to
subdomain='myorgname'
username='Zabbix'
channel='#alerts'

## Values received by this script:
# To = $1 (Slack.com incoming web-hook token, specified in the Zabbix web interface)
# Subject = $2 (usually either PROBLEM or RECOVERY)
# Message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")

# Get the Slack incoming web-hook token ($1) and Zabbix subject ($2 - hopefully either PROBLEM or RECOVERY)
token="$1"
subject="$2"

# Change message emoji depending on the subject - smile (RECOVERY), frowning (PROBLEM), or ghost (for everything else)
if [ "$subject" == 'RECOVERY' ]; then
	emoji=':smile:'
elif [ "$subject" == 'PROBLEM' ]; then
	emoji=':frowning:'
else
	emoji=':ghost:'
fi

# The message that we want to send to Slack is the "subject" value ($2 / $subject - that we got earlier)
#  followed by the message that Zabbix actually sent us ($3)
message="${subject}: $3"

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={\"channel\": \"${channel}\", \"username\": \"${username}\", \"text\": \"${message}\", \"icon_emoji\": \"${emoji}\"}"
curl -m 5 --data "${payload}" "https://${subdomain}.slack.com/services/hooks/incoming-webhook?token=${token}"
