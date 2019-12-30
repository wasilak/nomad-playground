{% set cluster = pillar.get('cluster') %}
datacenter = "vagrant"
data_dir = "/var/lib/consul"
encrypt = "{{ pillar['consul']['encrypt'] }}"
retry_join = ["{{ cluster['server'] | join('", "') }}"]

performance {
  raft_multiplier = 1
}

{% if pillar.get('server', false) == True %}
server = true
ui = true
bootstrap_expect = {{ cluster["server"] | length }}
{% else %}
server = false
{% endif %}

bind_addr = "{{ grains['ip_interfaces']['eth1'][0] }}"
client_addr = "0.0.0.0"

enable_local_script_checks = true

ports {
  dns = 53
  grpc = 8502
}

connect {
  enabled = true
}
