{% set cluster = pillar.get('cluster') %}
data_dir  = "/var/lib/nomad"

bind_addr = "0.0.0.0" # the default

datacenter = "vagrant"

advertise {
  # Defaults to the first private IP address.
  http = "{{ grains['ip_interfaces']['eth1'][0] }}"
  rpc  = "{{ grains['ip_interfaces']['eth1'][0] }}"
  serf = "{{ grains['ip_interfaces']['eth1'][0] }}"
}

{% if pillar.get('server', false) == True %}
{% set cluster = pillar.get('cluster', 1) %}
server {
  enabled          = true
  bootstrap_expect = {{ cluster["server"] | length }}
}
{% else %}
client {
  enabled       = true
  servers = ["{{ cluster['server'] | join('", "') }}"]
  network_interface = "eth1"
}
{% endif %}

autopilot {
    cleanup_dead_servers = true
    last_contact_threshold = "200ms"
    max_trailing_logs = 250
    server_stabilization_time = "10s"
}

consul {
  address = "{{ grains['ip_interfaces']['eth1'][0] }}:8500"
}
