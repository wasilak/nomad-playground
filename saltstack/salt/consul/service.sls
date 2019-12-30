---
consul_service:
    service.running:
        - name: consul
        - enable: True
        - watch:
          - file: consul-systemd-config
          - extract_consul

consul_systemd_reload:
  cmd.run:
   - name: systemctl daemon-reload
   - onchanges:  
     - file: consul-systemd-config

consul_service_reload:
  service.running:
    - name: consul
    - reload: True
    - watch:  
      - file: /etc/consul/agent.hcl
      - setting-consul-capabilities
    - require:
      - consul-systemd-config
