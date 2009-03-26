require 'pathname'

def update_plugin_dir(input)
  input.gsub('Pathname(__FILE__).parent', "Pathname('#{config("datadir")}/pragger')")
end

pragger = Pathname("pragger")
content = pragger.read
pragger.open('w'){|io| io.write(update_plugin_dir(content)) }
system "chmod +x pragger"
