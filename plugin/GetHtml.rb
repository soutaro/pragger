require "open-uri"

def GetHtml(config,data)
  data.map do |line|
    r = ""
    open(line) {|f| r = f.read }
    r
  end
end

