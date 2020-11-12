#!/bin/sh

#############################################################
# Simple shell script to run log2timeline across an image   #
# and output the file to json that can be sent to an azure  #
# container and blob for ingestion into log analytics.      #
# Created by: Shanna.Daly@ParaFlare.com                     #
#############################################################

## Collect and parse mft
log2timeline.py --artifact-filters NTFSMFTFiles --parser mft --partitions all --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 -d --log-file=/data/plaso/log2timeline.log /data/plaso/output-mft.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/plaso/output-mft.json /data/plaso/output-mft.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/plaso/output-mft.json; echo "]") > /data/plaso/array-mft.json && 
/bin/sed -i ':a;N;$!ba;s/,]/]/g' /data/plaso/array-mft.json &&

## Collect registry artefacts into output.plaso
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers "winreg" --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/plaso/log2timeline.log /data/plaso/output-winreg.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/plaso/output-winreg.json /data/plaso/output-winreg.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/plaso/output-winreg.json; echo "]") > /data/plaso/array-winreg.json && 
/bin/sed -i ':a;N;$!ba;s/,]/]/g' /data/plaso/array-winreg.json &&

## Collect win7 parser without win_gen artefacts into output.plaso
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers "amcache,custom_destinations,esedb/file_history,olecf/olecf_automatic_destinations,recycle_bin" --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/plaso/log2timeline.log /data/plaso/output-win7.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/plaso/output-win7.json /data/plaso/output-win7.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/plaso/output-win7.json; echo "]") > /data/plaso/array-win7.json && 
/bin/sed -i ':a;N;$!ba;s/,]/]/g' /data/plaso/array-win7.json &&

#### Collect browser artefacts into output.plaso ####
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers "webhist" --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/plaso/log2timeline.log /data/plaso/output-webhist.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/plaso/output-webhist.json /data/plaso/output-webhist.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/plaso/output-webhist.json; echo "]") > /data/plaso/array-webhist.json && 
/bin/sed -i ':a;N;$!ba;s/,]/]/g' /data/plaso/array-webhist.json &&

## Collect win_gen parser without win_gen artefacts into output.plaso
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers "bencode, czip/oxml, esedb, filestat, gdrive_synclog, lnk, mcafee_protection, olecf, pe, prefetch, setupapi, sccm, skydrive_log, skydrive_log_old, sqlite/google_drive, sqlite/skype, symantec_scanlog, usnjrnl, winfirewall, winjob" --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/plaso/log2timeline.log /data/plaso/output-win_gen.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/plaso/output-win_gen.json /data/plaso/output-win_gen.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/plaso/output-win_gen.json; echo "]") > /data/plaso/array-win_gen.json &&
/bin/sed -i ':a;N;$!ba;s/,]/]/g' /data/plaso/array-win_gen.json &&

## Collect and parse eventlogs - evtx
log2timeline.py --artifact-filters WindowsEventLogs --parsers "winevtx" --partitions all --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/plaso/log2timeline.log /data/plaso/output-evtx.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/plaso/output-evtx.json /data/plaso/output-evtx.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/plaso/output-evtx.json; echo "]") > /data/plaso/array-evtx.json && 
/bin/sed -i ':a;N;$!ba;s/,]/]/g' /data/plaso/array-evtx.json