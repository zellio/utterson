module Kernel
  def __file__
    caller[1][/\A(.+):\d+:in `.+'\Z/, 1]
  end

  def __dir__
    ::File.dirname(__file__)
  end
end
