#!/usr/bin/env ruby -Ku -ryaml -roptparse -rkconv -rpathname -rpp
$plugins = {}
class Plugin
  attr_reader :source
  def initialize(file)
    instance_eval( @source = File.read(file).toutf8, file , 1)
  end
  def self.load_plugins(folder = (Pathname.new(__FILE__).realpath.parent + "plugin"))
    Pathname.glob(File.join(folder, "**/*.rb")).sort.each do |file|
      begin
        $plugins.update file.relative_path_from(folder).to_s.gsub("/","::")[0..-4] => Plugin.new(file)
      rescue LoadError
      end
    end
  end
end

def eval_pragger(command_array,data)
  command_array.inject(data) do |data,command|
    puts "exec plugin #{command["module"]}"
    $plugins[command["module"]].send(command["module"].sub(/.*::/,""), command["config"] || {}, data.clone)
  end
end

Plugin.load_plugins()
configFile = "config.yaml"
OptionParser.new do |opt|
  opt.on("-c", "--configfile CONFIGFILE") {|v| configFile = v }
  opt.on("-p", "--plugindir PLUGINDIR") {|v| Plugin.load_plugins Pathname.new(v) }
  opt.on("-u", "--pluginusage PLUGINNAME") {|v| $plugins[v].source.gsub(/^##(.*)/){ puts $1 }; exit }
  opt.on("-l", "--listplugin") { $plugins.keys.sort.each{|k| puts k }; exit }
  opt.parse!(ARGV)
end

eval_pragger(YAML.load(File.read(configFile).toutf8),[])
