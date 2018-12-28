# Cookbook Name:: collectd-abiquo
# Attributes:: collectd-abiquo
#
# Copyright 2014, Abiquo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Package to install
case node['platform']
when 'ubuntu'
    default['collectd_abiquo']['packages'] = ['collectd-core', 'libpython2.7']
when 'centos'
    default['collectd_abiquo']['packages'] = ['collectd']
    override['collectd']['conf_dir'] = '/etc'
    if node['kernel']['machine'] == 'x86_64'
        override['collectd']['plugin_dir'] = '/usr/lib64/collectd'
    end
else
    default['collectd_abiquo']['packages'] = ['collectd']
end

# Default plugin configuration
default['collectd_abiquo']['version'] = '0.0.1'
default['collectd_abiquo']['url'] = "https://rawgit.com/abiquo/collectd-abiquo/#{node['collectd_abiquo']['version']}/abiquo-writer.py"
default['collectd_abiquo']['plugins'] = ['cpu', 'memory', 'disk', 'interface']
default['collectd_abiquo']['log_traces'] = true
default['collectd_abiquo']['auth_type'] = 'oauth'
default['collectd_abiquo']['verify_ssl'] = false
default['collectd_abiquo']['flush_interval_secs'] = 30
default['collectd_abiquo']['credentials_data_bag'] = 'abiquo_credentials'

# Fix typo in the collectd-lib cookbook
override['collectd']['extra_conf_dir'] = '/etc/collectd/collectd.conf.d'
