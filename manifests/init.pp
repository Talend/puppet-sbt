
# = Class: sbt
#
# Base Sbt class. This class handles installing Scala Build Tool (sbt)
# via retrieving and configuring the jar or via yum packages
#
# == Parameters
#
# [*install_as_package*]
#   Boolean.  Whether to install sbt via RPM package (true) or jar retrieval (false)
#   Default: false
#
# [*sbt_jar_version*]
#   String.  The version of sbt to install
#   Default: 0.13.11
#
# [*sbt_jar_path*]
#   String.  The directory in which to install the jar file
#   Default: /bin/
#
# [*sbt_java_opts*]
#   String.  The Java options used when launching a sbt build
#   Default: -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M

class sbt(
    $install_as_package   = $sbt::params::install_as_package,
    $sbt_java_opts        = $sbt::params::sbt_java_opts,
    $sbt_jar_version      = $sbt::params::sbt_jar_version,
    $sbt_destination_path = $sbt::params::sbt_destination_path,
) inherits sbt::params {

  validate_bool($install_as_package)
  validate_string($sbt_java_opts)
  validate_string($sbt_jar_version)
  validate_string($sbt_destination_path)

  if $install_as_package {
    class { '::sbt::install_package': }
  } else {
    class { '::sbt::install_jar':
      sbt_java_opts        => $sbt_java_opts,
      sbt_jar_version      => $sbt_jar_version,
      sbt_destination_path => $sbt_destination_path,
    }
  }
}