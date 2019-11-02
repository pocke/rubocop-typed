module RuboCop
  module Typed
    module CopHelper
      def self.included(mod)
        mod.extend ClassMethods
      end

      module ClassMethods
        # on('String') {}
        # on('String#gsub') {}
        # on('String.class') {}
        def on(event, &block)
        end
      end

      def type_of_node(node)
        ::RuboCop::Typed.driver.type_of_node(path: processed_source.path, node: node)
      end

      def investigate(processed_source)
        super

        traverse = -> (node, &block) do
          block.call(node)
          node.children.each do |child|
            traverse.call(child, &block) if child.is_a?(Parser::AST::Node)
          end
        end

        traverse.call(processed_source.ast) do |node|
          type = type_of_node(node)
          next unless type

          p type
        end
      end
    end
  end
end

