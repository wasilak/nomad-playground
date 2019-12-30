---
nomad_group:
  group.present:
    - name: nomad
    - system: True

nomad_user:
  user.present:
    - name: nomad
    - shell: /bin/bash
    - home: /home/nomad
    - groups:
      - nomad
      - docker
