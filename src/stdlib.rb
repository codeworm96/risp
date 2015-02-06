require 'macro.rb'
require 'function.rb'

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


