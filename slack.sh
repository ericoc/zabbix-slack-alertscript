#!/bin/bash

# Slack incoming web-hook URL and user name
url='CHANGEME'		# example: https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
username='Zabbix'

## Values received by this script:
# To = $1 (Slack channel or user to send the message to, specified in the Zabbix web interface; "@username" or "#channel")
# Subject = $2 (usually either PROBLEM or RECOVERY)
# Message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")

# Get the Slack channel or user ($1) and Zabbix subject ($2 - hopefully either PROBLEM or RECOVERY)
to="$1"
subject="$2"

# Change message emoji depending on the subject - smile (RECOVERY), frowning (PROBLEM), or ghost (for everything else)
recoversub='^RECOVER(Y|ED)?$'
if [[ "$subject" =~ ${recoversub} ]]; then
	emoji=':smile:'
elif [ "$subject" == 'PROBLEM' ]; then
	emoji=':frowning:'
else
	emoji=':ghost:'
fi

# Set color of the posted message
# You must insert "Severity: {TRIGGER.SEVERITY}" into your Zabbix message body for this to work
if [[ "$subject" =~ 'OK' ]]; then
    color="#36a64f"
elif [[ "$3" =~ 'Severity: Warning' ]]; then
    color="#FFC859"
elif [[ "$3" =~ 'Severity: Average' ]]; then
    color="#FFA059"
elif [[ "$3" =~ 'Severity: High' ]]; then
    color="#E97659"
elif [[ "$3" =~ 'Severity: Disaster' ]]; then
    color="#E45959"
elif [[ "$3" =~ 'Severity: Information' ]]; then
    color="#7499FF"
fi

# The message that we want to send to Slack is the "subject" value ($2 / $subject - that we got earlier)
#  followed by the message that Zabbix actually sent us ($3)
message="${subject}\n$3"

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={\"channel\": \"${to//\"/\\\"}\", \"username\": \"${username//\"/\\\"}\", \"icon_emoji\": \"${emoji}\", \"attachments\": [{  \"text\": \"${message//\"/\\\"} \", \"color\": \"${color}\" }] }"

curl -m 5 --data-urlencode "${payload}" $url -A 'zabbix-slack-alertscript / https://github.com/ericoc/zabbix-slack-alertscript'
