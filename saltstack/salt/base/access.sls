root:
  user.present:
    - shell: /bin/bash
    - password: $6$dVaMQD2Z$rVRZglXyUTJ2VC6MRN9bLQ/fDGYVLz6VXWKKf7Tqw6.M9H8CwGXWWkXqZgOnQvEAbqGz4t8uChMNlp2oUQXss/

ssh:
  ssh_auth.present:
    - user: root
    - source: salt://ssh_keys/devops-brand.pub
    - config: /%h/.ssh/authorized_keys

