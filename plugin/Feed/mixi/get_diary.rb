require 'kconv'
require 'rubygems'
require 'mechanize'

def get_diary(config,data)
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

  data = data.map do|i|
    page = client.get(i)
  sleep 5
    MixiRSSItem.new(page,i)
  end
  return data
end

class MixiRSSItem
  def initialize(page,url)
    @page = page
    @url = url
  end
  def title
    @page.title.toutf8
  end
  def link
    @url
  end
  def description
    if(@page.body =~ /\<\!\-\-\[viewDiaryBox\]\-\-\>(.*)\<\!\-\-\/viewDiaryBox\-\-\>/m)
      $1.toutf8
    end
  end
  def date
    if(@page.body =~ /(\d{2})年(\d{2})月(\d{2})日(\d{2}):(\d{2})/)
       p Time.new($1,$2,$3,$4,$5)
       Time.new($1,$2,$3,$4,$5)
    end
  end

  def to_s
    title + ":" + link + ":" + description + ":" + date
  end

end
