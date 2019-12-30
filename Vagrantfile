# -*- mode: ruby -*-
# vi: set ft=ruby :

require "ipaddr"

def calculate_ips cluster, cluster_hosts, cluster_ips, ip, num_of_instances, prefix
  (1..num_of_instances).each do |instance_number|
    ip = ip.succ
    cluster_hosts.push("#{ip} nomad-#{prefix}-#{instance_number}")
    cluster_ips[prefix].push(ip.to_s)
    cluster[prefix].push(
      {
        name: "nomad-#{prefix}-#{instance_number}",
        ip: ip.to_s
      }
    )
  end
end

Vagrant.configure(2) do |config|

  # nomad_version = '0.9.1'
  # consul_version = '1.5.1'
  # hashiui_version = '1.0.1'
  # fabio_version = '1.5.11'

  num_of_servers = 1
  # num_of_lbs = 1
  num_of_clients = 2

  base_ip = {
    server: IPAddr.new('192.168.50.10'),
    client: IPAddr.new('192.168.50.30')
    # lb: IPAddr.new('192.168.50.20'),
  }

  # fabio_filename = 'fabio-{{ fabio_version }}-go1.11.5-linux_amd64'

  cluster = {
    server: [],
    client: []
    # lb: [],
  }

  cluster_ips = {
    server: [],
    client: []
    # lb: [],
  }

  cluster_hosts = []

  calculate_ips cluster, cluster_hosts, cluster_ips, base_ip[:server], num_of_servers, :server
  calculate_ips cluster, cluster_hosts, cluster_ips, base_ip[:client], num_of_clients, :client
  # calculate_ips cluster, cluster_hosts, base_ip[:lb], num_of_lbs, :lb

  # puts cluster_hosts
  puts cluster
  puts cluster_ips

  box = {
    name: 'wasilak/amazon-linux-2'
  }

  cluster[:server].each do |instance|
    config.vm.define instance[:name], primary: true do |item|
      item.vm.box = box[:name]
      item.vm.hostname = instance[:name]
      # item.vm.network 'forwarded_port', guest: 8500, host: 8500
      # item.vm.network 'forwarded_port', guest: 3000, host: 3000
      item.vm.provider 'virtualbox' do |vb|
        vb.memory = 512
        vb.name = item.vm.hostname
      end

      item.vm.network 'private_network', ip: instance[:ip]

      item.vm.synced_folder '.', '/vagrant', type: 'nfs'

      item.vm.provision :salt do |salt|
        salt.masterless = true
        salt.minion_config = "saltstack/minion.yml"
        salt.run_highstate = true
        salt.colorize = true
        salt.log_level = "warning"
        salt.verbose = true
        salt.pillar({
          "server" => true,
          "cluster" => cluster_ips,
        })
      end

      # consul and nomad are bound to network interfaces created by Vagrant and not available right after boot
      # item.vm.provision 'shell', inline: 'sudo systemctl restart consul', run: 'always'
      # item.vm.provision 'shell', inline: 'sudo systemctl restart nomad', run: 'always'
    end
  end

  cluster[:client].each do |instance|
    config.vm.define instance[:name] do |item|
      item.vm.box = box[:name]
      item.vm.hostname = instance[:name]

      item.vm.provider 'virtualbox' do |vb|
        vb.memory = '512'
        vb.name = item.vm.hostname
      end

      item.vm.network 'private_network', ip: instance[:ip]

      item.vm.synced_folder '.', '/vagrant', type: 'nfs'

      item.vm.provision :salt do |salt|
        salt.masterless = true
        salt.minion_config = "saltstack/minion.yml"
        salt.run_highstate = true
        salt.colorize = true
        salt.log_level = "warning"
        salt.verbose = true
        # salt.python_version = 3
        salt.pillar({
          "server" => false,
          "cluster" => cluster_ips,
        })
      end

      # consul and nomad are bouund to network interfaces created by Vagrant and not available right after boot
      # item.vm.provision 'shell', inline: 'sudo systemctl restart docker', run: 'always'
      # item.vm.provision 'shell', inline: 'sudo systemctl restart consul', run: 'always'
      # item.vm.provision 'shell', inline: 'sudo systemctl restart nomad', run: 'always'
    end
  end

  # cluster[:lb].each do |instance|
  #   config.vm.define instance[:name] do |item|
  #     item.vm.box = box[:name]
  #     item.vm.hostname = instance[:name]
  #     # item.vm.network 'forwarded_port', guest: 9999, host: 9999
  #     # item.vm.network 'forwarded_port', guest: 9998, host: 9998
  #     # item.vm.network 'forwarded_port', guest: 6379, host: 6379

  #     item.vm.provider 'virtualbox' do |vb|
  #       vb.memory = '512'
  #       vb.name = item.vm.hostname
  #     end

  #     item.vm.network 'private_network', ip: instance[:ip]

  #     item.vm.synced_folder '.', '/vagrant', type: 'nfs'

  #     item.vm.provision 'ansible' do |ansible|
  #       ansible.playbook = 'provisioning/lb.yml'
  #       ansible.compatibility_mode = '2.0'
  #       ansible.extra_vars = {
  #         fabio_version: fabio_version,
  #         fabio_filename: fabio_filename,
  #         cluster_hosts: cluster_hosts,
  #         consul_bind_addr: instance[:ip],
  #         consul_cluster: {
  #           servers: cluster[:server]
  #         },
  #         consul_version: consul_version,
  #         consul_is_server: false,
  #         fabio: {
  #           proxy: {
  #             addr: ':9999'
  #           },
  #           registry: {
  #             consul: {
  #               # addr: server_ip + ':8500',
  #               addr: 'localhost:8500',
  #               register: {
  #                 enabled: false
  #               }
  #             }
  #           },
  #           metrics: {
  #             target: '',
  #             statsd: {
  #               addr: ''
  #             }
  #           }
  #         }
  #       }
  #     end
  #   end
  # end
end
