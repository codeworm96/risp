module Kont
  def self.bind(lhs, rhs)
    lambda do |x|
      rhs[lhs[x]]
    end
  end
end
