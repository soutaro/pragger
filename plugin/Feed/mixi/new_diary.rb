require 'rubygems'
require 'mechanize'

def new_diary(config,data)
  username = $reg['mixi']['username']
  password = $reg['mixi']['password']

  client = WWW::Mechanize.new
  page = client.get('http://mixi.jp/')
  sleep 5
  form = page.forms[0]
  form.fields.find {|f| f.name == 'email'}.value = username
  form.fields.find {|f| f.name == 'password'}.value = password
  form.fields.find {|f| f.name == 'next_url'}.value = '/home.pl'
  page = client.submit(form, form.buttons.first)
  sleep 5

  if /url=([^"])"/ =~ page.body
    link = 'http://mixi.jp' + $1.to_s
    client.get(link)
    sleep 5
  end

  data = []
  diarylist = client.get('http://mixi.jp/new_friend_diary.pl')
  sleep 5
  loop do
    diarylist.links.each do |link|
      diaryurl = link.href # => 'view_diary.pl?id=12345&owner_id=2345'
      if /view_diary.pl\?id\=/ =~ diaryurl then
        item = 'http://mixi.jp/' + diaryurl
        item.instance_eval do
          @title = link.text
          def title
            @title
          end
        end
        data << item
      end
    end
    nextlink = diarylist.links.find(){|i| i.href =~ /new_friend_diary\.pl\?page\=\d\&direction\=next/ }
    if(nextlink != nil)
      diarylist = nextlink.click
      sleep 5
    else
      break
    end
  end
  return data
end
