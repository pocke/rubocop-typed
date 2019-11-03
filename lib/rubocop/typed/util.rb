module RuboCop
  module Typed
    module Util
      extend self

      def nilable?(node:, processed_source:)
        type = type_of_node(node: node, processed_source: processed_source)
        case type
        when Steep::AST::Types::Nil, Steep::AST::Types::Any
          true
        when Steep::AST::Types::Boolean, Steep::AST::Types::Instance
          false
        when Steep::AST::Types::Union
          type.types.any? { |t| nilable?(t) }
        else
          true
        end
      end

      def type_of_node(node:, processed_source:)
        path = PathUtil.smart_path(processed_source.path)
        ::RuboCop::Typed.driver.type_of_node(path: path, node: node)
      end
    end
  end
end
