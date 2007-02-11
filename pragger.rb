#!/usr/bin/env ruby

require "yaml"
require "optparse"

#plugin loader
class Plugin
  def initialize(folder = "./plugin")
    Dir::glob(folder + "/*.rb").sort.each do |file|
      load_plugin(file)
    end
  end
  def load_plugin(file)
    File.open(file) do |src|
      instance_eval( src.read , file , 1)
    end
  end
end

#config roader
class Config
  def initialize()
  end
  
  attr_accessor :command_array
  
  def self.load_file(fname)
    c = Config.new
    c.command_array = YAML.load_file(fname)
    return c
  end
  
  def self.load_array(array)
    c = Config.new
    c.command_array = array
    return c
  end
  
  def eval()
    return eval_pragger(@command_array,[])
  end
end

#interpritor
def eval_pragger(command_array,data)
  command_array.each do|command|
    puts "exec plugin " + command["module"] + "(" + command["config"].to_s + ")"
    data = $plugin.send(command["module"],command["config"],data.clone)
  end
  return data
end

#main

#option 
pluginDir = "./plugin"
configFile = "config.yaml"

OptionParser.new do|opt|
  opt.on("-c", "--configfile CONFIGFILE"){|v| configFile = v }
  opt.on("-p", "--plugindir PLUGINDIR"){|v| pluginDir= v }
  opt.parse!(ARGV)
end

$plugin = Plugin.new(pluginDir)
config = Config.load_file(configFile)
config.eval()

