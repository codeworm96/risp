require_relative 'interpreter.rb'
require_relative 'state.rb'

class Kontinuation
  def initialize(kont)
    puts "build"
    @kont = kont
  end

  def apply(args, env, kont)
    State.new(args[0], env, @kont)
  end
end

