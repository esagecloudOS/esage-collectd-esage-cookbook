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

require 'spec_helper'

describe 'collectd-abiquo::collectd' do
    let(:chef_run) { ChefSpec::ServerRunner.new }

    it 'uses the right Ubuntu package' do
        chef_run.node.automatic['platform'] = 'ubuntu'
        chef_run.converge(described_recipe)

        expect(chef_run.node['collectd_abiquo']['packages']).to eq(['collectd-core', 'libpython2.7'])
        expect(chef_run.node['collectd']['packages']).to eq(['collectd-core', 'libpython2.7'])
    end

    it 'uses the right CentOS package and config' do
        chef_run.node.automatic['platform'] = 'centos'
        chef_run.node.automatic['kernel']['machine'] = 'x86_64'
        chef_run.converge(described_recipe)

        expect(chef_run.node['collectd_abiquo']['packages']).to eq(['collectd'])
        expect(chef_run.node['collectd']['packages']).to eq(['collectd'])
        expect(chef_run.node['collectd']['conf_dir']).to eq('/etc')
        expect(chef_run.node['collectd']['plugin_dir']).to eq('/usr/lib64/collectd')
    end

    it 'uses the right default package' do
        chef_run.node.automatic['platform'] = 'suse'
        chef_run.converge(described_recipe)

        expect(chef_run.node['collectd_abiquo']['packages']).to eq(['collectd'])
        expect(chef_run.node['collectd']['packages']).to eq(['collectd'])
    end

    it 'installs and configures collectd' do
        chef_run.converge(described_recipe)
        expect(chef_run).to include_recipe('collectd-lib::packages')
        expect(chef_run).to include_recipe('collectd-lib::directories')
        expect(chef_run).to include_recipe('collectd-lib::config')
        expect(chef_run).to include_recipe('collectd-lib::service')
    end

    it 'configures the default plugins' do
        chef_run.converge(described_recipe)
        chef_run.node['collectd_abiquo']['plugins'].each do |p|
            expect(chef_run).to create_collectd_conf(p).with(:plugin => p)
        end
    end
end
