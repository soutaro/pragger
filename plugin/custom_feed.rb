#plugin custom_feed
def custom_feed(config,data)
  require 'open-uri'
  require 'kconv'
  open(config['url']){|r| data = [r.read.toutf8] } if(config['url'])
  items = []
  data.each do |input|
    body = ""
    pp(config['capture'])
    if(config['capture'])
      input =~ Regexp.new(config['capture'],Regexp::MULTILINE)
      body = $1
    else
      body = input
    end
    
    if(config['split'])
      body.gsub(Regexp.new(config['split'],Regexp::MULTILINE)) do
        items.push $1
      end
    else
      items.push body
    end
  end
  
  if(config['title'])
    title = Regexp.new(config['title'])
    items.each do|i|
      i =~ title
      mytitle = $1
      i.instance_eval do 
        @title = mytitle
        def title
          @title
        end
      end
    end
  end

  return items
end
