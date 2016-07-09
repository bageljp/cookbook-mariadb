#
# Cookbook Name:: mariadb
# Recipe:: server
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

case node['mariadb']['install_flavor']
when "yum"
  include_recipe "mariadb::repo"

  %w(
    MariaDB-server
    MariaDB-devel
  ).each do |pkg|
    package pkg do
      options "--enablerepo=mariadb"
      action :install
    end
  end
when "rpm"
  package "perl-DBI"

  %w(
    compat
    shared
    server
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
      # 自分でcompileしたrpmだとAmazonLinuxの場合mysql55-libsと競合する、、、
      options "--force" if node['platform'] == "amazon"
      action :install
      provider Chef::Provider::Package::Rpm
      source "/usr/local/src/#{rpm_name}"
    end
  end
end

%w(
  /etc/my.cnf
  /etc/my.cnf.d/server.cnf
  /etc/my.cnf.d/tokudb.cnf
).each do |t|
  template t do
    owner "root"
    group "root"
    mode 00644
    notifies :restart, "service[mysql]"
  end
end

service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

#daga_tag = Chef::EncryptedDataBagItem.load('root_password', 'mariadb')
#root_password = data_bag['root_password']

bash "mysql_secure_installation" do
  user "root"
  group "root"
  code <<-EOC
    mysql -u root << EOF
      -- set root password
      UPDATE mysql.user SET Password=PASSWORD("#{node['mariadb']['password']}") WHERE User='root';
      -- remove anonymous users
      DELETE FROM mysql.user WHERE User='';
      -- Disallow root login remotely
      DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
      -- Remove test database and access to it
      DROP DATABASE IF EXISTS test;
      DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
      -- Reload privilege tables now
      FLUSH PRIVILEGES;
EOF
  EOC
  only_if "mysql -u root -e \"select Db from mysql.db where Db = 'test';\" | grep -q test"
end


template "/etc/logrotate.d/mysql" do
  user "root"
  group "root"
  mode 00644
  source "mysql.logrotate.erb"
end

