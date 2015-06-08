require_relative 'interpreter.rb'
require_relative 'state.rb'

class Macro
  def apply(args, env, kont)
    State.new(body(*args), env, kont)
  end
end

