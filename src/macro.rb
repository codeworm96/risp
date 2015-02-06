require 'interpreter.rb'

class Macro
  def apply(args, env)
    Interpreter.eval(body(*args), env)
  end
end

