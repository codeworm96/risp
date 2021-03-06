require_relative '../src/interpreter.rb'
require_relative '../src/environment.rb'
require 'test/unit'

class TestInterpreter < Test::Unit::TestCase
  def setup
    @id = lambda { |x| x }
  end
  
  def test_eval_atom
    e = Environment.new
    e.define(:a, [])
    assert_equal [], Interpreter.eval(:a, e, @id)
    assert_equal 1, Interpreter.eval(1, e, @id)
    assert_equal 3.14, Interpreter.eval(3.14, e, @id)
    assert_nil Interpreter.eval(:nothing, e, @id)
  end

  def test_eval_define
    e = Environment.new
    Interpreter.eval([:define, :a, 2], e, @id)
    assert_equal 2, Interpreter.eval(:a, e, @id)
    assert_nil Interpreter.eval(:z, e, @id)
  end

  def test_eval_cond
    e = Environment.new
    e.define(:"#t", true)
    e.define(:"#f", false)
    assert_equal 3, Interpreter.eval([:cond, [:else, 3]], e, @id)
    assert_equal 1, Interpreter.eval([:cond, [:"#f", 0], [:"#t", 1]], e, @id)
    assert_equal 0, Interpreter.eval([:cond, [:"#t", 0], [:"#t", 1]], e, @id)
  end

  def test_eval_lambda
    e = Environment.new
    e.define(:a, 3.14)
    assert_equal 3.14, Interpreter.eval([[:lambda, [], :a]], e, @id)
  end

  def test_eval_quote
    e = Environment.new
    assert_equal [], Interpreter.eval([:quote, []], e, @id)
    assert_equal [:boy, :girl], Interpreter.eval([:quote, [:boy, :girl]], e, @id)
    assert_equal :butter, Interpreter.eval([:quote, :butter], e, @id)
  end

end
