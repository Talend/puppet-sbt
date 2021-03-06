
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
#
# [*publish_configure_credentials*]
#   Boolean. Whether to set the configuration for remote publishing
#   Default: false
#
# [*publish_credentials_folder*]
#   String. The directory in which to place the credentials file used for publishing
#   Default: /var/.ivy2/
#
# [*publish_credentials_file*]
#   String. The name of the file containing the credentials used for publishing
#   Default: .credentials
#
# [*publish_credentials_file_owner*]
#   String. The owner of the crendentials file
#   Default: undef
#
# [*publish_realm*]
#   String. The realm of the artifacts repository
#   Default: undef
#
# [*publish_host*]
#   String. The artifacts repository host
#   Default: undef
#
# [*publish_user*]
#   String. Username for publishing into the artifacts repository
#   Default: undef
#
# [*publish_password*]
#   String. Password for publishing into the artifacts repository
#   Default: undef

class sbt(
    $install_as_package             = $sbt::params::install_as_package,
    $sbt_java_opts                  = $sbt::params::sbt_java_opts,
    $sbt_jar_version                = $sbt::params::sbt_jar_version,
    $sbt_jar_path                   = $sbt::params::sbt_jar_path,
    $publish_configure_credentials  = $sbt::params::publish_configure_credentials,
    $publish_credentials_folder     = $sbt::params::publish_credentials_folder,
    $publish_credentials_file       = $sbt::params::publish_credentials_file,
    $publish_credentials_file_owner = $sbt::params::publish_credentials_file_owner,
    $publish_realm                  = $sbt::params::publish_realm,
    $publish_host                   = $sbt::params::publish_host,
    $publish_user                   = $sbt::params::publish_user,
    $publish_password               = $sbt::params::publish_password,
) inherits sbt::params {

  validate_bool($install_as_package)
  validate_string($sbt_java_opts)
  validate_string($sbt_jar_version)
  validate_string($sbt_jar_path)
  validate_bool($publish_configure_credentials)
  validate_string($publish_credentials_folder)
  validate_string($publish_credentials_file)
  validate_string($publish_credentials_file_owner)
  validate_string($publish_realm)
  validate_string(publish_host)
  validate_string($publish_user)
  validate_string($sbt_jar_path)
  validate_string($publish_password)

  if $install_as_package {
    class { '::sbt::install_package': }
  } else {
    $sbt_destination_path = regsubst($sbt_jar_path,'\/$','','G')
    class { '::sbt::install_jar':
      sbt_java_opts        => $sbt_java_opts,
      sbt_jar_version      => $sbt_jar_version,
      sbt_destination_path => $sbt_destination_path,
    }
  }

  if $publish_configure_credentials {
    $publish_credentials_file_path = regsubst($publish_credentials_folder,'\/$','','G')
    class { '::sbt::publish':
      publish_credentials_file_path  => $publish_credentials_file_path,
      publish_credentials_file       => $publish_credentials_file,
      publish_credentials_file_owner => $publish_credentials_file_owner,
      publish_realm                  => $publish_realm,
      publish_host                   => $publish_host,
      publish_user                   => $publish_user,
      publish_password               => $publish_password,
    }
  }

}
