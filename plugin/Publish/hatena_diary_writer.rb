#!/usr/bin/env ruby
# hatena_diary_writer.rb
#

class HatenaDiaryWriter
  def initialize(id,password)
    @id = id
    @password = password
    @agent = WWW::Mechanize.new
    @diary = @agent.get("http://d.hatena.ne.jp/#{id}/")
  end

  def login
    login_link = @diary.links.text("ログイン".toeuc)
    login_page = @agent.get(login_link.href)
    login_form = login_page.forms.first
    login_form['key'] = @id
    login_form['password'] = @password
    redirect_page = @agent.submit(login_form)
    @diary_link = redirect_page.links.text("こちら".toutf8)
    @diary_page = @agent.get(@diary_link.href)
  end

  def edit(content)
    edit_link = @diary_page.links.text("日記を書く".toeuc)
    edit_page = @agent.get(edit_link.href)
    edit_form = edit_page.forms.name("edit").first
    edit_form["body"] += content
    ok_button = edit_form.buttons.name("edit")
    @agent.submit(edit_form, ok_button)
  end
end

def hatena_diary_writer(config, data)
  require 'rubygems'
  require 'mechanize'
  require 'kconv'

  diary = HatenaDiaryWriter.new(config['user_id'], config['password']) 
  content = ''
  data.each do |line|
    content << ("* "+line.title+"\n"+line.link+"\n"+line.description rescue line.to_s)
  end
  diary.login
  diary.edit(content.toeuc)
end
