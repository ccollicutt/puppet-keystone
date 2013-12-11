#
# Creates the auth endpoints for keystone
#
# == Parameters
#
# * public_address   - public address for keystone endpoint. Optional. Defaults to 127.0.0.1.
# * admin_address    - admin address for keystone endpoint. Optional. Defaults to 127.0.0.1.
# * internal_address - internal address for keystone endpoint. Optional. Defaults to 127.0.0.1.
# * public_port      - Port for non-admin access to keystone endpoint. Optional. Defaults to 5000.
# * admin_port       - Port for admin access to keystone endpoint. Optional. Defaults to 35357.
# * region           - Region for endpoint. Optional. Defaults to RegionOne.
# * version          - API version for endpoint. Optional. Defaults to v2.0.
#
# == Sample Usage
#
#   class { 'keystone::endpoint':
#     :public_address   => '154.10.10.23',
#     :admin_address    => '10.0.0.7',
#     :internal_address => '11.0.1.7',
#   }
#
#
class keystone::endpoint(
  $public_address   = '127.0.0.1',
  $admin_address    = '127.0.0.1',
  $internal_address = '127.0.0.1',
  $public_port      = '5000',
  $admin_port       = '35357',
  $internal_port    = undef,
  $region           = 'RegionOne',
  $public_protocol  = 'http',
  $version          = 'v2.0',
) {

  if $internal_port == undef {
    $real_internal_port = $public_port
  } else {
    $real_internal_port = $internal_port
  }

  keystone_service { 'keystone':
    ensure      => present,
    type        => 'identity',
    description => 'OpenStack Identity Service',
  }

  keystone_endpoint { "${region}/keystone":
    ensure       => present,
    public_url   => "${public_protocol}://${public_address}:${public_port}/${version}",
    admin_url    => "${public_protocol}:://${admin_address}:${admin_port}/${version}",
    internal_url => "${public_protocol}:://${internal_address}:${real_internal_port}/${version}",
    region       => $region,
  }
}
