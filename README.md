# Auto-BOGONs Script for Mikrotik

Make your router grab the latest BOGONs list from https://www.team-cymru.com/

  - Paste the script into your router
  - Uncomment the line for the URL of the BOGON list you want
  - Put it on a schedule (NO MORE FREQUENT THAN 24 HOURS)
  - Optionally change the addressListName variable to your own BOGON address list (default is `AUTOBOGON`)
  - Create firewall rules to filter out BOGONs you don't want coming in from the WAN
