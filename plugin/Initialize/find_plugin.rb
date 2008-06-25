eval <<'EOL',TOPLEVEL_BINDING
alias eval_pragger_loggnizer_backup eval_pragger

def eval_pragger(command_array,data)
  command_array.each do |command|
    if ! $plugins.include?(command["module"])
      STDERR.puts "Plugin not found : #{command["module"]}"
    end
  end
  eval_pragger_loggnizer_backup(command_array,data)
end
EOL

def find_plugin(config,data)
end
