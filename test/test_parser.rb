require_relative '../src/parser.rb'
require 'test/unit'

class TestParser < Test::Unit::TestCase
  
  def test_tokenize
    assert_equal ['(', '+', '1', '2', ')'], Parser.tokenize('(+ 1 2)') 
    assert_equal ['(', '(', 'cond', '(', 'else', 'cons', ')', ')', 'a', '(', 'cons', 'b', '(', 'quote',
       '(', ')', ')', ')', ')'], Parser.tokenize('((cond (else cons)) a (cons b (quote ())))')
  end

  def test_atom
    assert_equal 3.14, Parser.atom("3.14")
    assert_equal 2, Parser.atom("2")
    assert_equal :+, Parser.atom("+")
    assert_equal :cond, Parser.atom("cond")
  end

  def test_read_from_tokens
    assert_equal :+, Parser.read_from_tokens(["+"])
    assert_equal [:+, 1, 2], Parser.read_from_tokens(['(', '+', '1', '2', ')']) 
    assert_raise(ArgumentError){
      Parser.read_from_tokens([])
    }
    assert_raise(ArgumentError){
      Parser.read_from_tokens([')'])
    }
  end

  def test_parse
    assert_equal [:define, :fib, [:lambda, [:x], 
                   [:cond, [[:zero?, :x], 1], [:else, [:*, :x, [:fac, [:-, :x, 1]]]]]]],
      Parser.parse("(define fib (lambda (x) (cond ((zero? x) 1) (else (* x (fac (- x 1)))))))")
  end
end

