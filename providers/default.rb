# providers/default.rb
#
# Author: Simple Finance <ops@simple.com>
# License: Apache License, Version 2.0
#
# Copyright 2013 Simple Finance Technology Corporation
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
# LWRP for InfluxDB instance

include InfluxDB::Helpers

def initialize(new_resource, run_context)
  super
  @source = new_resource.source
  @checksum = new_resource.checksum
  @config = new_resource.config
  @run_context = run_context
end

action :create do
  install_influxdb(@source, @checksum)
  install_config(@config)
  install_service
end
