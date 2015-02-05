require '../src/environment.rb'
require 'test/unit'

class TestEnvironment < Test::Unit::TestCase
  def test_basic
    e = Environment.new
    e.define(:a, 1)
    e.define(:b, 2.2)
    e.define(:c, [[], [], []])
    assert_equal 1, e.lookup(:a)
    assert_equal 2.2, e.lookup(:b)
    assert_equal [[], [], []], e.lookup(:c)
    assert_nil e.lookup(:d)
  end

  def test_chain
    e = Environment.new
    e.define(:a, 1)
    e.define(:b, 2.2)
    e.define(:c, [[], [], []])
    ee = Environment.new
    ee.chain(e)
    ee.define(:b, 3.14)
    ee.define(:d, 0)
    assert_equal 0, ee.lookup(:d)
    assert_equal [[], [], []], ee.lookup(:c)
    assert_equal 3.14, ee.lookup(:b)
    assert_nil ee.lookup(:z)
  end
end
