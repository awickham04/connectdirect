#
# class that managers IBM Sterling Connect:Direct files
#

class sterlingcd (
$service_shutdown = hiera('service_shutdown', false), 
)
{
 
 # Incoming firewall rules
 firewall { '260 allow IBM CD connect': dport => '1364', proto => tcp, action => accept }
 firewall { '261 allow IBM CD client': dport => '1363', proto => tcp, action => accept }
 
 # Outgoing firewall rules
 firewall { '460 allow IBM CD connect': chain => 'OUTPUT', dport => '1364', proto => tcp, action => accept }
 
 file { '/etc/init.d/sterlingcd':
   ensure => present,
   owner  => 'root',
   group  => 'root',
   mode   => '755',
   content => template("$module_name/sterlingcd.init.erb"),
 }
 
   file { "/opt/scripts":
    ensure => "directory",
      owner  => "root",
      group  => "root",
      mode => "0755",
  }
 
 file { '/opt/scripts/service_shutdown.sh':
   ensure => present,
   owner  => 'root',
   group  => 'root',
   mode   => '755',
   content => template("$module_name/service_shutdown.sh.erb"),
 }
 
  file { '/opt/scripts/cdstop.sh':
   ensure => present,
   owner  => 'cdadmin',
   group  => 'cdadmin',
   mode   => '755',
   content => template("$module_name/cdstop.sh.erb"),
 }
 
 file { '/home/cdadmin/.bash_profile':
   ensure => present,
   owner  => 'cdadmin',
   group  => 'cdadmin',
   mode   => '644',
   content => template("$module_name/bash_profile.erb"),
 }
}
