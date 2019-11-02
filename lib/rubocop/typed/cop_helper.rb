module RuboCop
  module Typed
    module CopHelper
      def self.included(mod)
        mod.extend ClassMethods
      end

      module ClassMethods
        # on('String') {}
        # on('String#gsub') {} # TODO
        # on('Klass.class_method') {} # TODO
        def on(event, &block)
          typed_handlers[event.to_sym] ||= []
          typed_handlers[event.to_sym] << block
        end

        def typed_handlers
          @typed_handlers ||= {}
        end
      end

      def type_of_node(node)
        path = PathUtil.smart_path(processed_source.path)
        ::RuboCop::Typed.driver.type_of_node(path: path, node: node)
      end

      def investigate(processed_source)
        traverse = -> (node, &block) do
          block.call(node)
          node.children.each do |child|
            traverse.call(child, &block) if child.is_a?(Parser::AST::Node)
          end
        end

        ast = processed_source.ast
        return unless ast

        traverse.call(ast) do |node|
          type = type_of_node(node)
          next unless type

          case type
          when Steep::AST::Types::Name::Instance
            name = type.name.name # Is it correct?
            handlers = self.class.typed_handlers[name]
            handlers&.each do |handler|
              handler.call(node: node, type: type)
            end
          end
        end
      end
    end
  end
end
