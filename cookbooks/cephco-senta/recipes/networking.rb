package 'ethtool'
package 'bridge-utils'

# this is ugly but let's fight that later

# a true chef person would probably try to put these in node
# attributes, but these are not lovingly crafted nodes, these are
# chef-solo runs, and there's only 4 senta machines..

SENTA_MACS = {
  'senta01' => {
    '1g1' => '00:25:90:08:0a:fa',
    '1g2' => '00:25:90:08:0a:fb',
  },
  'senta02' => {
    '1g1' => '00:25:90:08:09:c6',
    '1g2' => '00:25:90:08:09:c7',
  },
  'senta03' => {
    '1g1' => '00:25:90:08:0a:4c',
    '1g2' => '00:25:90:08:0a:4d',
  },
  'senta04' => {
    '1g1' => '00:25:90:08:09:d2',
    '1g2' => '00:25:90:08:09:d3',
  },
}

SENTA_IPS = {
  'senta01' => {
    'front' => '10.214.137.31',
    'back' => '10.214.150.31',
  },
  'senta02' => {
    'front' => '10.214.137.32',
    'back' => '10.214.150.32',
  },
  'senta03' => {
    'front' => '10.214.137.33',
    'back' => '10.214.150.33',
  },
  'senta04' => {
    'front' => '10.214.137.34',
    'back' => '10.214.150.34',
  },
}

cookbook_file '/etc/network/rename-if-by-mac' do
  backup false
  owner 'root'
  group 'root'
  mode 0755
end


# generate a .chef file from a template, and then be extra careful in
# swapping it in place; effecting changes over ssh is DANGEROUS,
# please have a serial console handy
template '/etc/network/interfaces.chef' do
  source 'interfaces.erb'
  mode 0644
  variables(
            'macs' => SENTA_MACS[node['hostname']],
            'ips' => SENTA_IPS[node['hostname']],
            )
end

execute "activate network config" do
   command <<-'EOH'
     set -e
     ifdown -a
     mv /etc/network/interfaces.chef /etc/network/interfaces
     ifup -a
  EOH
  # don't run the ifdown/ifup if there's no change to the file
  not_if "cmp /etc/network/interfaces.chef /etc/network/interfaces"
end
