require 'readline'
require_relative 'environment.rb'
require_relative 'stdlib.rb'
require_relative 'parser.rb'
require_relative 'interpreter.rb'
require_relative 'function.rb'

class PrimQuit < Function
  def body
    throw :quit
  end
end

class REPL
  def initialize
    @env = Environment.new_with_stdlib
    @env.define(:quit, PrimQuit.new)
  end

  def value(code)
    Interpreter.eval(Parser.parse(code), @env)
  end

  def run
    catch :quit do
      loop do
        buf = Readline.readline("risp> ",true)
        print "=> ", value(buf), "\n"
      end
    end
  end
end

