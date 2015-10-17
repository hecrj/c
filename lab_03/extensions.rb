class Array
  def ^(array)
    zip(array).map { |a, b| a ^ b }
  end

  def pretty
    self.map { |v| "%02X" % v }.join('-')
  end
end

class String
  def ascii_bytes
    (0...self.length/2).map { |i| self[i*2, 2].to_i(16) }
  end
end
