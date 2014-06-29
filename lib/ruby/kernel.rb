module Kernel
  def __file__
    # I know this is not actually correct but it works for now
    # TODO: Revisit this method in the future
    caller[1][/(.+rb)/]
  end

  def __dir__
    ::File.dirname(__file__)
  end
end
