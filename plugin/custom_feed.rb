#plugin custom_feed
def custom_feed(config,data)
  require 'open-uri'
  require 'kconv'
  open(config['url']){|r| data = [r.read.toutf8] } if(config['url'])
  items = []
  data.each do |input|
    body = ""
    if(config['capture'])
      if input =~ Regexp.new(config['capture'],Regexp::MULTILINE)
        body = $1
      end
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
      if i =~ title
        mytitle = $1
        i.instance_eval do 
          @title = mytitle
          def title
            @title
          end
        end
      end
    end
  end

  if(config['date'])
    date = Regexp.new(config['date'])
    items.each do|i|
      if i =~ date
        mydate = Time.parse($1)
        i.instance_eval do
          @date = mydate
          def date
            @date
          end
        end
      end
    end
  end

  if config['link'] and config['url']
    link = Regexp.new(config['link'])
    items.each do|i|
      if i =~ link
        mylink = config['url'] ? (config['url'] + '#' + $1) : $1 
        i.instance_eval do
          @link = mylink
          def link
            @link
          end
        end
      end
    end
  end
  
  return items
end
