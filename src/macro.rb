require_relative 'interpreter.rb'

class Macro
  def apply(args, env, kont)
    Interpreter.eval(body(*args), env, kont)
  end
end

