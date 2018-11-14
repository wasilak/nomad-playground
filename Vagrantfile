# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  start_ip = 4
  num_of_clients = 2
  base_ip = "192.168.50."
  lb_ip = base_ip + (start_ip - 1).to_s
  server_ip = base_ip + start_ip.to_s
  nomad_version = "0.8.6"
  consul_version = "1.3.0"
  hashiui_version = "1.0.0"
  fabio_version = "1.5.10"
  fabio_filename = "fabio-{{ fabio_version }}-go1.11.1-linux_amd64"

  server_name = "nomad-server"
  lb_name = "nomad-lb"

  cluster = {
    "servers": [ server_name ],
    "clients": []
  }

  cluster_hosts = [
    server_ip + " " + server_name,
    lb_ip + " " + lb_name
  ]

  (1..num_of_clients).each do |client_number|
    ip = base_ip + (client_number + start_ip).to_s
    cluster_hosts.push(ip.to_s + " " + "nomad-client-" + client_number.to_s)
    cluster[:clients].push("nomad-client-" + client_number.to_s)
  end

  config.vm.define "server", primary: true do |item|
    item.vm.box = "centos/7"
    item.vm.hostname = server_name
    item.vm.network "forwarded_port", guest: 8500, host: 8500
    item.vm.network "forwarded_port", guest: 3000, host: 3000
    item.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.name = item.vm.hostname
    end

    item.vm.network "private_network", ip: server_ip

    item.vm.synced_folder ".", "/vagrant", type: "nfs"

    item.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/server.yml"
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = {
        bind_addr: server_ip,
        cluster_hosts: cluster_hosts,
        cluster: cluster,
        is_server: true,
        consul_version: consul_version,
        nomad_version: nomad_version,
        hashiui_version: hashiui_version
      }
    end

    # consul and nomad are bound to network interfaces created by Vagrant and not available right after boot
    item.vm.provision "shell", inline: "sudo systemctl restart consul", run: "always"
    item.vm.provision "shell", inline: "sudo systemctl restart nomad", run: "always"
  end

  (1..num_of_clients).each do |client_number|
    config.vm.define "client" + client_number.to_s do |item|
      item.vm.hostname = "nomad-client-" + client_number.to_s
      item.vm.box = "centos/7"

      ip = base_ip + (client_number + start_ip).to_s
      item.vm.network "private_network", ip: ip
      
      item.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.name = item.vm.hostname
      end

      item.vm.synced_folder ".", "/vagrant", type: "nfs"

      item.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/client.yml"
        ansible.compatibility_mode = "2.0"
        ansible.extra_vars = {
          bind_addr: ip,
          cluster_hosts: cluster_hosts,
          cluster: cluster,
          is_server: false,
          consul_version: consul_version,
          nomad_version: nomad_version
        }
      end

      # consul and nomad are bouund to network interfaces created by Vagrant and not available right after boot
      item.vm.provision "shell", inline: "sudo systemctl restart docker", run: "always"
      item.vm.provision "shell", inline: "sudo systemctl restart consul", run: "always"
      item.vm.provision "shell", inline: "sudo systemctl restart nomad", run: "always"
    end
  end

  config.vm.define "lb" do |item|
    item.vm.box = "centos/7"
    item.vm.hostname = lb_name
    item.vm.network "forwarded_port", guest: 9999, host: 9999
    item.vm.network "forwarded_port", guest: 9998, host: 9998
    item.vm.network "forwarded_port", guest: 6379, host: 6379
    
    item.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.name = lb_name
    end

    item.vm.network "private_network", ip: lb_ip

    item.vm.synced_folder ".", "/vagrant", type: "nfs"

    item.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/lb.yml"
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = {
        fabio_version: fabio_version,
        filename: fabio_filename,
        cluster_hosts: cluster_hosts,
        fabio: {
          proxy: {
            addr: ":9999"
          },
          registry: {
            consul: {
              addr: server_ip + ":8500",
              register: {
                enabled: false
              }
            }
          },
          metrics: {
            target: "",
            statsd: {
              addr: ""
            }
          },
        }
      }
    end

  end

end
