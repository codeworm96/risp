require '../src/repl.rb'
require 'test/unit'

class TestREPL < Test::Unit::TestCase
  def setup
    @app = REPL.new
  end

  def test_value
    @app.value("(define member? (lambda (x l) (cond ((null? l) #f) ((eq? x (car l)) #t) (else (member? x (cdr l))))))")
    assert_equal true, @app.value("(member? (quote a) (quote (a b c)))")
    assert_equal false, @app.value("(member? (quote a) (quote ()))")
    assert_equal true, @app.value("(member? (quote c) (quote (a b c)))")
    assert_equal false, @app.value("(member? (quote z) (quote (a b c d)))")
  end
end

