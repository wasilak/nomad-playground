---
/etc/nomad:
  file.directory:
    - user: nomad
    - group: nomad
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

/var/lib/nomad:
  file.directory:
    - user: nomad
    - group: nomad
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

nomad-config:
  file.managed:
    - name: /etc/nomad/agent.hcl
    - source: salt://nomad/templates/agent.hcl
    - template: jinja

nomad-systemd-config:
  file.managed:
    - name: /etc/systemd/system/nomad.service
    - source: salt://nomad/templates/nomad.service
    - template: jinja
