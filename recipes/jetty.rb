#
# Cookbook Name:: collectd_plugins
# Recipe:: memory
#
# Copyright 2010, Atari, Inc
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

include_recipe "collectd"

collectd_java_plugin "GenericJMX" do
  class_name "org.collectd.java.GenericJMX"
  options (
  {
    "MBean" => [
      { :_name => "garbage_collector",
        "ObjectName" => "java.lang:type=GarbageCollector,*",
        "InstancePrefix" => "gc-",
        "InstanceFrom" => "name",
        "Value" => [{
          "Type" => "invocations",
          "Table" => false,
          "Attribute" => "CollectionCount"
        },
        {
          "Type" => "total_time_in_ms",
          "InstancePrefix" => "collection_time",
          "Table" => false,
          "Attribute" => "CollectionTime"
        }]
      },
      {:_name => "memory_pool",
        "ObjectName" => "java.lang:type=MemoryPool,*",
        "InstancePrefix" => "memory_pool-",
        "InstanceFrom" => "name",
        "Value" => {
          "Type" => "memory",
          "Table" => true,
          "Attribute" => "Usage"
        }
      }
    ],
    "Connection" => {
      "Host" => node["fqdn"],
      "ServiceURL" => "service:jmx:rmi:///jndi/rmi://localhost:#{node["jetty"]["jmx"]["port"]}/jmxrmi",
      "Collect" => [
        "garbage_collector",
        "memory_pool",
      ]
    }
  }
)
end
