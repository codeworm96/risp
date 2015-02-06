require '../src/interpreter.rb'
require '../src/environment.rb'
require 'test/unit'

class TestInterpreter < Test::Unit::TestCase
  def test_eval_atom
    e = Environment.new
    e.define(:a, [])
    assert_equal [], Interpreter.eval(:a, e)
    assert_equal 1, Interpreter.eval(1, e)
    assert_equal 3.14, Interpreter.eval(3.14, e)
    assert_nil Interpreter.eval(:nothing, e)
  end

  def test_eval_define
    e = Environment.new
    Interpreter.eval([:define, :a, 2], e)
    assert_equal 2, Interpreter.eval(:a, e)
    assert_nil Interpreter.eval(:z, e)
  end

  def test_eval_cond
    e = Environment.new
    e.define(:"#t", true)
    e.define(:"#f", false)
    assert_equal 3, Interpreter.eval([:cond, [:else, 3]], e)
    assert_equal 1, Interpreter.eval([:cond, [:"#f", 0], [:"#t", 1]], e)
    assert_equal 0, Interpreter.eval([:cond, [:"#t", 0], [:"#t", 1]], e)
  end

end
