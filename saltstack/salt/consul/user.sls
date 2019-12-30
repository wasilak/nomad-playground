---
consul_group:
  group.present:
    - name: consul
    - system: True

consul_user:
  user.present:
    - name: consul
    - shell: /bin/bash
    - home: /home/consul
    - groups:
      - consul
