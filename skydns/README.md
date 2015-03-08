## Usage

    etcdctl set /skydns/local/deis/prod/eventstore/1 '{"host":"10.1.42.222","priority":20,"port":1113}'
    etcdctl set /skydns/local/deis/prod/eventstore/2 '{"host":"10.1.42.223","priority":20,"port":1113}'

    dig SRV eventstore.prod.deis.local

Returns

    20 100 1113 1.eventstore.prod.deis.local.
    20 100 1113 2.eventstore.prod.deis.local.