## Publish::mixi::echo  -- by big-eyed-hamster
## pragger plugin to post mixi echo
## 
## http://d.hatena.ne.jp/big-eyed-hamster/20090114
##
##
## - module: const_list
##   config:
##     - test_dayo
## - module: Publish::mixi::echo
##

begin
  require 'kconv'
  require 'rubygems'
  require 'mechanize'
  require 'logger'
rescue LoadError
end

def echo( config, data )
  username = $reg['mixi']['username']
  password = $reg['mixi']['password']

  agent = WWW::Mechanize.new
  page = agent.get( 'http://mixi.jp/' )
  form = page.forms[0]
  form.fields.find { |f| f.name == 'email'    }.value = username
  form.fields.find { |f| f.name == 'password' }.value = password
  form.fields.find { |f| f.name == 'next_url' }.value = "/home.pl"    
  page = agent.submit( form, form.buttons.first )

  page = agent.get( 'http://mixi.jp/recent_echo.pl' )

  form = page.forms[1]
  form.fields.find { |f| f.name == 'body' }.value = data.to_s.toeuc
  agent.submit( form,form.buttons.first )
end

