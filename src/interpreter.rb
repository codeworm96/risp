require_relative 'function.rb'
require_relative 'state.rb'
require_relative 'kontinuation.rb'

module Interpreter
  def self.eval_atom(atom, env, kont)
    if Symbol === atom
      kont[env.lookup(atom)]
    else
      kont[atom]
    end
  end

  def self.eval_define(args, env, kont)
    eval(args[1], env, lambda do |res|
      kont[env.define(args[0], res)]
    end)
  end

  def self.eval_cond(args, env, kont)
    line = args[0]
    if line[0] == :else
      State.new(line[1], env, kont)
    else 
      State.new(line[0], env, lambda do |res|
        if res
          eval(line[1], env, kont)
        else
          eval_cond(args[1..-1], env, kont)
        end
      end)
    end
  end

  def self.eval_lambda(sexp, env, kont)
    kont[Closure.new(sexp[0], sexp[1], env)]
  end

  def self.eval_sexp(sexp, env, kont)
    case sexp[0]
      when :lambda
        eval_lambda(sexp[1..-1], env, kont)
      when :cond
        eval_cond(sexp[1..-1], env, kont)
      when :define
        eval_define(sexp[1..-1], env, kont)
      when :quote
        kont[sexp[1]]
      when :callcc
        State.new(sexp[1], env, lambda do |res|
          res.apply([Kontinuation.new(kont)], env, kont)
        end)
      else
        State.new(sexp[0], env, lambda do |res|
          res.apply(sexp[1..-1], env, kont)
        end)
      end
  end

  def self.eval(code, env, kont)
    loop do 
      res = if Array === code
              eval_sexp(code, env, kont)
            else
              eval_atom(code, env, kont)
            end
      if State === res
        code = res.exp
        env = res.env
        kont = res.kont
      else
        return res
      end
    end
  end
end
