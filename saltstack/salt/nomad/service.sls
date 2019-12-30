---
nomad_service:
    service.running:
        - name: nomad
        - enable: True
        - watch:
          - nomad-systemd-config
          - nomad-config
          - extract_nomad

nomad_systemd_reload:
  cmd.run:
   - name: systemctl daemon-reload
   - onchanges:  
     - file: nomad-systemd-config

nomad_service_reload:
  service.running:
    - name: nomad
    - reload: True
    - watch:  
      - nomad-config
      - setting-nomad-capabilities
    - require:
      - nomad-systemd-config
