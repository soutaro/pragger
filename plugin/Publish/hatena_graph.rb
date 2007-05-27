## Post data to Hatena Graph -- takatoh
## 
## see http://d.hatena.ne.jp/takatoh/20070503/hatena_graph
##
## - module: Publish::hatena_graph
##   config:
##     user_id: your hatena user id
##     password: your password
##     graph_name: the name of graph

begin
  require 'rubygems'
rescue LoadError
end
require 'hatena/api/graph'


# bug fix and extention for hatenaapigraph 0.1.0
#
module ::Hatena
  module API
    class Graph
      def post(graphname, date, value)
        value = value.to_f
        date = date.strftime DATE_FORMAT
        headers = {
          'Access' => 'application/x.atom+xml, application/xml, text /xml, */*',
          'X-WSSE' => wsse(@username, @password),
        }
        params = {
          :graphname => graphname,
          :date => date,
          :value => value,
        }
        res = http_post GRAPH_API_URI, params, headers
        raise GraphError.new("request not successed: #{res}") if res .code != '201'
        res
      end

      private 
      def http_post(url, params, headers)
        req = ::Net::HTTP::Post.new(url.path, headers)
        req.form_data = params
        req.basic_auth url.user, url.password if url.user
        proxy_host = nil
        proxy_port = nil
        if proxy = ENV['http_proxy']
          proxy = URI.parse(proxy)
          proxy_host = proxy.host
          proxy_port = proxy.port
        end
        ::Net::HTTP.new(url.host, url.port, proxy_host, proxy_port). start {|http| http.request(req) }
      end
    end
  end
end


def hatena_graph(config, data)
  value = data.first.to_f
  graph = Hatena::API::Graph.new(config['user_id'], config['password '])
  graph.post(config['graph_name'], Time.now, value)
end
