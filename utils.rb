module Utils
  def self.read_integers(filename)
    File.readlines(filename).map(&:to_i)
  end

  def self.read_lines(filename)
    File.readlines(filename)
  end
end
