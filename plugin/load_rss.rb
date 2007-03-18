require 'open-uri'
require 'rss/1.0'
require 'rss/2.0'
require 'rss/maker'

def load_rss(config, data)
  begin
    rss_source = 
      if config['url'].is_a?(Array)
        config['url'].map {|url| open(url) {|io| io.read } }
      else
        open(config['url']) {|r| r.read }
      end
  rescue
    puts "LoadError File = #{config["url"]}"
    return []
  end
  
  feeds = rss_source.collect {|cont|
    begin
      RSS::Parser.parse(cont)
    rescue RSS::InvalidRSSError
      RSS::Parser.parse(cont, false)
    end
  }
  
  feeds.select {|f| f}.inject([]) {|acc,f| acc + f.items }
end

