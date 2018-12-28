name             'collectd-abiquo'
maintainer       'Abiquo'
maintainer_email 'ignasi.barrera@abiquo.com'
license          'Apache 2.0'
description      'Installs and configures the Abiquo collectd plugin'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/abiquo/collectd-abiquo-cookbook'
issues_url       'https://github.com/abiquo/collectd-abiquo-cookbook/issues'
version          '0.2.1'

recipe 'collectd-abiquo', 'Installs collectd and the Abiquo monitoring plugin'
recipe 'collectd-abiquo::collectd', 'Installs and configures collectd and the default plugins'
recipe 'collectd-abiquo::plugin', 'Installs and configures the Abiquo collectd plugin'

supports 'centos', '~> 6.7'
supports 'ubuntu', '~> 16.04'

depends 'collectd-lib', '~> 3.1.0'
depends 'python', '~> 1.4.6'
depends 'yum-epel', '~> 2.1.1'
