# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Typed
      class Dig < Cop
        def on_send(node)
          sends = sends(node)
          return unless sends
          return unless sends.size >= 2

          respond_to_dig = sends.all? do |s|
            type = RuboCop::Typed::Util.type_of_node(node: s.receiver, processed_source: processed_source)
            interface = RuboCop::Typed::Util.type_to_interface(type: type, processed_source: processed_source)
            interface.methods[:dig]
          end
          return unless respond_to_dig

          add_offense(node, message: sends.inspect)
        end

        private def sends(node)
          return unless node.send_type?
          return unless node.method_name == :[]
          return unless node.arguments.size == 1

          rest = sends(node.receiver)
          if rest
            [*rest, node]
          else
            [node]
          end
        end
      end
    end
  end
end
