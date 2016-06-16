# == Class: sbt::install_jar
#
# This class installs sbt by downloading and configuring the jar file
#
# Prerequisite: You need to have Java already installed on your machine in order to have sbt working using this type of installation

class sbt::install_jar(
  $sbt_jar_version      = undef,
  $sbt_java_opts        = undef,
  $sbt_destination_path = undef
) {

  assert_private()

  wget::fetch { 'download_sbt_launch_jar':
    source      => "https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${sbt_jar_version}/sbt-launch.jar",
    destination => "${sbt_destination_path}/",
    timeout     => 0,
    verbose     => false,
  }

  file { '/bin/sbt':
    ensure  => 'present',
    content => inline_template("#!/bin/bash \n SBT_OPTS=\"<%= @sbt_java_opts %>\" \n java \$SBT_OPTS -jar `dirname \$0`/sbt-launch.jar \"$@\""),
    mode    => '0755',
  }
}