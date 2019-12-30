job "traefik" {
    region = "global"
    datacenters = ["vagrant"]
    type = "system"

    priority = 90

    update {
        stagger      = "10s"
        max_parallel = 1
        auto_revert  = true
        auto_promote = true
        canary       = 1
    }

    group "traefik" {
        task "web" {

            driver = "docker"

            config {
                image = "traefik:v2.1"

                network_mode = "host"

                volumes = [
                    "local/traefik.yml:/etc/traefik/traefik.yml",
                ]
            }

            template {
            data = <<EOF
global:
    sendAnonymousUsage: false

entryPoints:
  http:
    address: :80
  https:
    address: :443

providers:
  file:
    filename: /etc/traefik/traefik.yml
    watch: true

  consulCatalog:
    refreshInterval: 1s
    exposedByDefault: false
    endpoint:
      address: http://127.0.0.1:8500

api:
  insecure: true
  dashboard: true

ping: {}

metrics:
  prometheus:
    addEntryPointsLabels: true
    addServicesLabels: true

log:
  level: INFO
  format: json
EOF
            destination = "local/traefik.yml"
        }

        service {
            name = "traefik"

            port = "api"

            check {
                name            = "alive"
                type            = "http"
                port            = "api"
                interval        = "10s"
                timeout         = "2s"
                protocol        = "http"
                path            = "/ping"
            }

            tags = [
                "nomad-client",
            ]
        }

        resources {
            cpu    = 200
            memory = 128
            network {
                mbits = 20
                port "http" {
                    static = 80
                }
                port "https" {
                    static = 443
                }
                port "api" {
                    static = 8080
                }
            }
        }
    }
  }
}