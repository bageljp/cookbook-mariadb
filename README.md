What's ?
===============
chef で使用する MariaDB の cookbook です。

Usage
-----
cookbook なので berkshelf で取ってきて使いましょう。

* Berksfile
```ruby
source "https://supermarket.chef.io"

cookbook "mariadb", git: "https://github.com/bageljp/cookbook-mariadb.git"
```

```
berks vendor
```

#### Role and Environment attributes

* sample_role.rb
```ruby
override_attributes(
  "mariadb" => {
    "install_flavor" => "yum",
    "log_rotate" => "31",
    "password" => "root_password"
  }
)
```

Recipes
----------

#### mariadb::default
serverとclientを別レシピにしたのでリポジトリ設定をinlucdしてるくらい。

#### mariadb::repo
MariaDBのリポジトリ設定。

#### mariadb::server
MariaDB-serverのインストールと設定。

#### mariadb::client
MariaDB-clientのインストールと設定。

Attributes
----------

主要なやつのみ。

#### mariadb::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['mariadb']['rpm']['url']</tt></td>
    <td>string</td>
    <td>rpmでインストールする場合にrpmが置いてあるURL。rpmbuildしたものをs3とかに置いておくといいかも。</td>
  </tr>
  <tr>
    <td><tt>['mariadb']['password']</tt></td>
    <td>string</td>
    <td>MariaDBのrootユーザのパスワード。</td>
  </tr>
</table>

