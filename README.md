Chef cookbook for the abiquo-writer collectd plugin
===================================================

[![Build Status](https://travis-ci.org/abiquo/collectd-abiquo-cookbook.svg?branch=master)](https://travis-ci.org/abiquo/collectd-abiquo-cookbook)
[![collectd-abiquo Cookbook](https://img.shields.io/badge/collectd--abiquo--cookbook-v0.2.1-blue.svg?style=flat)](https://supermarket.chef.io/cookbooks/collectd-abiquo)
[![Chef Version](http://img.shields.io/badge/chef-v12.5.1-orange.svg?style=flat)](https://www.chef.io)

This cookbook provides a recipe to install the [Abiquo collectd plugin](https://github.com/abiquo/collectd-abiquo).
It integrates any virtual machine deployed in the Abiquo platform with the
metrics system and allows them to push their own metrics to the Abiquo API.

## Requirements

The cookbook has been tested in the following platforms:

* CentOS 6.7
* Ubuntu 16.04

The cookbook depends on the following cookbooks:

* collectd-lib
* python
* yum-epel

## Recipes

* `recipe[collectd-abiquo]` - Installs collectd and the Abiquo monitoring plugin
* `recipe[collectd-abiquo::collectd]` - Installs and configures collectd and the default plugins
* `recipe[collectd-abiquo::plugin]` - Installs and configures the Abiquo collectd plugin

## Attributes

The following attributes are under the `node['collectd_abiquo']` namespace.

Attribute | Description | Type | Mandatory | Default value
----------|-------------|------|-----------|--------------
`['endpoint']` | The endpoint where the plugin will push the metrics | String | Yes | nil
`['auth_type']` | The authentication method used to push metrics to the Abiquo API (basic | oauth) | String | No | 'oauth'
`['python_module_path']` | The path where python modules are installed | String | No | /usr/lib/collectd
`['packages']` | The names of the collectd packages to install | List | No | \['collectd'\] (\['collectd-core', 'libpython2.7'\] in Ubuntu)
`['plugins']` | The names of the default collectd plugins to install | List | No | \['cpu', 'disk', 'interface'\]
`['log_traces']` | Enables the Abiquo plugin log | Boolean | No | true
`['version']` | The version of the Abiquo plugin to install | String | No | master
`['url']` | The URL of the Abiquo plugin file | String | Yes | https://rawgit.com/abiquo/collectd-abiquo/master/abiquo-writer.py 
`['verify_ssl']` | Enable SSL validation when pushing the metrics | Boolean | No | false
`['flush_interval_secs']` | Interval in which the metrics are pushed, in seconds | Integer | No | 30

# Usage

The cookbook is pretty straightforward to use. Just set all the mandatory attributes with the values for
the notification endpoint and the authentication type, and include the `recipe[collectd-abiquo]` in the
run list. You'll have to configure a data bag with the credentials in the Chef Server as explained below.

# Configuring access to the Abiquo API

In order to let the collectd plugin push metrics to the Abiquo API, the credentials must be stored in a
data bag with an item named `collectd_basic` (for basic auth credentials) or `collectd_oauth` (for OAuth
credentials). The recipes will pick the right data bag item according to the value of the `node['collectd_abiquo']['auth_type']`
attribute. The name of the data bag can be configured with the `node['collectd_abiquo']['credentials_data_bag']`
8defaults to `abiquo_credentials`). Convenience items are included in this cookbook. You can upload them to the
Chef Server as follows:

    knife data bag create abiquo_credentials
    knife data bag from file abiquo_credentials data_bags/abiquo_credentials/collectd_basic.json
    knife data bag from file abiquo_credentials data_bags/abiquo_credentials/collectd_oauth.json

# Testing

In order to test the cookbook you will need to install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).
Once installed you can run the unit and integration tests as follows:

    bundle install
    bundle exec berks install   # Install the cookbook dependencies
    bundle exec rake            # Run the unit and style tests
    bundle exec rake kitchen    # Run the integration tests

The tests and Gemfile have been developed using Ruby 2.1.5, and that is the recommended Ruby version to use to run the tests.
Other versions may cause conflicts with the versions of the gems Bundler will install.

# License and authors

* Author:: Enric Ruiz (enric.ruiz@abiquo.com)
* Author:: Ignasi Barrera (ignasi.barrera@abiquo.com)

Copyright:: 2015, Abiquo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
