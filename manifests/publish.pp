# == Class: sbt::publish
#
# This class sets the configuration for being able to publish sbt artifacts
#

class sbt::publish(
  $publish_credentials_file_path  = undef,
  $publish_credentials_file       = undef,
  $publish_realm                  = undef,
  $publish_host                   = undef,
  $publish_user                   = undef,
  $publish_password               = undef,
  $publish_credentials_file_owner = undef
) {

  assert_private()

  file { "${publish_credentials_file_path}/${publish_credentials_file}":
    ensure  => 'present',
    content => inline_template("realm=<%= @publish_realm %>\nhost=<%= @publish_host %>\nuser=<%= @publish_user %>\npassword=<%= @publish_password %>"),
    owner   => $publish_credentials_file_owner,
    group   => $publish_credentials_file_owner,
    mode    => '0600',
  }
}