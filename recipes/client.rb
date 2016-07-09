#
# Cookbook Name:: mariadb
# Recipe:: client
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

case node['mariadb']['install_flavor']
when "yum"
  include_recipe "mariadb::repo"

  %w(
    MariaDB-client
    MariaDB-devel
  ).each do |pkg|
    package pkg do
      options "--enablerepo=mariadb"
      action :install
    end
  end
when "rpm"
  %w(
    common
    client
    devel
  ).each do |pkg|
    rpm_name = "MariaDB-#{node['mariadb']['version']['major']}.#{node['mariadb']['version']['minor']}-centos6-x86_64-#{pkg}.rpm"

    remote_file "/usr/local/src/#{rpm_name}" do
      owner "root"
      group "root"
      mode 00644
      source "#{node['mariadb']['rpm']['url']}#{rpm_name}"
    end

    package rpm_name do
      action :install
      provider Chef::Provider::Package::Rpm
      source "/usr/local/src/#{rpm_name}"
    end
  end
end

%w(
  /etc/my.cnf
  /etc/my.cnf.d/mysql-clients.cnf
).each do |t|
  template t do
    owner "root"
    group "root"
    mode 00644
  end
end
