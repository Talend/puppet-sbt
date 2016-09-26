# == Class: sbt::params
#
# This class handles parameters for the sbt module.

class sbt::params {
  $install_as_package                  = false
  $sbt_java_opts                       = '-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M'
  $sbt_jar_version                     = '0.13.11'
  $sbt_jar_path                        = '/bin'
  $publish_configure_credentials       = false
  $publish_credentials_folder          = '/var/.ivy2/'
  $publish_credentials_file            = '.credentials'
  $publish_credentials_file_owner      = undef
  $publish_realm                       = undef
  $publish_host                        = undef
  $publish_user                        = undef
  $publish_password                    = undef
}