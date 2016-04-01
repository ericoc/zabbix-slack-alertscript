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
if [[ "$subject" =~ RECOVERY* ]]; then
  color="good"
  emoji=':suspect:'
elif [[ "$subject" =~ PROBLEM* ]]; then
  if [[ "$subject" =~ Warning* ]]; then
    color="warning"
    emoji=':goberserk:'
  elif [[ "$subject" =~ Average* ]]; then
    color="#d87047"
    emoji=':rage4:'
  elif [[ "$subject" =~ High* ]]; then
    color="danger"
    emoji=':feelsgood:'
  elif [[ "$subject" =~ Disaster* ]]; then
    color="#000000"
    emoji=':finnadie:'
  else
    color="#0080ff"
    emoji=':rage3:'
  fi
else
  color="warning"
  emoji=':godmode:'
fi

# The message that we want to send to Slack is the "subject" value ($2 / $subject - that we got earlier)
#  followed by the message that Zabbix actually sent us ($3)
message="$3"

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={\"channel\": \"${to}\", \"username\": \"${username}\", \"icon_emoji\": \"${emoji}\", \"attachments\":[{\"color\": \"${color}\", \"fallback\": \"${message}\", \"fields\":[{\"title\":\"${subject}\", \"value\": \"${message}\"}]}]}"

curl -m 5 --data-urlencode "${payload}" $url

