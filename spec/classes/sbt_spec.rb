require 'spec_helper'

describe 'sbt', :type => :class do
  context 'default sbt installation' do
    let(:facts) do
    {
      :kernel          => 'Linux',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat',
    }
    end

    let(:params) do
    {
      :install_as_package => true
    }
    end
    it { should compile }
    it { should contain_class('sbt') }
    it { should contain_class('sbt::params') }
    it { should contain_class('sbt::install_package') }
    it { should_not contain_class('sbt::install_jar') }
    it do
      should contain_yumrepo('bintray--sbt-rpm').with({
        :name     => 'bintray--sbt-rpm',
        :baseurl  => 'http://dl.bintray.com/sbt/rpm',
        :enabled  => '1',
        :gpgcheck => '0',
      })
    end
    it do
      should contain_package('sbt').that_requires('Yumrepo[bintray--sbt-rpm]').with({
        :ensure   => 'installed',
        :provider => 'yum',
        :name     => 'sbt',
      })
    end
    it do
      should contain_file('/usr/share/sbt-launcher-packaging/conf/sbtconfig.txt').that_requires('Package[sbt]').with({
        :content => /-Xms512M -Xmx1536M -Xss1M/,
        :replace => "true",
        :require => "Package[sbt]"
      })
    end
  end
  context 'default sbt installation' do
    let(:facts) do
    {
      :osfamily => 'default',
    }
    end
    let(:params) do
    {
      :install_as_package => true
    }
    end
    it { should raise_error(Puppet::Error, /The installation as a package is only supported on CentOS\/Redhat 6\/7./) }
  end

  context 'default sbt jar installation' do
    let(:facts) do
    {
      :kernel          => 'Linux',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat',
    }
    end
    let(:params) do
    {
      :install_as_package => false
    }
    end
    it { should compile }
    it { should contain_class('sbt') }
    it { should contain_class('sbt::params') }
    it { should_not contain_class('sbt::install_package') }
    it { should contain_class('sbt::install_jar') }
    it { should contain_class('sbt::install_jar').with_sbt_jar_version('0.13.11') }
    it { should contain_class('sbt::install_jar').with_sbt_destination_path('/bin') }
    it { should contain_class('sbt::install_jar').with_sbt_java_opts('-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M') }
    it do
      should contain_wget__fetch('download_sbt_launch_jar').with({
        :source      => "https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.11/sbt-launch.jar",
        :destination => "/bin/",
        :timeout     => 0,
        :verbose     => false,
      })
    end    
    it do
      should contain_file('/bin/sbt').with(
        :content => "#!/bin/bash \n SBT_OPTS=\"-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M\" \n java \$SBT_OPTS -jar `dirname \$0`/sbt-launch.jar \"$@\"",
        :mode    => "0755"
      )
    end
  end
end