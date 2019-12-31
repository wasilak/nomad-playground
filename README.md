#### Nomad playground

1. [virtualbox](https://www.virtualbox.org) based environment set up with [vagrant](https://www.vagrantup.com) environment (server, clients)
2. [VMs box](https://app.vagrantup.com/wasilak/boxes/amazon-linux-2) based on Amazon Linux 2
3. [saltstack](https://www.saltstack.com) provisioning
4. test jobs:
   * python ([flask](http://flask.palletsprojects.com/en/1.1.x/))
   * python ([fastapi](https://fastapi.tiangolo.com))
   * go
5. [traefik 2.x](https://docs.traefik.io) as load balancer
6. [nomad](https://www.nomadproject.io) orchestrator
7. [sherpa](https://github.com/jrasell/sherpa) (nomad job scaler)
8. [consul](https://www.consul.io) as service discovery

* starting cluster: `make`:
  * spins up environment (servers, clients)
  * deploys load balancer
  * deploys sherpa
  * deploys test apps
* apps re-deployment: `make deployment`
* cleanup: `make clean`
* test apps addresses:
  * <http://192-168-50-31.nip.io/hello-world/python-flask/>
  * <http://192-168-50-31.nip.io/hello-world/python-fastapi/>
  * <http://192-168-50-31.nip.io/hello-world/go/>
* Traefik ui: <http://192-168-50-31.nip.io:8080>
* consul ui: <http://192-168-50-11.nip.io:8500>
* nomad ui: <http://192-168-50-11.nip.io:4646>
