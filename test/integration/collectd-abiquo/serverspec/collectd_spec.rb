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

describe 'Collectd installation' do
    it 'all collectd packages are installed' do
        if os[:family] == 'ubuntu'
            expect(package('collectd-core')).to be_installed
            expect(package('libpython2.7')).to be_installed
        else
            expect(package('collectd')).to be_installed
        end
    end

    it 'all configuration files are present' do
        if os[:family] == 'ubuntu'
            expect(file('/etc/collectd/collectd.conf')).to exist
            expect(file('/usr/lib/collectd')).to be_directory
        else
            expect(file('/etc/collectd.conf')).to exist
            if os[:arch] == 'x86_64'
                expect(file('/usr/lib64/collectd')).to be_directory
            else
                expect(file('/usr/lib/collectd')).to be_directory
            end
        end
    end

    it 'the default plugins are installed' do
        config_file = os[:family] == 'ubuntu'? '/etc/collectd/collectd.conf' : '/etc/collectd.conf'
        expect(file(config_file)).to contain('LoadPlugin "cpu"')
        expect(file(config_file)).to contain('LoadPlugin "memory"')
        expect(file(config_file)).to contain('LoadPlugin "disk"')
        expect(file(config_file)).to contain('LoadPlugin "interface"')
    end

    it 'the collectd service is running' do
        expect(service('collectd')).to be_enabled
        expect(service('collectd')).to be_running
    end
end
