job "sherpa" {
    region = "global"

    datacenters = ["vagrant"]

    type = "service"
    // type = "system"

    priority = 90

    group "sherpa" {
        count = 1

        task "web" {
            driver = "docker"

            config {
                image = "jrasell/sherpa:latest"
                
                // port_map {
                //     http = 8000
                // }

                command = "server"

                // network_mode = "host"
            }

            service {
                name = "sherpa"

                port = "http"

                tags = [
                    "traefik.enable=true",
                    "traefik.http.middlewares.sherpa-prefix-strip.stripprefix.prefixes=/sherpa/",
                    "traefik.http.routers.sherpa.middlewares=sherpa-prefix-strip@consulcatalog",
                    "traefik.http.routers.sherpa.rule=HostRegexp(`{domain:sherpa\\.192\\-168\\-50\\-\\d+\\.nip\\.io}`) || (HostRegexp(`{domain:.*}`) && PathPrefix(`/sherpa/`))",
                    "traefik.http.routers.sherpa.entrypoints=http",
                ]
            }

            env {
                "SHERPA_BIND_ADDR" = "0.0.0.0"
                "SHERPA_BIND_PORT" = "${NOMAD_HOST_PORT_http}"
                "SHERPA_UI" = "true"
                "SHERPA_AUTOSCALER_ENABLED" = "true"
                "SHERPA_LOG_LEVEL" = "debug"
                "SHERPA_STORAGE_CONSUL_ENABLED" = "true"
                "SHERPA_CLUSTER_ADVERTISE_ADDR" = "http://${NOMAD_IP_http}:${NOMAD_HOST_PORT_http}"
                "SHERPA_POLICY_ENGINE_API_ENABLED" = "false"
                "SHERPA_POLICY_ENGINE_NOMAD_META_ENABLED" = "true"
                "SHERPA_TELEMETRY_PROMETHEUS" = "true"
                "SHERPA_CLUSTER_NAME" = "vagrant"
                "NOMAD_ADDR" = "http://${NOMAD_IP_http}:4646"
                "CONSUL_HTTP_ADDR" = "http://${NOMAD_IP_http}:8500"
            }

            resources {
                cpu = 200
                memory = 100 # MB

                network {
                    mbits = 10
                    port "http" {}
                }
            }
        }
    }
}
