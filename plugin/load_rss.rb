
require 'open-uri'
require 'rss/1.0'
require 'rss/2.0'

def load_rss(config,data)
  rss_source = ""
  open(config["url"]) {|r| rss_source=r.read }
  rss = nil
  begin
    rss = RSS::Parser.parse(rss_source)
  rescue RSS::InvalidRSSError
    rss = RSS::Parser.parse(rss_source, false)
  end
  return rss.items rescue []
end

