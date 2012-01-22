class Dictionary
  attr_accessor :definition

  def initialize(definition)
    self.definition = definition
  end

  def dictionary
    definition
  end

  def [](key)
    definition[key]
  end

  def key(value)
    definition.key(value)
  end

  def include?(key)
    definition.value?(key)
  end
end
