class BinaryPolynomial
  attr_reader :value
  attr_reader :degree

  def self.with_coefficients(*coefficients)
    value = coefficients.inject(0) { |current, coefficient| current ^ (1 << coefficient) }
    BinaryPolynomial.new(value)
  end

  def initialize(value)
    @value = value
    @degree = value.to_s(2).size - 1
  end

  def *(p)
    BinaryPolynomial.with_coefficients(*coefficients.map { |x| p.coefficients.map { |y| x + y } }.flatten)
  end

  def %(m)
    if m.value > @value
      self
    else
      BinaryPolynomial.new(@value ^ (m.value << @degree - m.degree)) % m
    end
  end

  def coefficients
    @coefficients ||= value.to_s(2).chars
                        .each_with_index
                        .map { |coefficient, index| coefficient == '1' ? @degree - index : nil }
                        .compact
  end

  def to_s
    @s ||= coefficients.map { |coefficient| coefficient == 0 ? '1' : "x^#{coefficient}" }.join(' + ')
  end

  alias_method :inspect, :to_s
end

class Byte
  attr_reader :value
  attr_reader :bits
  attr_reader :polynomial

  M = BinaryPolynomial.with_coefficients(8, 4, 3, 1, 0)

  def self.with_coefficients(*coefficients)
    Byte.new(BinaryPolynomial.with_coefficients(*coefficients).value)
  end

  def initialize(value)
    @value = value % 256
    @bits = value.to_s(2).chars
    @polynomial = BinaryPolynomial.new(@value)
  end

  def [](index)
    @bits[index] == '1'
  end

  def +(b)
    Byte.new(@value ^ b.value)
  end

  def *(b)
    GF_product_p(self, b)
  end
end


def GF_product_p(a, b)
  Byte.new(((a.polynomial * b.polynomial) % Byte::M).value)
end
