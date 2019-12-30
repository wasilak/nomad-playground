extract_consul:
  archive.extracted:
    - name: /usr/share/consul_{{ pillar['versions']['consul'] }}_linux_amd64
    - source: https://releases.hashicorp.com/consul/{{ pillar['versions']['consul'] }}/consul_{{ pillar['versions']['consul'] }}_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul/{{ pillar['versions']['consul'] }}/consul_{{ pillar['versions']['consul'] }}_SHA256SUMS
    - user: consul
    - group: consul
    - enforce_toplevel: False
    - require:
      - user: consul

symlink_current_consul_version:
  file.symlink:
    - name: /usr/share/consul
    - target: /usr/share/consul_{{ pillar['versions']['consul'] }}_linux_amd64

symlink_current_consul_bin:
  file.symlink:
    - name: /usr/local/bin/consul
    - target: /usr/share/consul/consul

setting-consul-capabilities:
  cmd.run:
    - name: setcap 'cap_net_bind_service=+ep' /usr/share/consul_{{ pillar['versions']['consul'] }}_linux_amd64/consul
    - unless: getcap /usr/share/consul_{{ pillar['versions']['consul'] }}_linux_amd64/consul | grep -q 'cap_net_bind_service+ep'
