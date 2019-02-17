require 'pry'
require 'tty-tree'

class Pry
  Commands.create_command 'hier' do
    description 'Shows descendants of a class: hier [Class|Module]'

    def process
      klass = WrappedModule.from_str(args[0])
      raise ArgumentError unless klass
      print_tree_for(klass.wrapped)
    end

    private

    def print_tree_for(klass)
      output.print TTY::Tree.new(hash_for(klass)).render
    end

    def hash_for(klass)
      children = children_of(klass).map(&method(:hash_for))
      colour_name(klass) do |name|
        children.empty? ? name : { name => children }
      end
    end

    def children_of(klass)
      ObjectSpace.each_object.select do |obj|
        obj.respond_to?(:superclass) && obj.superclass == klass
      end
    end

    def colour_name(klass)
      yield(Pry.config.color ? colorize_code(klass) : klass.name)
    end
  end
end

require 'pry'; binding.pry
