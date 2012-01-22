class Cripto
  attr_accessor :dictionary

  def initialize(dictionary)
    self.dictionary = dictionary
  end

  def encrypt(text)
    process(:[], text)
  end

  def decrypt(text)
    process(:key, text)
  end

  private
  
  def process(method, text)
    processed_text = ""
    text.each_char do |ch|
      processed_text << (dictionary.send(method, ch) || ch)
    end
    processed_text
  end
end
