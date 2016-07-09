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
  case node['mariadb']['install_flavor']
  when "yum"
    include_recipe 'mariadb::repo'
  end
end
