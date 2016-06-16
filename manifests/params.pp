# == Class: sbt::params
#
# This class handles parameters for the sbt module.

class sbt::params {
  $install_as_package   = false
  $sbt_java_opts        = '-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M'
  $sbt_jar_version      = '0.13.11'
  $sbt_jar_path         = '/bin'
  $sbt_destination_path = regsubst($sbt_jar_path,'\/$','','G')
}