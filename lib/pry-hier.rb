require 'pry'
require 'tty-tree'

def blah(klass=Exception)
  @errors = ObjectSpace.each_object.select do |obj|
    obj.is_a?(Class) && obj.ancestors.include?(klass)
  end

  def children_of(error)
    @errors.select { |other| other.superclass == error }.sort_by(&:to_s)
  end

  def hashize(error)
    children = children_of(error).map(&method(:hashize))
    children.empty? ? error : { error => children }
  end

  print TTY::Tree.new(hashize(klass)).render
end

Pry::Commands.create_command 'hier' do
  description 'Shows descendants of a class: hier [Class|Module]'

  def process
    blah(eval(args[0]))
  end
end

require 'pry'; binding.pry
