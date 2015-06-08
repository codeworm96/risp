class State
  attr_reader :exp, :env, :kont

  def initialize(exp, env, kont)
    @exp = exp
    @env = env
    @kont = kont
  end
end

