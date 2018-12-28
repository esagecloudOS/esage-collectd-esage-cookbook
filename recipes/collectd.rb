# Cookbook Name:: collectd-abiquo
# Recipe:: collectd
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

# Use the right package for each platform
node.set['collectd']['packages'] = node['collectd_abiquo']['packages']

if node['platform'] == 'centos'
    # The collectd package is only in the EPEL repo
    include_recipe 'yum-epel'
end

include_recipe 'collectd-lib::packages'
include_recipe 'collectd-lib::directories'
include_recipe 'collectd-lib::config'
include_recipe 'collectd-lib::service'

node['collectd_abiquo']['plugins'].each do |name|
    collectd_conf name do
        plugin name
    end
end
