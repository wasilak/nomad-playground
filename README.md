#### Nomad playground

1. vagrant environment (server, clients, lb)
2. docker test image
3. `hello` job (deployment)
4. fabio lb

* starting cluster: `vagrant up`
* deploying `hello` app: `nomad run -address=http://192.168.50.4:4646 hello.nomad`
* test app on: http://192.168.50.3:9999/hello/
* LB gui: http://192.168.50.3:9998/
* hashi-ui: http://192.168.50.4:3000
* consul ui: 192.168.50.4:8500