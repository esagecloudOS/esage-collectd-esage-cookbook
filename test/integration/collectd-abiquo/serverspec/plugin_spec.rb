
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

require 'serverspec_helper'

describe 'Plugin configuration' do
    it 'all python dependencies are installed' do
        expect(command('pip freeze').stdout).to contain('requests==2.5.0')
        expect(command('pip freeze').stdout).to contain('requests-oauthlib==0.4.2')
    end

    it 'the abiquo-writer plugin is installed' do
        config_file = os[:family] == 'ubuntu'? '/etc/collectd/collectd.conf' : '/etc/collectd.conf'
        plugin_dir = os[:family] != 'ubuntu' && os[:arch] == 'x86_64'? '/usr/lib64/collectd' : '/usr/lib/collectd'
        
        expect(file("#{plugin_dir}/abiquo-writer.py")).to exist
        expect(file(config_file)).to contain('<Plugin "python">')
        expect(file(config_file)).to contain("ModulePath \"#{plugin_dir}\"")
        expect(file(config_file)).to contain('LogTraces true')
        expect(file(config_file)).to contain('Interactive false')
        expect(file(config_file)).to contain('Import "abiquo-writer"')
        expect(file(config_file)).to contain('<Module "abiquo-writer">')
        expect(file(config_file)).to contain('Authentication "oauth"')
        expect(file(config_file)).to contain('URL "http://localhost"')
        expect(file(config_file)).to contain('ApplicationKey "api-key"')
        expect(file(config_file)).to contain('ApplicationSecret "api-secret"')
        expect(file(config_file)).to contain('AccessToken "access-token"')
        expect(file(config_file)).to contain('AccessTokenSecret "access-token-secret"')
    end
end
