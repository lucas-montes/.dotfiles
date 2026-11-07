#!/bin/sh
# waybar custom/agenda module: fold maia's GET /agenda into waybar's
# custom-module JSON protocol ({"text","tooltip","class"}).
# See maia's server/context/waybar-agenda.md for the endpoint contract.

KEY=$(jq -r .api_key /etc/maia/config.json 2>/dev/null)
if [ -z "$KEY" ] || [ "$KEY" = "null" ]; then
  echo '{"text": "⚠ maia", "tooltip": "cannot read api key from /etc/maia/config.json", "class": "overdue"}'
  exit 0
fi

AGENDA=$(curl -s -m 5 -H "Authorization: Bearer $KEY" http://127.0.0.1:3030/agenda)
if [ -z "$AGENDA" ]; then
  echo '{"text": "⚠ maia", "tooltip": "GET /agenda failed (server down?)", "class": "overdue"}'
  exit 0
fi

echo "$AGENDA" | jq -c '
  def minutes_label($m): ($m / 60 | floor | tostring) + ":" + (($m % 60) | tostring | if length < 2 then "0" + . else . end);
  (.overdue | length) as $od |
  (.dueToday | length) as $dt |
  if $od > 0 then
    {text: "⚠ \($od) overdue", tooltip: ([.overdue[].title] | join("\n")), class: "overdue"}
  elif $dt > 0 then
    {text: "📋 \($dt) due today", tooltip: ([.dueToday[].title] | join("\n")), class: "due-today"}
  elif .nextMeeting then
    {text: "📅 " + .nextMeeting.title + " " + minutes_label(.nextMeeting.startTimeMinutes), tooltip: .nextMeeting.title, class: "meeting"}
  else
    {text: "✓ clear", tooltip: "Nothing due", class: "clear"}
  end'
