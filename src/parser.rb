module Parser
  def self.tokenize(src)
    src.gsub(/([()])/,' \1 ').split(' ')
  end
  
  def self.atom(token)
    begin
      Integer(token)
    rescue ArgumentError
      begin
        Float(token)
      rescue ArgumentError
        token.to_sym
      end
    end
  end

  def self.read_from_tokens(tokens)
    raise ArgumentError.new("unexpected EOF") if tokens.empty?
    case tokens[0]
      when '('
        tokens.shift
        res = []
        while tokens[0] != ')'
          res << read_from_tokens(tokens)
        end
        tokens.shift #remove `)'
        res
      when ')'
        raise ArgumentError.new("unexpected `)'")
      else
        atom(tokens.shift)
      end
  end

  def self.parse(program)
    read_from_tokens(tokenize(program))
  end

end
