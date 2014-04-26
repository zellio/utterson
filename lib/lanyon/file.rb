class Lanyon::File < ::File
  def initialize(opts={})
    @path = opts[:path]
  end

  def basename
    File.basename(@path)
  end
end
