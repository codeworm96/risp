require_relative 'interpreter.rb'
require_relative 'environment.rb'
require_relative 'kont.rb'
require_relative 'state.rb'

class Function

  def eval_term(term, env)
    lambda do |list|
      Interpreter.eval(term, env,
        lambda do |res|
          list + [res]
        end)
    end
  end

  def eval_arg_list(args, env, kont)
    while !args.empty?
      kont = Kont.bind(eval_term(args.last, env), kont)
      args = args[0..-2]
    end
    kont[[]]
  end

  def apply(args, env, kont)
    eval_arg_list(args, env, 
      lambda do |values|
        body(*values, &kont)
    end)
  end
end

class Closure < Function
  def initialize(formals, body, env)
    @formals = formals
    @body = body
    @table = env
  end

  def body(*values, &kont)
    e = Environment.new
    i = 0
    @formals.each {|formal|
      e.define(formal, values[i])
      i += 1
    }
    e.chain(@table)
    State.new(@body, e, kont)
  end
end
