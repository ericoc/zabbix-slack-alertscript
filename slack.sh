#!/bin/bash

# Slack sub-domain name (without '.slack.com'), user name, the channel to send the message to, and the webhook URL
subdomain='myorgname'
username='Zabbix'
channel='#alerts'
url='https://hooks.slack.com/services/abc123/abc123/abc123'

## Values received by this script:
# Subject = $2 (usually contains either PROBLEM or OK)
# Message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")
# Get the Slack the Zabbix subject ($2 - hopefully either PROBLEM or OK)
subject="$2"

# The message that we want to send to Slack is the "subject" value ($2 / $subject - that we got earlier)
#  followed by the message that Zabbix actually sent us ($3)
message="${subject}: $3"

# Change message emoji depending on the subject - smile (OK), frowning (PROBLEM), or ghost (for everything else)

if [[ $subject == *"PROBLEM"* ]]
	then
	emoji=':frowning:'
elif [[ $subject == *"OK"* ]]
	then
	emoji=':smiling:'
else
	emoji=':ghost:'
fi

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={\"channel\": \"${channel}\", \"username\": \"${username}\", \"text\": \"${message}\", \"icon_emoji\": \"${emoji}\"}"
curl -m 5 --data "${payload}" "${url}"


