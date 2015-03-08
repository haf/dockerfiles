# EventStore Dockerfile

Usage:

``` bash
docker run --detach --entrypoint "/bin/bash" --name eventstore-data -v /var/lib/eventstore haaf/eventstore -c true
docker run -it -p 1112 -p 1113 -p 2112 -p 2113 -e CLUSTER_SIZE=1 --volumes-from eventstore-data -it haaf/eventstore
```
