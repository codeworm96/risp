require_relative 'interpreter.rb'
require_relative 'environment.rb'

class Function
  def eval_arg_list(args, env, kont)
    if args.empty?
      kont[[]]
    else
      eval_arg_list(args[0..-2], env,
        lambda do |list|
          Interpreter.eval(args.last, env,
            lambda do |res|
              kont[list + [res]]
            end)
        end)
    end
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
    Interpreter.eval(@body, e, kont)
  end
end
