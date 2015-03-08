# EventStore Dockerfile

## Usage

``` bash
docker run --detach --entrypoint "/bin/bash" --name eventstore-data -v /var/lib/eventstore haaf/eventstore -c true
IP=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1) docker run -p $IP:1112:1112 -p $IP:1113:1113 -p $IP:2112:2112 -p $IP:2113:2113 --volumes-from eventstore-data -it haaf/eventstore --cluster-dns eventstore.prod.deis.local --cluster-gossip-port 2112

core@deis-01 ~ $ etcdctl rm --recursive /skydns/local/deis/prod/eventstore
(reverse-i-search)`': ^C
core@deis-01 ~ $ etcdctl set /skydns/local/deis/prod/eventstore/1 '{"host":"172.17.8.100","priority":20,"port":2112}'
{"host":"172.17.8.100","priority":20,"port":2112}
core@deis-01 ~ $ etcdctl set /skydns/local/deis/prod/eventstore/2 '{"host":"172.17.8.101","priority":20,"port":2112}'
{"host":"172.17.8.101","priority":20,"port":2112}
core@deis-01 ~ $ etcdctl set /skydns/local/deis/prod/eventstore/3 '{"host":"172.17.8.102","priority":20,"port":2112}'
{"host":"172.17.8.102","priority":20,"port":2112}
```

Or use API:

```
curl -XPUT http://127.0.0.1:4001/v2/keys/skydns/local/deis/prod/eventstore/1 -d value='{"host":"10.1.42.232","priority":20, "port":1113}'
```


Alternative to launch a single node. `-it` means to run in interactive mode and capture STDIN.

```
docker run -it -p 1112 -p 1113 -p 2112 -p 2113 -e CLUSTER_SIZE=1 --volumes-from eventstore-data -it haaf/eventstore
```

You should be able to resolve the service:

```
$ dig SRV eventstore.prod.deis.local
; <<>> DiG 9.9.5-3-Ubuntu <<>> SRV eventstore.prod.deis.local
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23658
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 3

;; QUESTION SECTION:
;eventstore.prod.deis.local.  IN  SRV

;; ANSWER SECTION:
eventstore.prod.deis.local. 3600 IN SRV 20 33 2112 3.eventstore.prod.deis.local.
FROM ubuntu
eventstore.prod.deis.local. 3600 IN SRV 20 33 2112 2.eventstore.prod.deis.local.
eventstore.prod.deis.local. 3600 IN SRV 20 33 2112 1.eventstore.prod.deis.local.

;; ADDITIONAL SECTION:
3.eventstore.prod.deis.local. 3600 IN A 172.17.8.102
2.eventstore.prod.deis.local. 3600 IN A 172.17.8.101
1.eventstore.prod.deis.local. 3600 IN A 172.17.8.100

;; Query time: 8 msec
;; SERVER: 10.1.42.1#53(10.1.42.1)
;; WHEN: Sun Mar 08 22:59:21 UTC 2015
;; MSG SIZE  rcvd: 242
```
