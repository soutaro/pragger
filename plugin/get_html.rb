def get_html(config,data)
  require "open-uri"
  data.map do |line|
    r = ""
    open(line) {|f| r = f.read }
    r
  end
end

