module RuboCop
  module Typed
    class SteepDriver
      include ::Steep::Drivers::Utils::DriverHelper

      attr_reader :project

      def init_project
        @project = load_config()
        load_sources(project, [])
        load_signatures(project)
        type_check(project)
      end

      def type_of_node(node:, path:)
        project.type_of_node(path: Pathname(path), line: node.loc.line, column: node.loc.column)
      end
    end
  end
end

