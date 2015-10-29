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
    if m.degree > @degree
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

  # Modulo constant
  M = BinaryPolynomial.with_coefficients(8, 4, 3, 1, 0)

  def to_byte
    Byte.new((self % M).value)
  end

  def to_s
    @s ||= coefficients.map do |index|
      case index
      when 0
        '1'
      when 1
        'x'
      else
        "x^#{index}"
      end
    end.join(' + ')
  end

  alias_method :inspect, :to_s
end

class Byte
  attr_reader :value
  attr_reader :bits
  attr_reader :polynomial

  def self.with_coefficients(*coefficients)
    BinaryPolynomial.with_coefficients(*coefficients).to_byte
  end

  def self.generate_tables(generator)
    tables = {
      exponential: Array.new(256),
      logarithmic: Array.new(256)
    }

    gbyte = Byte.new(generator)

    255.times do |i|
      byte = gbyte ** i

      tables[:exponential][i] = byte.value
      tables[:logarithmic][byte.value] = i
    end

    tables
  end

  def self.tables
    @tables ||= generate_tables(0x03)
  end

  def initialize(value)
    @value = value % 256
    @bits = value.to_s(2).chars
    @polynomial = BinaryPolynomial.new(@value)
  end

  def +(b)
    Byte.new(@value ^ b.value)
  end

  def *(b)
    GF_product_p(self, b)
  end

  def **(i)
    if i == 0 or i == 255
      Byte.new(1)
    else
      p = self ** (i/2)

      i.even? ? p * p : p * p * self
    end
  end
end


def GF_tables
  Byte.tables
end

# Products using polynomial definition
# Note that the to_byte method in BinaryPolynomial applies the modulo
def GF_product_p(a, b)
  (a.polynomial * b.polynomial).to_byte
end

def GF_product_p_02(a)
  BinaryPolynomial.new(a.value << 1).to_byte
end

def GF_product_p_03(a)
  BinaryPolynomial.new((a.value << 1) ^ a.value).to_byte
end

def GF_product_p_09(a)
  BinaryPolynomial.new((a.value << 3) ^ a.value).to_byte
end

def GF_product_p_0B(a)
  BinaryPolynomial.new((a.value << 3) ^ (a.value << 1) ^ a.value).to_byte
end

def GF_product_p_0D(a)
  BinaryPolynomial.new((a.value << 3) ^ (a.value << 2) ^ a.value).to_byte
end

def GF_product_p_0E(a)
  BinaryPolynomial.new((a.value << 3) ^ (a.value << 2) ^ (a.value << 1)).to_byte
end

# Products using tables
# Input and output are integers in this one
def GF_product_t_i(a, b)
  return 0 if a == 0 or b == 0
  
  t = GF_tables()
  t[:exponential][(t[:logarithmic][a] + t[:logarithmic][b]) % 255]
end

def GF_product_t(a, b)
  Byte.new(GF_product_t_i(a.value, b.value))
end

def GF_product_t_02(a)
  Byte.new(GF_product_t_i(a.value, 0x02))
end

def GF_product_t_03(a)
  Byte.new(GF_product_t_i(a.value, 0x03))
end

def GF_product_t_09(a)
  Byte.new(GF_product_t_i(a.value, 0x09))
end

def GF_product_t_0B(a)
  Byte.new(GF_product_t_i(a.value, 0x0B))
end

def GF_product_t_0D(a)
  Byte.new(GF_product_t_i(a.value, 0x0D))
end

def GF_product_t_0E(a)
  Byte.new(GF_product_t_i(a.value, 0x0E))
end

# Generators
GENERATORS =   [
  3, 5, 6, 9, 11, 14, 17, 18, 19, 20, 23, 24, 25, 26, 28, 30,
  31, 33, 34, 35, 39, 40, 42, 44, 48, 49, 60, 62, 63, 65, 69,
  70, 71,72, 73, 75, 76, 78, 79, 82, 84, 86, 87, 88, 89, 90,
  91, 95, 100, 101, 104, 105, 109, 110, 112, 113, 118, 119,
  121, 122, 123, 126, 129, 132, 134, 135, 136, 138, 142, 143,
  144, 147, 149, 150, 152, 153, 155, 157, 160, 164, 165, 166,
  167, 169, 170, 172, 173, 178, 180, 183, 184, 185, 186, 190,
  191, 192, 193, 196, 200, 201, 206, 207, 208, 214, 215, 218,
  220, 221, 222, 226, 227, 229, 230, 231, 233, 234, 235, 238,
  240, 241, 244, 245, 246, 248, 251, 253, 254, 255
].map { |generator| Byte.new(generator) }.freeze

def GF_generador
  GENERATORS
end

def GF_invers(a)
  if a.value == 0
    Byte.new(0)
  else
    t = GF_tables()
    Byte.new(t[:exponential][-t[:logarithmic][a.value]-1])
  end
end
