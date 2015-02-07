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

  def test_logic
    assert_equal true, @app.value("(and #t #t)")
    assert_equal false, @app.value("(and #f #t)")
    assert_equal false, @app.value("(and #t #f)")
    assert_equal false, @app.value("(and #f #f)")
    assert_equal true, @app.value("(or #t #t)")
    assert_equal true, @app.value("(or #f #t)")
    assert_equal true, @app.value("(or #t #f)")
    assert_equal false, @app.value("(or #f #f)")
    assert_equal false, @app.value("(not #t)")
    assert_equal true, @app.value("(not #f)")
    assert_equal true, @app.value("(or #f #t #f)")
    assert_equal false, @app.value("(and #t #t #f)")
  end

end

class TestQsort < Test::Unit::TestCase
  def setup
    @app = REPL.new
    @app.value("(define >= (lambda (x y) (or (> x y) (= x y))))")
    @app.value("(define select (lambda (l f) (cond ((null? l) (quote ())) ((f (car l)) (cons (car l) (select (cdr l) f))) (else (select (cdr l) f)))))")
    @app.value("(define append (lambda (l1 l2) (cond ((null? l1) l2) (else (cons (car l1) (append (cdr l1) l2))))))")
    @app.value("(define qsort (lambda (l) (if (null? l) (quote ()) (append (qsort (select (cdr l) (lambda (x) (< x (car l))))) (cons (car l) (qsort (select (cdr l) (lambda (x) (>= x (car l))))))))))")
  end

  def test_qsort
    res = [1, 2, 3, 4, 5]
    assert_equal [], @app.value("(qsort (quote ()))")
    assert_equal [1], @app.value("(qsort (quote (1)))")
    assert_equal res, @app.value("(qsort (quote (1 2 3 4 5)))")
    assert_equal res, @app.value("(qsort (quote (5 4 3 2 1)))")
    assert_equal res, @app.value("(qsort (quote (1 4 5 3 2)))")
  end
end

class TestFac < Test::Unit::TestCase
  def setup
    @app = REPL.new
    @app.value("(define fac (lambda (x k) (cond ((= 0 x) (k 1)) (else (fac (- x 1) (lambda (c) (k (* x c))))))))")
    @app.value("(define I (lambda (x) x))")
  end

  def test_fac
    assert_equal 1, @app.value("(fac 0 I)")
    assert_equal 1, @app.value("(fac 1 I)")
    assert_equal 2, @app.value("(fac 2 I)")
    assert_equal 6, @app.value("(fac 3 I)")
    assert_equal 120, @app.value("(fac 5 I)")
  end
end


