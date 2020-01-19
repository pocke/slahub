module Slahub
  class ThrottledDelegator
    class Timer
      def initialize(wait:, concurrency:)
        @wait = wait
        @queue = Thread::Queue.new
        concurrency.times do
          start!
        end
      end

      def call(&block)
        wait = Thread.new { Thread.stop }
        @queue << wait
        wait.join
        block.call
      end

      private def start!
        Thread.new do
          while wait = @queue.pop
            wait.kill
            sleep @wait
          end

          raise 'unreachable!'
        end
      end
    end

    def initialize(wait:, to:, concurrency:)
      @to = to
      @timer = Timer.new(wait: wait, concurrency: concurrency)
    end

    def method_missing(name, *args, **kwargs, &block)
      if @to.respond_to?(name)
        @timer.call do
          @to.__send__(name, *args, **kwargs, &block)
        end
      else
        super
      end
    end

    def respond_to_missing?(name, include_private)
      @to.respond_to?(name, include_private)
    end
  end
end
