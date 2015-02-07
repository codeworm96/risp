require './environment.rb'
require './macro.rb'
require './function.rb'

class PrimCons < Function
  def body(a, b)
    res = b.dup
    res.unshift(a)
  end
end

class PrimCar < Function
  def body(arg)
    arg[0]
  end
end

class PrimCdr < Function
  def body(arg)
    arg[1..-1]
  end
end

class PrimNull < Function
  def body(arg)
    arg.empty?
  end
end

class PrimEq < Function
  def body(a, b)
    a == b
  end
end

class PrimAtom < Function
  def body(arg)
    !(Array === arg)
  end
end

class PrimNumber < Function
  def body(arg)
    (Integer === arg)||(Float === arg)
  end
end

class MacroIf < Macro
  def body(condition, then_statement, else_statement)
    [:cond, [condition, then_statement], [:else, else_statement]]
  end
end

class MacroAnd < Macro
  def body(*terms)
    res = [:cond]
    i = 0
    while i < terms.size
      if i + 1 == terms.size
        res << [:else, terms[i]]
      else
        res << [[:not, terms[i]], :"#f"]
      end
      i += 1
    end
    res
  end
end

class MacroOr < Macro
  def body(*terms)
    res = [:cond]
    i = 0
    while i < terms.size
      if i + 1 == terms.size
        res << [:else, terms[i]]
      else
        res << [terms[i], :"#t"]
      end
      i += 1
    end
    res
  end
end

class LogicNot < Function
  def body(arg)
    !arg
  end
end

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
    res.define(:and, MacroAnd.new)
    res.define(:or, MacroOr.new)
    res.define(:not, LogicNot.new)

    res
  end
end
