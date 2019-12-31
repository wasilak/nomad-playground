.PHONY: all setup reload clean

servers = 1
clients = 2
consul_version = 1.6.2
nomad_version = 0.10.2

green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`

all: setup deployment

setup:
	@echo "Setting up Vagrant infrastructure"
	@vagrant --servers=${servers} --clients=${clients} --consul_version=${consul_version} --nomad_version=${nomad_version} up --provision
	@echo "${green}Nomad UI can be accessed at:${reset} ${cyan}http://192-168-50-11.nip.io:4646${reset}\n"
	@echo "${green}Consul UI can be accessed at:${reset} ${cyan}http://192.168.50.11.nip.io:8500${reset}\n"

deployment:
	@echo "${green}Deploying${reset} ${cyan}traefik${reset}"
	@NOMAD_ADDR=http://192.168.50.11:4646 nomad run traefik.nomad
	@echo "${green}traefik UI can be accessed at:${reset} ${cyan}http://192-168-50-31.nip.io:8080${reset}\n"
	@echo "${green}Deploying${reset} ${cyan}sherpa${reset}"
	@NOMAD_ADDR=http://192.168.50.11:4646 nomad run sherpa.nomad
	@echo "${green}sherpa UI can be accessed at:${reset} ${cyan}http://sherpa.192-168-50-31.nip.io${reset}\n"
	@echo "${green}Deploying${reset} ${cyan}hello-world-python-flask${reset}"
	@NOMAD_ADDR=http://192.168.50.11:4646 nomad run hello-world-python-flask.nomad
	@echo "${green}Python (Flask) test app can be accessed at:${reset} ${cyan}http://192-168-50-31.nip.io/hello-world/python-flask/${reset}\n"
	@NOMAD_ADDR=http://192.168.50.11:4646 nomad run hello-world-python-fastapi.nomad
	@echo "${green}Python (Fastapi) test app can be accessed at:${reset} ${cyan}http://192-168-50-31.nip.io/hello-world/python-fastapi/${reset}\n"
	@NOMAD_ADDR=http://192.168.50.11:4646 nomad run hello-world-go.nomad
	@echo "${green}Go test app can be accessed at:${reset} ${cyan}http://192-168-50-31.nip.io/hello-world/go/${reset}\n"

reload:
	@echo "Setting up Vagrant infrastructure"
	@vagrant --servers=${servers} --clients=${clients} --consul_version=${consul_version} --nomad_version=${nomad_version} reload

clean:
	@echo "Cleaning up..."
	@vagrant --servers=${servers} --clients=${clients} --consul_version=${consul_version} --nomad_version=${nomad_version} destroy -f
