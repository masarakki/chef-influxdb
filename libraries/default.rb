# libraries/influxdb.rb
#
# Author: Simple Finance <ops@simple.com>
# License: Apache License, Version 2.0
#
# Copyright 2014 Simple Finance Technology Corporation
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
#
# Helper methods for managing InfluxDB

require 'chef/resource/package'
require 'chef/resource/chef_gem'
module InfluxDB
  module Helpers

    INFLUXDB_CONFIG = '/opt/influxdb/shared/config.toml'

    # TODO : Configurable administrator creds
    def self.client(user = 'root', pass = 'root', run_context)
      self.install_influxdb(run_context)
      self.require_influxdb
      InfluxDB::Client.new(username: user, password: pass)
    end

    def install_influxdb(_source, _checksum)
      path = ::File.join(Chef::Config[:file_cache_path], 'influxdb.deb')

      remote_file path do
        source _source if _source
        checksum _checksum if _checksum
        action :create
      end

      package path do
        provider Chef::Provider::Package::Dpkg
        action :install
      end
    end

    def install_config(hash)
      install_toml
      require_toml
      config_file(hash)
    end

    def install_service
      service "influxdb" do
        action [:enable, :start]
        subscribes :restart, resources(file: INFLUXDB_CONFIG)
      end
    end

    def install_toml
      gem "toml"
    end

    def require_toml
      require 'toml'
    end

    def self.require_influxdb
      require 'influxdb'
    end

    def config_file(hash)
      file INFLUXDB_CONFIG do
        owner 'root'
        mode  00644
        content TOML::Generator.new(hash).body
        action :create
      end
    end
  end
end
