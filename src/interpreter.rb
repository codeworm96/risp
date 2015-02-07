require './function.rb'

module Interpreter
  def self.eval_atom(atom, env)
    if Symbol === atom
      env.lookup(atom)
    else
      atom
    end
  end

  def self.eval_define(args, env)
    env.define(args[0], eval(args[1], env))
  end

  def self.eval_cond(args, env)
    args.each do |line|
      if line[0] == :else
        break eval(line[1], env)
      elsif eval(line[0], env)
        break eval(line[1], env)
      else
        nil
      end
    end
  end

  def self.eval_lambda(sexp, env)
    Closure.new(sexp[0], sexp[1], env)
  end

  def self.eval_sexp(sexp, env)
    case sexp[0]
      when :lambda
        eval_lambda(sexp[1..-1], env)
      when :cond
        eval_cond(sexp[1..-1], env)
      when :define
        eval_define(sexp[1..-1], env)
      when :quote
        sexp[1]
      else
        eval(sexp[0], env).apply(sexp[1..-1], env)
      end
  end

  def self.eval(code, env)
    if Array === code
      eval_sexp(code, env)
    else
      eval_atom(code, env)
    end
  end
end
