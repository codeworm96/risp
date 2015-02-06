require 'stdlib.rb'

class Environment
  def self.new_with_stdlib
    res = Environment.new
    res.define(:"#t", true)
    res.define(:"#f", false)
    res.define(:cons, PrimCons.new)
    res.define(:car, PrimCar.new)
    res.define(:cdr, PrimCdr.new)
    res.define(:null?, PrimNull.new)
    res.define(:eq?, PrimEq.new)
    res.define(:atom?, PrimAtom.new)
    res.define(:number?, PrimNumber.new)
    res.define(:if, MacroIf.new)

    res
  end

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

