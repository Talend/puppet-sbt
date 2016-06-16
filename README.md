# talend-sbt

A puppet module for installing and configuring [Scala Build Tool](http://www.scala-sbt.org). SBT is an open source build tool for Scala and Java projects.

## Basic Usage:

### Installation via jar configuration

The default configuration installs and configures sbt via the sbt jar download and configuration.

**Prerequisite** : You need to have Java installed on your machine in order to have sbt working using this type of installation.

```puppet
class { 'sbt':
  sbt_jar_version  => '0.13.11'
  sbt_java_opts    => '-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M'
  sbt_jar_path     => '/bin'
}
```

### Installation via package

It is also possible to install sbt via a RPM package. To do so, you must set the `install_as_package` parameter to `true`.

```puppet
class { 'sbt': }
```

This package will install openjdk as part of the process, so you don't need to have java installed as a prerequisite.

##  Parameters

   - `install_as_package` - Whether to install sbt via the RPM package or the jar file
   - `sbt_jar_version` - The version of sbt to install (default is 0.13.11) - Only used when installing via the jar file
   - `sbt_jar_path` - The directory in which to install the jar file - Only used when installing via the jar file
   - `sbt_java_opts` - The Java options used when launching a sbt build

## Hiera Support

All parameters can be defined in hiera:

```yaml
sbt::install_as_package: false
sbt::sbt_jar_version: 0.13.11
sbt::sbt_jar_path: '/bin/'
sbt::sbt_java_opts: '-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M'
```

## Dependencies

  * puppetlabs-stdlib `> 2.4.0`
  * maestrodev-wget `> 1.7.0`

## Supported platforms

For installation as a jar file
  * CentOS/Redhat 6/7
  * Ubuntu 14.04

For installation as a package
  * CentOS/Redhat 6/7