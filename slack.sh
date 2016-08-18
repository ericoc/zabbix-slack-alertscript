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

# Insert an emoji at the beginning of message that reflects the severity of the trigger
# You must insert "Severity: {TRIGGER.SEVERITY}" into your Zabbix message body for this to work
if [[ "$subject" =~ 'OK' ]]; then
	severity_emoji=':white_check_mark: '
elif [[ "$3" =~ 'Severity: Warning' ]]; then
	severity_emoji=':warning: '
elif [[ "$3" =~ 'Severity: Average' ]]; then
	severity_emoji=':warning: '
elif [[ "$3" =~ 'Severity: High' ]]; then
	severity_emoji=':exclamation: '
elif [[ "$3" =~ 'Severity: Disaster' ]]; then
	severity_emoji=':exclamation: '
elif [[ "$3" =~ 'Severity: Information' ]]; then
	severity_emoji=':information_source: '
fi

# The message that we want to send to Slack is the severity emoji followed by "subject" value ($2 / $subject 
# that we got earlier), followed by the message that Zabbix actually sent us ($3)
message="${severity_emoji}${subject}\n$3"

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={\"channel\": \"${to//\"/\\\"}\", \"username\": \"${username//\"/\\\"}\", \"text\": \"${message//\"/\\\"}\", \"icon_emoji\": \"${emoji}\"}"
curl -m 5 --data-urlencode "${payload}" $url -A 'zabbix-slack-alertscript / https://github.com/ericoc/zabbix-slack-alertscript'
