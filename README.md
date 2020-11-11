# Docker Forensic

## Sample Run

Enter tool directory

```
cd bulkextractor
```

Build Docker Image

```
docker build -t bulkextractor .
```

Run Docker Image

```
docker run --name bulkextractor -d -v "Shared Directory":/out bulkextractor
```

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
