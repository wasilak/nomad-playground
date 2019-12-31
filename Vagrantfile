# -*- mode: ruby -*-
# vi: set ft=ruby :

require "ipaddr"
require 'getoptlong'

opts = GetoptLong.new(
  ['--servers', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--clients', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--consul_version', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--nomad_version', GetoptLong::OPTIONAL_ARGUMENT ],
)

num_of_servers = 1
num_of_clients = 1

nomad_version = '0.10.2'
consul_version = '1.6.2'

opts.ordering=(GetoptLong::REQUIRE_ORDER)   ### this line.

opts.each do |opt, arg|
  case opt
    when '--servers'
      num_of_servers = arg.to_i
    when '--clients'
      num_of_clients = arg.to_i
    when '--consul_version'
      consul_version = arg
    when '--nomad_version'
      nomad_version = arg
  end
end

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

  base_ip = {
    server: IPAddr.new('192.168.50.10'),
    client: IPAddr.new('192.168.50.30')
  }

  cluster = {
    server: [],
    client: []
  }

  cluster_ips = {
    server: [],
    client: []
  }

  cluster_hosts = []

  calculate_ips cluster, cluster_hosts, cluster_ips, base_ip[:server], num_of_servers, :server
  calculate_ips cluster, cluster_hosts, cluster_ips, base_ip[:client], num_of_clients, :client

  # puts cluster_hosts
  puts cluster
  puts cluster_ips
  puts "consul version: #{consul_version}"
  puts "nomad version: #{nomad_version}"

  box = {
    name: 'wasilak/amazon-linux-2'
  }

  cluster[:server].each do |instance|
    config.vm.define instance[:name], primary: true do |item|
      item.vm.box = box[:name]
      item.vm.hostname = instance[:name]
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
          "versions" => {
            "consul" => consul_version,
            "nomad" => nomad_version,
          }
        })
      end
    end
  end

  cluster[:client].each do |instance|
    config.vm.define instance[:name] do |item|
      item.vm.box = box[:name]
      item.vm.hostname = instance[:name]

      item.vm.provider 'virtualbox' do |vb|
        vb.memory = 1024
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

    end
  end

end
