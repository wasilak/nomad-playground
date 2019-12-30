---
/etc/consul:
  file.directory:
    - user: consul
    - group: consul
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

/var/lib/consul:
  file.directory:
    - user: consul
    - group: consul
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

consul-config:
  file.managed:
    - name: /etc/consul/agent.hcl
    - source: salt://consul/templates/agent.hcl
    - template: jinja

consul-systemd-config:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: salt://consul/templates/consul.service
    - template: jinja
