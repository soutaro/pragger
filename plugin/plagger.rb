# ** what's this **
#
# interleave plagger processing.
# 
# ** example **
#
# - module: load_rss
#   config:
#     url: http://d.hatena.ne.jp/sumii/rss
# - module: plagger
#   config:
#     input: feed
#     debug: on
#     plugins: 
#       - module: Publish::CSV
#         config: 
#           dir: /var
#           filename: a.csv
# - module: print
#   config:
#     a: nil
#

def plagger(config, data)
  require 'open-uri'
  require 'rss/1.0'
  require 'rss/2.0'
  require 'pathname'
  require File.join(File.dirname(__FILE__),'save_rss.rb')

  Plagger.new.plagger(config, data)
end

class Plagger
  def plagger(config, data)
    pla_con = config["plugins"]
    
    if input_option(config) == :feed
      pla_con = [{"module" => "Subscription::Feed", "config"=>{ "url" => "file:#{pla_input(config)}" }}] + pla_con
      save_rss({ "filename" => pla_input(config).to_s }, data)
    end
    
    pla_con.push({"module" => "Publish::Feed",
                   "config" =>
                   {"dir" => "/var",
                     "format" => "RSS",
                     "filename" => pla_output(config).basename.to_s}})

    pla_config(config).open("w") {|io|
      io.write to_plagger_yaml(YAML.dump({ "plugins" => pla_con }))
    }
    
    system "plagger -c #{pla_config(config)}"
    
    begin
      RSS::Parser.parse(pla_output(config).read).items
    rescue
      []
    ensure
      unless config.has_key?("debug")
        begin
          pla_config(config).delete
          pla_input(config).delete
          pla_output(config).delete
        rescue a
          pp a
        end
      end
    end
  end
  
  def pla_dir(config)
    Pathname.new(config.has_key?("dir") ? config["dir"] : "/var")
  end
  
  def pla_config(config)
    pla_dir(config) + "pla.yaml"
  end
  
  def pla_output(config)
    pla_dir(config) + "pla_output"
  end
  
  def pla_input(config)
    pla_dir(config) + "pla_input"
  end
  
  def input_option(config)
    opt = config.has_key?("input") ? config["input"] : "nothing"
    case opt
    when "feed": :feed
    when "nothing": :nothing
    else
      :nothing
    end
  end

  def to_plagger_yaml(yaml)
    a = yaml.split(/\n/)
    ret = a[1]+"\n"
    ret + a[2..(a.size-1)].collect {|x|
      "  "+x
    }.join("\n")+"\n"
  end
end

