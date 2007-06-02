## Post data to Hatena Graph -- takatoh
## 
## hatenaapigraph 0.1.2 is required.
## 
## see http://d.hatena.ne.jp/takatoh/20070531/hatena_graph
##
## - module: Publish::hatena_graph
##   config:
##     user_id: your hatena user id
##     password: your password
##     graph_name: the name of graph
##     proxy_host: proxy host name   (optional)
##     proxy_port: proxy port        (optional)
##     proxy_user: proxy user        (optional)
##     proxy_pass: proxy password    (optional)

begin
  require 'rubygems'
  gem 'hatenaapigraph', '>=0.1.2'
rescue LoadError
end
require 'hatena/api/graph'


def hatena_graph(config, data)
  value = data.first.to_f
  graph = Hatena::API::Graph.new(config['user_id'], config['password'])
  if config['proxy_host']
    proxy_host = config['proxy_host']
    proxy_port = config['proxy_port']
    proxy_user = config['proxy_user']
    proxy_pass = config['proxy_pass']
    graph.proxy = ::Net::HTTP.Proxy(proxy_host, proxy_port, proxy_user, proxy_pass)
  end
  graph.post(config['graph_name'], Time.now, value)
end
