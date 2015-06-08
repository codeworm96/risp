module Kont
  def self.bind(lhs, rhs)
    lambda do |x|
      t = lhs[x]
      rhs[t]
    end
  end
end
