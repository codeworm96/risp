require_relative 'interpreter.rb'
require_relative 'state.rb'

class Kontinuation
  def initialize(kont)
    @kont = kont
  end

  def apply(args, env, kont)
    State.new(args, env, @kont)
  end
end

