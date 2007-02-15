require "open-uri"

def get_html(config,data)
  data.map do |line|
    r = ""
    open(line) {|f| r = f.read }
    r
  end
end

