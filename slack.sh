#!/bin/bash

# Slack sub-domain name (without '.slack.com'), user name, and the channel to send the message to
subdomain='myorgname'
username='Zabbix'
channel='#alerts'

## Values received by this script:
# To = $1 (Slack.com incoming web-hook token, specified in the Zabbix web interface)
# Subject = $2 (usually either PROBLEM or RECOVERY)
# Message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")

# Get the Slack incoming web-hook token ($1) and either PROBLEM or RECOVERY ($2) from Zabbix
token="$1"
status="$2"

# Switch emoji depending on status between smile (for RECOVERY) and frowning (for everything else, including PROBLEM)
if [ "$status" == 'RECOVERY' ]; then
    emoji=':smile:'
else
    emoji=':frowning:'
fi

# The message that we want to send to Slack is the "status" value ($2 / $status - that we got earlier)
#  followed by the message that Zabbix actually sent us ($3)
message="${status}: $3"

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={\"channel\": \"${channel}\", \"username\": \"${username}\", \"text\": \"${message}\", \"icon_emoji\": \"${emoji}\"}"
curl -m 5 --data "${payload}" "https://${subdomain}.slack.com/services/hooks/incoming-webhook?token=${token}"
