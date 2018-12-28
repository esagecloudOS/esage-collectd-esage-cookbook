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

module AbiquoCollectd
    module Config
        def abiquo_config
            abiquo_writer_config = {
                'Authentication' => node['collectd_abiquo']['auth_type'],
                'URL' => node['collectd_abiquo']['endpoint'],
                'FlushIntervalSecs' => node['collectd_abiquo']['flush_interval_secs']
            }

            # The verify ssl must only be present when true
            if node['collectd_abiquo']['verify_ssl']
                abiquo_writer_config['VerifySSL'] = node['collectd_abiquo']['verify_ssl']
            end

            credentials = data_bag_item(node['collectd_abiquo']['credentials_data_bag'], "collectd_#{node['collectd_abiquo']['auth_type']}")

            case node['collectd_abiquo']['auth_type']
            when 'oauth'
                abiquo_writer_config.merge!({
                    'ApplicationKey' => credentials['app_key'],
                    'ApplicationSecret' => credentials['app_secret'],
                    'AccessToken' => credentials['access_token'],
                    'AccessTokenSecret' => credentials['access_token_secret']
                })
            when 'basic'
                abiquo_writer_config.merge!({
                    'Username' => credentials['username'],
                    'Password' => credentials['password']
            })
            else
                Chef::Application.fatal!('Attribute node["collectd_abiquo"]["auth_type"] must "oauth" or "basic"')
            end
        end
    end
end
