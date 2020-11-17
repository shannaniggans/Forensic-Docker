## To run plaso
```
git clone --recursive https://github.com/shannaniggans/Forensic-Docker.git
cd Forensic-Docker/plaso
cp json_line.py <image file location folder>
vi entrypoint.sh
```
Adjust the time range in the psort lines to suit your timeframe required.
```
docker build -t plaso2la .
docker run -ti <image file location folder>/:/data/ plaso2la
```
NOTE:
1. entrypoint.sh is looking for vmdk files at the moment
2. The psort timeframe needs to be adjusted in entrypoint.sh before running
3. json_line has been adjusted to use a ',' instead of '\n' to break events
4. The error "standard_init_linux.go:211: exec user process caused "no such file or directory"" is deceptive, it means that you need to use dos2unix on the entrypoint file.


## Log Analytics Queries

You need to convert the timestamp to human readable and assign a new colum:
```
Yourtablename_CL
| extend _datetime=unixtime_microseconds_todatetime(timestamp_d)
| sort by _datetime asc
| project _datetime, parser_s, Message
```