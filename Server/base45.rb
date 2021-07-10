class Base45
  BASE45_CHARSET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"

  # @param [String] input
  def self.decode(input)
    d = []
    o = []
    input.upcase.each_char do |c|
      idx = BASE45_CHARSET.chars.index c
      throw :invalid_symbol if idx.nil?
      d.append idx
    end

    (0...d.length).step(3).each do |idx|
      throw :invalid_length if d.length - idx < 2
      x = d[idx] + (d[idx + 1] * 45)
      if d.length - idx >= 3
        x += 45 * 45 * d[idx + 2]
        throw :data_overflow unless x / 256 <= 255
        o.append [x / 256].pack('C')
      end
      o.append [x % 256].pack('C')
    end
    o.join ''
  end
end