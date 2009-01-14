## Feed::mixi::get_echo plugin -- by big-eyed-hamster
##
##  http://d.hatena.ne.jp/big-eyed-hamster/20090113
##
## sample
## - module: Feed::mixi::get_echo_list
##   config:
##     id: 00000000
## - module: RSS::save
##   config:
##     filename: output.rdf
##     title: mixi echo
##

begin 
  require 'kconv'
  require 'rubygems'
  require 'mechanize'
  require 'logger'
rescue LoadError
end

def get_echo_list( config, data )
  username = $reg['mixi']['username']
  password = $reg['mixi']['password']
    
  agent = WWW::Mechanize.new
  page = agent.get( 'http://mixi.jp/' )
  form = page.forms[0]
  form.fields.find { |f| f.name == 'email'    }.value = username
  form.fields.find { |f| f.name == 'password' }.value = password
  form.fields.find { |f| f.name == 'next_url' }.value = "/home.pl"    
  page = agent.submit( form, form.buttons.first )

  contents = []

  data << config['id'].to_s if config['id']
  data.each do |id|
    html = agent.get("http://mixi.jp/list_echo.pl?id=#{id}").root
    html.search("div.archiveList").each do |div|
      div.search("tr").each do |tr|
        contents << [
            tr.search("div")[0].inner_html,                           # id
            tr.search("div")[2].inner_html,                           # nickname 
            tr.search("td.comment")[0].inner_html.gsub(
                /<span.*$/m,"").gsub(/<.*?>/,"").gsub(/\n+/,"\n") ,   # comment
            tr.search("div")[1].inner_html,                           # datetime
          ]
      end
    end
    sleep 5
  end

  echo_item = Struct.new(:title,:description,:link)
  return contents.map{|c| echo_item.new( c[1], c[2],"http://mixi.jp/list_echo.pl?id=#{c[0]}##{c[3]}" )}
end


