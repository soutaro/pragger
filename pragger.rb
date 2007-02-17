#!/usr/bin/env ruby

$KCODE='utf8'

require "yaml"
require "optparse"
require "kconv"
require "pp"

#plugin loader
class Plugin
  def initialize(folder = "./plugin")
    Dir::glob(File.join(folder, "*.rb")).sort.each do |file|
      load_plugin(file)
    end
  end
  def load_plugin(file)
    File.open(file) do |src|
      instance_eval( src.read , file , 1)
    end
  end
end

#config loader
class Config
  def initialize()
  end
  
  attr_accessor :command_array
  
  def self.load_file(fname)
    c = Config.new
    c.command_array = YAML.load(File.read(fname).toutf8)
    return c
  end
  
  def self.load_array(array)
    c = Config.new
    c.command_array = array
    return c
  end
  
  def eval()
    return eval_pragger(@command_array, [])
  end
end

#interpritor
def eval_pragger(command_array,data)
  command_array.each do|command|
    puts "exec plugin #{command["module"]}(#{(command["config"]||[]).collect{|k,v| "#{k}=#{v}"}.join(", ")})"
    data = $plugin.send(command["module"], command["config"], data.clone)
  end
  return data
end

#main

#option 
pluginDir = ""
if File.symlink?(__FILE__)
	pluginDir = File.join(File.dirname(File.readlink(__FILE__)), "plugin")
else 
	pluginDir = File.join(File.dirname(__FILE__), "plugin")
end

configFile = "config.yaml"

OptionParser.new do|opt|
  opt.on("-c", "--configfile CONFIGFILE"){|v| configFile = v }
  opt.on("-p", "--plugindir PLUGINDIR"){|v| pluginDir= v }
  opt.parse!(ARGV)
end

$plugin = Plugin.new(pluginDir)
config = Config.load_file(configFile)
config.eval()

