#!/usr/bin/env ruby
$KCODE='utf8'
require 'yaml'
require 'optparse'
require 'kconv'

class Plugin
  def initialize(file)
      instance_eval( File.read(file).toutf8 , file , 1)
  end
  def self.load_plugins(folder = "plugin")
    Dir.glob(File.join(folder, "**/*.rb")).sort.inject({}).each do |plugins,file|
      plugins[ file[b.size..-1].to_s.gsub("/","::")[0..-4] ] = Plugin.new(file)
    end
  end
end

def eval_pragger(command_array,data)
  command_array.inject({}) do|data,command|
    puts "exec plugin #{command["module"]}"
    $plugin[command["module"]].send(command["module"].sub(/.*::/,""), command["config"], data.clone)
  end
  return data
end

baseDir = File.readlink(__FILE__) rescue (__FILE__)
pluginDir = File.join(File.dirname(baseDir), "plugin")
configFile = "config.yaml"
OptionParser.new do|opt|
  opt.on("-c", "--configfile CONFIGFILE"){|v| configFile = v }
  opt.on("-p", "--plugindir PLUGINDIR"){|v| pluginDir= v }
  opt.on("-u", "--pluginusage [PLUGINNAME]"){|v| 
    if(v==nil)
      Plugin.load_plugin(pluginDir).each{|k,v| puts k }
    else
      File.read(File.join(pluginDir,v.gsub("::","/")+".rb")).sub(/#(.*)/){ puts $1 }
    end
    exit
  }
  opt.parse!(ARGV)
end

$plugin = Plugin.load_plugins(pluginDir)
eval_pragger(YAML.load(File.read(configFile).toutf8),[])
