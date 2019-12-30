extract_nomad:
  archive.extracted:
    - name: /usr/share/nomad_{{ pillar['versions']['nomad'] }}_linux_amd64
    - source: https://releases.hashicorp.com/nomad/{{ pillar['versions']['nomad'] }}/nomad_{{ pillar['versions']['nomad'] }}_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/nomad/{{ pillar['versions']['nomad'] }}/nomad_{{ pillar['versions']['nomad'] }}_SHA256SUMS
    - user: nomad
    - group: nomad
    - enforce_toplevel: False
    - require:
      - user: nomad

symlink_current_nomad_version:
  file.symlink:
    - name: /usr/share/nomad
    - target: /usr/share/nomad_{{ pillar['versions']['nomad'] }}_linux_amd64

symlink_current_nomad_bin:
  file.symlink:
    - name: /usr/local/bin/nomad
    - target: /usr/share/nomad/nomad

setting-nomad-capabilities:
  cmd.run:
    - name: setcap 'cap_net_bind_service=+ep' /usr/share/nomad_{{ pillar['versions']['nomad'] }}_linux_amd64/nomad
    - unless: getcap /usr/share/nomad_{{ pillar['versions']['nomad'] }}_linux_amd64/nomad | grep -q 'cap_net_bind_service+ep'
