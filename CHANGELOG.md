# [0.1.0] - 05/06/2023
- Created initial version of the plugin
    - Using `avro` gem to properly handle AVRO
    - Using `filewatcher` gem to handle path wildcards, so we don't need to restart Logstash every time there is a new AVRO file to process 
    - Doesn't support:
        - multi-threading
        - AVRO compression
        - would only read files once (so no appends to files please)
