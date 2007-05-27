## Get Hatena Graph data
## 
## see http://d.hatena.ne.jp/takatoh/20070518/pragger
##
## - module: Feed::hatena_graph
##   config:
##     user_id: your-hatena-user-id
##     password: your-password
##     graph_name: the-name-of-graph

begin
  require 'rubygems'
rescue LoadError
end
require 'mechanize'
require 'uri'
require 'kconv'
require 'csv'

class HatenaGraph
  def initialize(id,password)
    @id = id
    @password = password
    @agent = WWW::Mechanize.new
    if proxy = ENV['http_proxy']
      proxy = URI.parse(proxy)
      @agent.set_proxy(proxy.host, proxy.port)
    end
    @graph = @agent.get("http://graph.hatena.ne.jp/#{id}/")
  end

  def login
    login_link = @graph.links.text("ログイン".toutf8)
    login_page = @agent.get(login_link.href)
    login_form = login_page.forms.first
    login_form['key'] = @id
    login_form['password'] = @password
    redirect_page = @agent.submit(login_form)
    @graph_link = redirect_page.links.text("こちら".toutf8)
    @graph_page = @agent.get(@graph_link.href)
  end

  def fetch_csv
    @data_link = @graph_page.links.text("データ".toutf8)
    @data_page = @agent.get(@data_link.href)
    csv_link = @data_page.links.text("ダウンロード".toutf8)
    csv_file = @agent.get(csv_link.href)                    # => WWW::Mechanize::File
    tmpfile = Tempfile.open("hatenagraph")
    path = tmpfile.path
    csv_file.save_as(path)
    tmpfile.close
    path
  end
end

def hatena_graph(config, data)
  graph = HatenaGraph.new(config['user_id'], config['password']) 
  graph.login
  csvpath = graph.fetch_csv
  csv = CSV.open(csvpath, "r").map{|r| r }
  graph_names = csv.shift
  i = graph_names.index(config['graph_name'].tosjis)
  csv.map{|r| r[i].to_f }
end
