job "hello-world-python-fastapi" {
    region = "global"

    datacenters = ["vagrant"]

    type = "service"

    group "application" {
        count = 4

        meta {
            sherpa_enabled                               = "true"
            sherpa_cooldown                              = "30"
            sherpa_max_count                             = "10"
            sherpa_min_count                             = "1"
            sherpa_scale_in_count                        = "1"
            sherpa_scale_out_count                       = "1"
            sherpa_scale_out_cpu_percentage_threshold    = "50"
            sherpa_scale_out_memory_percentage_threshold = "50"
            sherpa_scale_in_cpu_percentage_threshold     = "20"
            sherpa_scale_in_memory_percentage_threshold  = "20"
        }

        task "web" {
            driver = "docker"

            config {
                image = "wasilak/fastapi-hello-world:latest"
                port_map {
                    http = 5000
                }
            }

            service {
                name = "python-fastapi-hello-world"

                port = "http"

                tags = [
                    "traefik.enable=true",
                    "traefik.http.routers.python-fastapi-hello-world.middlewares=python-fastapi-hello-world-prefix-strip@consulcatalog",
                    "traefik.http.routers.python-fastapi-hello-world.rule=HostRegexp(`{domain:.*}`) && PathPrefix(`/hello-world/python-fastapi`)",
                    "traefik.http.middlewares.python-fastapi-hello-world-prefix-strip.stripprefix.prefixes=/hello-world/python-fastapi",
                    "traefik.http.routers.python-fastapi-hello-world.entrypoints=http",
                ]
            }

            env {
            }

            resources {
                cpu = 300
                memory = 100 # MB

                network {
                    mbits = 10
                    port "http" {}
                }
            }
        }
    }
}
