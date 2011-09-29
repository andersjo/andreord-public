#coding: utf-8
class BitField
  def initialize(size)
    @str = "\0" * (size / 8)
    @str.force_encoding "binary"
  end

  def [](bit)
    (byte_at_bit(bit) & (2**(bit % 8))) != 0
  end

  def set(bit)
    new_byte = byte_at_bit(bit) | (2**(bit % 8))
    set_byte_at_bit(bit, new_byte)
  end
  
  def unset(bit)
    new_byte = byte_at_bit(bit) & ~(2**(bit % 8))
    set_byte_at_bit(bit, new_byte)
  end

  def byte_at_bit(bit)
    @str.getbyte(bit / 8)
  end

  def set_byte_at_bit(bit, byte)
    @str.setbyte(bit / 8, byte)
  end

end
