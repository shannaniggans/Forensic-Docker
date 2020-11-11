#!/bin/sh

#############################################################
# Simple shell script to run log2timeline across an image   #
# and output the file to json that can be sent to an azure  #
# container and blob for ingestion into log analytics.      #
# Created by: Shanna.Daly@ParaFlare.com                     #
#############################################################

## Collect and parse mft
log2timeline.py --artifact-filters NTFSMFTFiles --parser mft --partitions all --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/test/log2timeline.log /data/test/output-mft.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/test/output-mft.json /data/test/output-mft.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/test/output-mft.json; echo "]") > array-mft.json && 
/usr/bin/sed -in ':a;N;$!ba;s/,]/]/g' /data/test/output-mft.json &&

## Collect registry artefacts into output.plaso
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers "winreg" --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/test/log2timeline.log /data/test/output-winreg.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/test/output-winreg.json /data/test/output-winreg.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/test/output-winreg.json; echo "]") > array-winreg.json && 
/usr/bin/sed -in ':a;N;$!ba;s/,]/]/g' /data/test/output-winreg.json &&

## Collect win7 parser without win_gen artefacts into output.plaso
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers "amcache,custom_destinations,esedb/file_history,olecf/olecf_automatic_destinations,recycle_bin" --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/test/log2timeline.log /data/test/output-win7.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/test/output-win7.json /data/test/output-win7.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/test/output-win7.json; echo "]") > array-win7.json && 
/usr/bin/sedsed -in ':a;N;$!ba;s/,]/]/g' /data/test/output-win7.json &&

#### Collect browser artefacts into output.plaso ####
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers "webhist" --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/test/log2timeline.log /data/test/output-webhist.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/test/output-webhist.json /data/test/output-webhist.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/test/output-webhist.json; echo "]") > array-webhist.json && 
/usr/bin/sedsed -in ':a;N;$!ba;s/,]/]/g' /data/test/output-webhist.json &&

## Collect win_gen parser without win_gen artefacts into output.plaso
log2timeline.py --file-filter filter_windows.yaml --partitions all --parsers "bencode, czip/oxml, esedb, filestat, gdrive_synclog, lnk, mcafee_protection, olecf, pe, prefetch, setupapi, sccm, skydrive_log, skydrive_log_old, sqlite/google_drive, sqlite/skype, symantec_scanlog, usnjrnl, winfirewall, winjob" --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --log-file=/data/test/log2timeline.log /data/test/output-win_gen.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/test/output-win_gen.json /data/test/output-win_gen.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/test/output-win_gen.json; echo "]") > array-win_gen.json &&
/usr/bin/sedsed -i ':a;N;$!ba;s/,]/]/g' /data/test/output-win_gen.json &&

## Collect and parse eventlogs - evtx
log2timeline.py --artifact-filters WindowsEventLogs --parsers "winevtx" --partitions all --no_vss --workers ${WORKER_NUM:-2} --buffer_size 2048M --profiling_sample_rate 10000 --profile --profiling-type=processing --profiling-directory=profile --log-file=/data/test/log2timeline.log /data/test/output-evtx.plaso /data/*flat.vmdk &&
psort.py -o json_line -w /data/test/output-evtx.json /data/test/output-evtx.plaso "date > '2020-11-03 20:00:00' AND date < '2020-11-05 00:00:00'" &&
(echo "["; cat /data/test/output-evtx.json; echo "]") > array-evtx.json && 
/usr/bin/sed -in ':a;N;$!ba;s/,]/]/g' data/test/output-evtx.json

