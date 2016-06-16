# == Class: sbt::install_package
#
# This class installs sbt build tool via yum
# OpenJDK is installed as part of the process

class sbt::install_package {

  assert_private()

  if $::operatingsystem == 'CentOS' {

    yumrepo { 'bintray--sbt-rpm':
      name     => 'bintray--sbt-rpm',
      baseurl  => 'http://dl.bintray.com/sbt/rpm',
      enabled  => 1,
      gpgcheck => 0,
    }

    package { 'sbt':
      ensure   => 'installed',
      provider => 'yum',
      name     => 'sbt',
      require  => Yumrepo['bintray--sbt-rpm'],
    }

    file { '/usr/share/sbt-launcher-packaging/conf/sbtconfig.txt':
      content => template('sbt/usr/share/sbt-launcher-packaging/conf/sbtconfig.erb'),
      replace => true,
      require => Package['sbt'],
    }

  }
  else {
    fail('The installation as a package is only supported on CentOS/Redhat 6/7.')
  }

}