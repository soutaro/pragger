#!/usr/bin/env ruby
$KCODE='utf8'
require 'yaml'
require 'optparse'
require 'kconv'
require 'pathname'

$plugins = {}
class Plugin
  attr_reader :source
  def initialize(file)
    @source = File.read(file).toutf8
    instance_eval( @source, file , 1)
  end
  def self.load_plugins(folder = (Pathname.new(__FILE__).realpath.parent + "plugin"))
    Pathname.glob(File.join(folder, "**/*.rb")).sort.each do |file|
      $plugins.update file.relative_path_from(folder).to_s.gsub("/","::")[0..-4] => Plugin.new(file)
    end
  end
end

def eval_pragger(command_array,data)
  command_array.inject({}) do |data,command|
    puts "exec plugin #{command["module"]}"
    $plugins[command["module"]].send(command["module"].sub(/.*::/,""), command["config"], data.clone)
  end
end

Plugin.load_plugins()
configFile = "config.yaml"
OptionParser.new do |opt|
  opt.on("-c", "--configfile CONFIGFILE") {|v| configFile = v }
  opt.on("-p", "--plugindir PLUGINDIR") {|v| Plugin.load_plugins v }
  opt.on("-u", "--pluginusage PLUGINNAME") {|v| $plugins[v].source.gsub(/^##(.*)/){ puts $1 }; exit }
  opt.on("-l", "--listplugin") { $plugins.keys.sort.each{|k| puts k }; exit }
  opt.parse!(ARGV)
end

eval_pragger(YAML.load(File.read(configFile).toutf8),[])
