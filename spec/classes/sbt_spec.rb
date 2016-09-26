require 'spec_helper'

describe 'sbt', :type => :class do
  context 'default sbt installation' do
    let(:facts) do
    {
      :kernel          => 'Linux',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat',
      :sbt_java_opts   => '-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M'
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
      :operatingsystem => 'default',
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
      :http_proxy      => 'default',
      :https_proxy     => 'default',
      :schedule        => 'default',
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

  context 'configured_publishing_credentials' do
    let(:facts) do
    {
      :kernel          => 'Linux',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat',
      :http_proxy      => 'default',
      :https_proxy     => 'default',
      :schedule        => 'default',
    }
    end
    let(:params) do
    {
      :publish_configure_credentials => true
    }
    end
    it { should compile }
    it { should contain_class('sbt::publish') }
    it { should contain_class('sbt::publish').with_publish_credentials_file_path('/home/user/.ivy2') }
    #it { should contain_class('sbt::publish').with_publish_credentials_folder('/home/user/.ivy2') }    
    it { should contain_class('sbt::publish').with_publish_credentials_file('.credentials') }
    it { should contain_class('sbt::publish').with_publish_credentials_file_owner('root') }
    it { should contain_class('sbt::publish').with_publish_realm('myrealm') }
    it { should contain_class('sbt::publish').with_publish_host('nexus_host') }
    it { should contain_class('sbt::publish').with_publish_user('nexus_username') }
    it { should contain_class('sbt::publish').with_publish_password('nexus_password') }
    it do
      should contain_file('/home/user/.ivy2/.credentials').with(
        :ensure  => 'present',
        :content => "realm=myrealm\nhost=nexus_host\nuser=nexus_username\npassword=nexus_password",
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0600'
      )
    end
  end
  context 'configured_publishing_credentials' do
    let(:facts) do
    {
      :kernel          => 'Linux',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat',
      :http_proxy      => 'default',
      :https_proxy     => 'default',
      :schedule        => 'default',
    }
    end
    let(:params) do
    {
      :publish_configure_credentials => false
    }
    end
    it { should_not contain_class('sbt::publish') }
  end
end
