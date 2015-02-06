require 'environment.rb'
require 'parser.rb'
require 'interpreter.rb'
require 'function.rb'

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
        print "risp> "
        print "=> ", value(gets), "\n"
      end
    end
  end
end

