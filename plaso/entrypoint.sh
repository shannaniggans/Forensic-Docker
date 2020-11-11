#!/bin/sh
yes | cp -rf /data/json_line.py /usr/lib/python3/dist-packages/plaso/output/json_line.py &&

## Collect and parse eventlogs - evtx
#log2timeline.py --artifact-filters WindowsEventLogs --parser winevtx --partitions all --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 /data/test/output-evtx.plaso /data/*flat.vmdk &&

##adjust t he timeframe you want to analyse
#psort.py -o json_line -w /data/test/output-evtx.json /data/test/output-evtx.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&

## To do: make the brackets insert 1st character and last.
#(echo -n "["; cat /data/test/output-evtx.json; echo -n "]") >/data/test/evtx.json &&

## Collect and parse mft
#log2timeline.py --artifact-filters NTFSMFTFiles --parser mft --partitions all --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 /data/test/output-mft.plaso /data/*flat.vmdk &&

#psort.py -o json_line -w /data/test/output-mft.json /data/test/output-mft.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&

## To do: make the brackets insert 1st character and last.
#(echo -n "["; cat /data/test/output-mft.json; echo -n "]") >/data/test/mft.json &&

## Collect registry artefacts into output.plaso
#log2timeline.py --artifact-filters WindowsRegistryFilesAndTransactionLogs --partitions all --parser=winreg --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 /data/test/output-winreg.plaso /data/*flat.vmdk &&

psort.py -o json_line -w /data/test/output-winreg.json /data/test/output-winreg.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&

## To do: make the brackets insert 1st character and last.
(echo "["; cat /data/test/output-winreg.json; echo "]") >/data/test/winreg.json &&
sed ':a;N;$!ba;s/,]/]/g' /data/test/winreg.json > formatted-winreg.json &&

## Collect win7 parser without win_gen artefacts into output.plaso
# To do, create my own data/presets.yaml entry
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers=win7,!win_gen --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 /data/test/output-win7.plaso /data/*flat.vmdk &&

psort.py -o json_line -w /data/test/output-win7.json /data/test/output-win7.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&

## To do: make the brackets insert 1st character and last.
(echo -n "["; cat /data/test/output-win7.json; echo -n "]") >/data/test/win7.json &&

## Collect win_gen parser without win_gen artefacts into output.plaso
log2timeline.py --file-filter filter_windows.yaml --partitions all --parser=win_gen,!winreg --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 /data/test/output-win_gen.plaso /data/*flat.vmdk &&

psort.py -o json_line -w /data/test/output-win_gen.json /data/test/output-win_gen.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&

## To do: make the brackets insert 1st character and last.
(echo -n "["; cat /data/test/output-win_gen.json; echo -n "]") >/data/test/win_gen.json