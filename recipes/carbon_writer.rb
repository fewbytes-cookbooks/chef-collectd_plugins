
carbon = provider_for_service 'graphite-carbon'

# If there's no provider for graphite-carbon, skip
if !carbon.nil? and !carbon.empty?
  include_recipe "collectd_plugins"
  include_recipe "collectd"

  cookbook_file ::File.join(node['collectd']['plugin_dir'], "carbon_writer.py") do
    owner "root"
    group "root"
    mode "644"
    notifies :restart, "service[collectd]"
  end

  collectd_python_plugin "carbon_writer" do
    options 'LineReceiverHost' => ((carbon['ec2'] and carbon['ec2']['public_ipv4']) or carbon['hostname']),
      'LineReceiverPort' => carbon['graphite']['carbon']['line_receiver_port'],
      'TypesDB' => node['collectd']['types_db'],
      'DifferentiateCounters' => true, 'DifferentiateCountersOverTime' => true,
      'MetricPrefix' => "collectd.generic"
  end
end
