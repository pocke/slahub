require 'test_helper'
require 'benchmark'

class ThrottledDelegatorTest < Minitest::Test
  class C
    def m(a) a end
  end

  def test_call
    d = Slahub::ThrottledDelegator.new(wait: 0, concurrency: 1, to: C.new)
    assert_equal 42, d.m(42)
  end

  def test_throttled_call
    d = Slahub::ThrottledDelegator.new(wait: 0.1, concurrency: 1, to: C.new)
    t = Benchmark.realtime do
      5.times do
        d.m(42)
      end
    end
    assert t > (0.1 * (5 - 1))
  end

  def test_throttled_call_concurrent
    d = Slahub::ThrottledDelegator.new(wait: 0.1, concurrency: 3, to: C.new)
    t = Benchmark.realtime do
      10.times do
        d.m(42)
      end
    end
    assert t > 0.3
  end
end
