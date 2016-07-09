#
# Cookbook Name:: mariadb
# Recipe:: default
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "rhel"
  yum_repository "mariadb" do
    description "MariaDB"
    url "#{node['mariadb']['repo']['baseurl']}"
    gpgkey "#{node['mariadb']['repo']['gpgkey']}"
    enabled false
    action :create
  end
end
