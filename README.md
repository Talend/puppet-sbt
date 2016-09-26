[![Build Status](https://travis-ci.org/Talend/puppet-sbt.svg?branch=master)](https://travis-ci.org/Talend/puppet-sbt)

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

### Set-up publishing

The publish action is used to publish your project to a remote repository. To use publishing, you need to specify the repository to publish to and the credentials to use.

To do so, you have to configure a set of hiera variables, such as:

```yaml
sbt::publish_configure_credentials: true
sbt::publish_credentials_folder: '/home/myuser/.ivy2/'
sbt::publish_credentials_file: '.credentials'
sbt::publish_credentials_file_owner: 'myuser'
sbt::publish_realm: 'My Nexus Repository Manager'
sbt::publish_host: 'my.artifact.repo.net'
sbt::publish_user: 'admin'
sbt::publish_password: 'admin'
```

##  Parameters

   - `install_as_package` - Whether to install sbt via the RPM package or the jar file
   - `sbt_jar_version` - The version of sbt to install (default is 0.13.11) - Only used when installing via the jar file
   - `sbt_jar_path` - The directory in which to install the jar file - Only used when installing via the jar file
   - `sbt_java_opts` - The Java options used when launching a sbt build
   - `publish_configure_credentials` - Whether to set the configuration for remote publishing
   - `publish_credentials_folder` - The directory in which to place the credentials file used for publishing
   - `publish_credentials_file` - The name of the file containing the credentials used for publishing
   - `publish_credentials_file_owner` - The owner of the crendentials file
   - `publish_realm` - The realm of the artifacts repository
   - `publish_host` - The artifacts repository host
   - `publish_user` - Username for publishing into the artifacts repository
   - `publish_password` - Password for publishing into the artifacts repository

## Hiera Support

All parameters can be defined in hiera:

```yaml
sbt::install_as_package: false
sbt::sbt_jar_version: 0.13.11
sbt::sbt_jar_path: '/bin/'
sbt::sbt_java_opts: '-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M'
```

```yaml
sbt::publish_configure_credentials: true
sbt::publish_credentials_folder: '/home/myuser/.ivy2/'
sbt::publish_credentials_file: '.credentials'
sbt::publish_credentials_file_owner: 'myuser'
sbt::publish_realm: 'My Nexus Repository Manager'
sbt::publish_host: 'my.artifact.repo.net'
sbt::publish_user: 'admin'
sbt::publish_password: 'admin'
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
