class Environment
  def initialize
    @entry = {}
    @outer = nil
  end

  def lookup(name)
    res = @entry[name]
    if (!res)&&@outer
      @outer.lookup(name)
    else
      res
    end
  end

  def define(name, value)
    raise ArgumentError.new("#{name} has defined") if @entry.member?(name)
    @entry[name]=value
  end

  def chain(outer)
    @outer = outer
  end
end

