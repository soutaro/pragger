
@count = Time.now.to_i

def save_rss(config,data)
  require "rss/maker"

  rss = RSS::Maker.make("1.0") do |maker|
    maker.channel.about = config['about'] || config['link'] || "http://example.net/"
    maker.channel.title = config['title'] || "Pragger output"
    maker.channel.description = config['description'] || ""
    maker.channel.link = config['link'] || "http://example.net/"
    
    data.each do |i|
      if(i.instance_of?(RSS::RDF::Item))
        i.setup_maker(maker)
      else 
        item = maker.items.new_item
        item.title = i.title rescue i.to_s
        item.link = i.link rescue (config['link'] || "http://example.net/") + "\##{@count}"
        item.description = i.description rescue i.to_s
        item.date = i.date rescue Time.now
        @count += 1
      end
    end
  end
  open(config["filename"],"w"){|w| w.puts rss }
  return data
end


