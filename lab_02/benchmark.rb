require_relative 'gf'
require 'benchmark'

# Ensure tables are initialized
GF_tables()

A = Byte.new(0xF3)
B = Byte.new(0xB2)

Benchmark.bm(12) do |b|
  b.report("GF_product_p") { 1000000.times { GF_product_p(A, B) } }
  b.report("GF_product_t") { 1000000.times { GF_product_t(A, B) } }
end

[0x02, 0x03, 0x09, 0x0B, 0x0D, 0x0E].each do |value|
  puts # Blank line

  hex = value.to_s(16).upcase

  Benchmark.bm(15) do |b|
    b.report("GF_product_p_0#{hex}") { 1000000.times { send("GF_product_p_0#{hex}", A) } }
    b.report("GF_product_t_0#{hex}") { 1000000.times { send("GF_product_t_0#{hex}", A) } }
  end
end

[0x02, 0x03, 0x09, 0x0B, 0x0D, 0x0E].each do |value|
  puts # Blank line

  hex = value.to_s(16).upcase
  byte = Byte.new(value)

  Benchmark.bm(21) do |b|
    b.report("GF_product_p(a, 0x0#{hex})") { 1000000.times { send("GF_product_p", A, byte) } }
    b.report("GF_product_p_0#{hex}(a)") { 1000000.times { send("GF_product_t_0#{hex}", A) } }
  end
end

[0x02, 0x03, 0x09, 0x0B, 0x0D, 0x0E].each do |value|
  puts # Blank line

  hex = value.to_s(16).upcase
  byte = Byte.new(value)

  Benchmark.bm(21) do |b|
    b.report("GF_product_t(a, 0x0#{hex})") { 1000000.times { send("GF_product_t", A, byte) } }
    b.report("GF_product_t_0#{hex}") { 1000000.times { send("GF_product_t_0#{hex}", A) } }
  end
end
