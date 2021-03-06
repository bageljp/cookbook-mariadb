default['mariadb']['version']['major'] = "10.0"
default['mariadb']['version']['minor'] = "15"
default['mariadb']['install_flavor'] = "yum"
default['mariadb']['rpm']['url'] = "http://localhost/"
default['mariadb']['repo']['baseurl'] = "http://yum.mariadb.org/#{node['mariadb']['version']['major']}/centos6-amd64"
default['mariadb']['repo']['gpgkey'] = "https://yum.mariadb.org/RPM-GPG-KEY-MariaDB"
default['mariadb']['rotate'] = "31"
default['mariadb']['password'] = ""
default['mariadb']['character-set'] = "utf8"
default['mariadb']['server-id'] = 1
default['mariadb']['auto_increment_offset'] = 1
