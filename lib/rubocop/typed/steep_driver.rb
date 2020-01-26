module RuboCop
  module Typed
    class SteepDriver
      include ::Steep::Drivers::Utils::DriverHelper

      attr_reader :project

      def silent(&block)
        stdout = $stdout
        stderr = $stderr
        $stdout = StringIO.new
        $stderr = StringIO.new
        block.call
      ensure
        $stdout = stdout
        $stderr = stderr
      end

      def init_project
        silent do
          @project = load_config()
          loader = ::Steep::Project::FileLoader.new(project: @project)
          loader.load_sources([])
          loader.load_signatures()
          type_check(project)
        end
      end

      def type_of_node(node:, path:)
        case node.type
        when :send, :csend
          loc = node.loc.selector
        else
          loc = node.loc.expression
        end
        line = loc&.line
        column = loc&.column
        return unless line
        return unless column

        project.type_of_node(path: Pathname(path), line: line, column: column)
      end
    end
  end
end
