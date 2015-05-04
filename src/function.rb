require_relative 'interpreter.rb'
require_relative 'environment.rb'

class Function
  def apply(args, env)
    values = args.map {|arg| Interpreter.eval(arg, env) }
    body(*values)
  end
end

class Closure < Function
  def initialize(formals, body, env)
    @formals = formals
    @body = body
    @table = env
  end

  def body(*values)
    e = Environment.new
    i = 0
    @formals.each {|formal|
      e.define(formal, values[i])
      i += 1
    }
    e.chain(@table)
    Interpreter.eval(@body, e)
  end
end
