#!/usr/local/bin/ruby
$KCODE='u'
require 'yaml'
require 'optparse'
require 'kconv'
require 'pathname'
require 'base64'

$plugins = {}
class Plugin
  attr_reader :source
  def initialize(file)
    instance_eval( @source = File.read(file).toutf8, file.to_s , 1)
  end
  def self.load_plugins(folder = (Pathname(__FILE__).parent + "plugin"))
    Pathname.glob(folder.to_s + "/**/*.rb").sort.each do |file|
      begin
        $plugins[ file.relative_path_from(folder).to_s.gsub("/","::")[0..-4] ]= Plugin.new(file)
      rescue LoadError
      end
    end
  end
end

def eval_pragger(command_array,data)
  (command_array || []).inject(data) do |data, command|
    $plugins[command["module"]].send(command["module"].sub(/.*::/,""), command["config"] || {}, data.clone)
  end
end

Plugin.load_plugins()
configFile = "config.yaml"
opt = OptionParser.new
opt.on("-c", "--configfile CONFIGFILE") {|v| configFile = v }
opt.on("-p", "--plugindir PLUGINDIR") {|v| Plugin.load_plugins(Pathname(v)) }
opt.on("-u", "--pluginusage PLUGINNAME") {|v| $plugins[v].source.gsub(/^## ?(.*)/){ puts $1 }; exit }
opt.on("-l", "--listplugin") { $plugins.keys.sort.each{|k| puts k }; exit }
opt.on("-w", "--where") { puts(Pathname(__FILE__).parent + "plugin"); exit }
opt.parse!

eval_pragger(YAML.load(File.read(configFile).toutf8.gsub(/base64::([\w+\/]+=*)/){ Base64.decode64($1) }),[])
