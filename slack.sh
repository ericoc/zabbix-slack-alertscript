#!/bin/bash

# Slack incoming web-hook URL and user name
url='CHANGEME'      # example: url='https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123'
username='Zabbix'

## Values received by this script:
# To = $1 / Slack channel or user to send the message to, specified in the Zabbix web interface; "@username" or "#channel"
# Subject = $2 / subject of the message sent by Zabbix; by default, it is usually something like "(Problem|Resolved): Lack of free swap space on Zabbix server"
# Message = $3 / message body sent by Zabbix; by default, it is usually approximately 4 lines detailing the specific trigger involved
# Alternate URL = $4 (optional) / alternative Slack.com web-hook URL to replace the above hard-coded one; useful when multiple groups have seperate Slack teams
# Proxy = $5 (optional) / proxy host including port (such as "example.com:8080")

# Get the user/channel ($1), subject ($2), and message ($3)
to="$1"
subject="$2"
message="$3"

# Change message emoji and notification color depending on the subject indicating whether it is a trigger going in to problem state or recovering
recoversub='^RECOVER(Y|ED)?$|^OK$|^Resolved.*'
problemsub='^PROBLEM.*|^Problem.*'

if [[ "$subject" =~ $recoversub ]]; then
    emoji=':smile:'
    color='#0C7BDC'
elif [[ "$subject" =~ $problemsub ]]; then
    emoji=':frowning:'
    color='#FFC20A'
else
    emoji=':question:'
    color='#CCCCCC'
fi

# Replace the above hard-coded Slack.com web-hook URL entirely, if one was passed via the optional 4th parameter
url=${4-$url}

# Use optional 5th parameter as proxy server for curl
proxy=${5-""}
if [[ "$proxy" != '' ]]; then
    proxy="-x $proxy"
fi

# Build JSON payload which will be HTTP POST'ed to the Slack.com web-hook URL
payload="payload={\"channel\": \"${to//\"/\\\"}\",  \
\"username\": \"${username//\"/\\\"}\", \
\"attachments\": [{\"fallback\": \"${subject//\"/\\\"}\", \"title\": \"${subject//\"/\\\"}\", \"text\": \"${message//\"/\\\"}\", \"color\": \"${color}\"}], \
\"icon_emoji\": \"${emoji}\"}"

# Execute the HTTP POST request of the payload to Slack via curl, storing stdout (the response body)
return=$(curl $proxy -sm 5 --data-urlencode "${payload}" $url -A 'zabbix-slack-alertscript / https://github.com/ericoc/zabbix-slack-alertscript')

# If the response body was not what was expected from Slack ("ok"), something went wrong so print the Slack error to stderr and exit with non-zero
if [[ "$return" != 'ok' ]]; then
    >&2 echo "$return"
    exit 1
fi
