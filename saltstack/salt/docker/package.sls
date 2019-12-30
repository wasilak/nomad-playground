amazon_linux_enable_docker:
  cmd.run:
    - name: amazon-linux-extras enable docker
    - unless: amazon-linux-extras | grep docker | grep enabled

amazon_linux_install_docker:
  pkg.installed:
    - names:
      - docker