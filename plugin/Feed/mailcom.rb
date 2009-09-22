## Get mail lists from http://mail.com

begin
  require 'rubygems'
rescue LoadError
end
require 'mechanize'

def mailcom(config, data)
  agent = WWW::Mechanize.new
  page = agent.get("http://mail.com")
  form = page.forms[1]
  form.fields.find{|f| f.name == 'login'}.value = $reg['mailcom']['username']
  form.fields.find{|f| f.name == 'password'}.value = $reg['mailcom']['password']
  page = agent.submit(form,form.buttons.first)

  page = agent.get(page.frames[1].uri)

  page = agent.get("http://mail01.mail.com/scripts/mail/mailbox.mail?folder=INBOX")

  result = []
  page.links.each do|l|
    uri = l.uri.to_s rescue ""
    if uri =~ /\/scripts\/mail\/read\.mail/
      result.push MailComRSSItem.new(l)
    end
  end
  return result
end

class MailComRSSItem
  def initialize (link)
    @link = link
  end

  def title
    @link.text
  end
  def link
    "http://mail01.mail.com" + @link.href.sub(/&mprev=.*/,"")
  end
  def description
    @link.text
  end
  def to_s
    @link.text + " \nhttp://mail01.mail.com" + @link.href.sub(/&mprev=.*/,"") + "\n\n\n\n"
  end
end
