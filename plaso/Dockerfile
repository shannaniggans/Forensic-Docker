FROM log2timeline/plaso

COPY entrypoint.sh /entrypoint.sh

COPY json_line.py /usr/lib/python3/dist-packages/plaso/output/json_line.py

ENTRYPOINT ["/entrypoint.sh"]