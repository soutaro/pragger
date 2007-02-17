
def load_rss(config,data)
  require 'open-uri'
  require 'rss/1.0'
  require 'rss/2.0'
  require 'rss/maker'

  rss_source = ""
  begin
    open(config["url"]) {|r| rss_source=r.read }
  rescue
    puts "LoadError File = #{config["url"]}"
    return []
  end
  rss = nil
  begin
    rss = RSS::Parser.parse(rss_source)
  rescue RSS::InvalidRSSError
    rss = RSS::Parser.parse(rss_source, false)
  end
  return rss.items rescue []
end

