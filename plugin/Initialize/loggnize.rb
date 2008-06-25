require 'logger'

$log = Logger.new(STDERR)

eval <<'EOL',TOPLEVEL_BINDING
alias eval_pragger_loggnizer_backup eval_pragger

def eval_pragger(command_array,data)
  command_array_new = []
  command_array.each do |command|
    command_array_new << { "module" => "logout" , "config" => {"mes" => "exec plugin #{command["module"]}"} }
    command_array_new << command
  end
  eval_pragger_loggnizer_backup(command_array_new,data)
end
EOL

def loggnize(config,data)
end
