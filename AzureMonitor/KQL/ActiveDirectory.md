KQL quries

User logon details
Event
| where EventID == "4768"
| extend DateTime= TimeGenerated
| project  EventData,DateTime
| extend NewField=parse_xml(EventData)
| extend value=NewField.DataItem.EventData.Data
| extend Username = tostring(value.[0]["#text"])
| extend Ipaddress= tostring(value.[9]['#text'])
| extend Domain= tostring(value.[1]['#text'])
| where Username != 'MSOL_050fc29113fd'
| project Username,Ipaddress,Domain,DateTime

AD group changes

Event
| where EventID == "4728"
| extend DateTime= TimeGenerated
| project  EventData,DateTime
| extend NewField=parse_xml(EventData)
| extend value=NewField.DataItem.EventData.Data
| extend Username = tostring(value.[0]["#text"])
| extend AddedGroup = tostring(value.[2]["#text"])
| project Username,AddedGroup,DateTime
