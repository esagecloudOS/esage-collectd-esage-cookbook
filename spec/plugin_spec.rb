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

describe 'collectd-abiquo::plugin' do
    let(:chef_run) do
        ChefSpec::ServerRunner.new do |node, server|
            node.automatic['platform'] = 'ubuntu'
            node.set['collectd_abiquo']['endpoint'] = 'http://localhost'
            server.create_data_bag('abiquo_credentials', {
              'collectd_basic' => {
                'username' => 'user',
                'password' => 'pass'
              },
              'collectd_oauth' => {
                'app_key' => 'app-key',
                'app_secret' => 'app-secret',
                'access_token' => 'access-token',
                'access_token_secret' => 'access-token-secret'
              }
            })
        end
    end

    it 'installs the python dependencies' do
        chef_run.converge(described_recipe)
        expect(chef_run).to include_recipe('python::pip')
        expect(chef_run).to install_python_pip('requests').with(:version => '2.5.0')
        expect(chef_run).to install_python_pip('requests-oauthlib').with(:version => '0.4.2')
    end

    it 'uploads the Abiquo plugin script' do
        chef_run.converge(described_recipe)
        expect(chef_run).to create_remote_file('/usr/lib/collectd/abiquo-writer.py').with(
            :source => 'https://rawgit.com/abiquo/collectd-abiquo/0.0.1/abiquo-writer.py'
        )
    end

    it 'configures the Abiquo collectd plugin with OAuth' do
        chef_run.converge(described_recipe)
        expect(chef_run).to create_collectd_conf('abiquo-writer').with({
            :plugin => { 'python' => { 'Globals' => true } },
            :conf => { 'ModulePath' => '/usr/lib/collectd',
                'LogTraces' => true,
                'Interactive' => false,
                'Import' => 'abiquo-writer',
                %w(Module abiquo-writer) => {
                    'Authentication' => 'oauth',
                    'URL' => 'http://localhost',
                    'FlushIntervalSecs' => 30,
                    'ApplicationKey' => 'app-key',
                    'ApplicationSecret' => 'app-secret',
                    'AccessToken' => 'access-token',
                    'AccessTokenSecret' => 'access-token-secret'
                }
            }
        })
    end

    it 'configures the Abiquo collectd plugin with basic auth' do
        chef_run.node.set['collectd_abiquo']['auth_type'] = 'basic'
        chef_run.converge(described_recipe)
        expect(chef_run).to create_collectd_conf('abiquo-writer').with({
            :plugin => { 'python' => { 'Globals' => true } },
            :conf => { 'ModulePath' => '/usr/lib/collectd',
                'LogTraces' => true,
                'Interactive' => false,
                'Import' => 'abiquo-writer',
                %w(Module abiquo-writer) => {
                    'Authentication' => 'basic',
                    'URL' => 'http://localhost',
                    'FlushIntervalSecs' => 30,
                    'Username' => 'user',
                    'Password' => 'pass'
                }
            }
        })
    end

    it 'configures the Abiquo collectd plugin with SSL verification' do
        chef_run.node.set['collectd_abiquo']['auth_type'] = 'basic'
        chef_run.node.set['collectd_abiquo']['verify_ssl'] = true
        chef_run.converge(described_recipe)
        expect(chef_run).to create_collectd_conf('abiquo-writer').with({
            :plugin => { 'python' => { 'Globals' => true } },
            :conf => { 'ModulePath' => '/usr/lib/collectd',
                'LogTraces' => true,
                'Interactive' => false,
                'Import' => 'abiquo-writer',
                %w(Module abiquo-writer) => {
                    'Authentication' => 'basic',
                    'URL' => 'http://localhost',
                    'VerifySSL' => true,
                    'FlushIntervalSecs' => 30,
                    'Username' => 'user',
                    'Password' => 'pass'
                }
            }
        })
    end
end
