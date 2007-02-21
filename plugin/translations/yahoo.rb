# translate input strings by Yahoo Honyaku (requires WWW::Mechanize)

begin
  require 'rubygems'
rescue LoadError
end
require 'mechanize'

def yahoo(config, data)
  config = (config || { "translation" => "en=>ja" })

  trans = case config["translation"]
          when "en=>ja": "EJ"
          when "kr=>ja": "KJ"
          when "cn=>ja": "CJ"
          when "ja=>en": "JE"
          when "ja=>kr": "JK"
          when "ja=>cn": "JC"
          else
            return data
          end
  
  data.collect {|d|
    agent = WWW::Mechanize.new
    start = agent.get("http://honyaku.yahoo.co.jp/")
    form = start.forms.last
    
    form.radiobuttons.each {|radio| radio.checked = (radio.value =~ /#{trans}/) ? true : false }
    form.fields.name("text").first.value = d

    result = agent.submit(form)
    result.forms.name("textFormEntry").fields.name("trn_text").value
  }

end
