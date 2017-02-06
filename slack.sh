#!/bin/bash

# Slack incoming web-hook URL and user name, https://my.slack.com/services/new/incoming-webhook/'
url='CHANGEME'         # example: https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
username='Zabbix'

fallback="fallback message"
pretext="pretext message"

## Values received by this script:
# To = $1 (Slack channel or user to send the message to, specified in the Zabbix web interface; "@username" or "#channel")
# Subject = $2 (usually either PROBLEM or RECOVERY)
# Message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")

# Get the Slack channel or user ($1) and Zabbix subject ($2 - hopefully either PROBLEM or RECOVERY)
to="$1"

subject="${2//\"/\\\"}"

case "$subject" in
  OK*)
    emoji=':white_check_mark:'
    # Can either be one of 'good', 'warning', 'danger'}"
    color='good'
    ;;
  PROBLEM*)
    emoji=':frowning:'
    color='danger'
    ;;
  *)
    emoji=':ghost:'
    color='warning'
    ;;
esac

# The message that we want to send to Slack is the "subject" value ($2 / $subject - that we got earlier)
#  followed by the message that Zabbix actually sent us ($3)
message="${3//\"/\\\"}"

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload=$(cat <<EOF
{
  "attachments":[
  {
    "fallback":"${fallback}",
    "pretext":"${pretext}",
    "color":"${color}",
    "fields":[
    {
      "title":"${subject}",
      "value":"${message}",
      "short":false
    }
    ]
  }
  ]
}
EOF
)

/usr/bin/curl -m 5 -X POST \
  --data "${payload}" $url \
  -A 'zabbix-slack-alertscript / https://github.com/ericoc/zabbix-slack-alertscript'
