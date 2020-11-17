Log Analytics Queries

You need to convert the timestamp to human readable and assign a new colum:
Yourtablename_CL
| extend _datetime=unixtime_microseconds_todatetime(timestamp_d)
| sort by _datetime asc
| project _datetime, parser_s, Message