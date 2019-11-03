# frozen_string_literal: true

module RuboCop
  module Cop
    module Typed
      # TODO: Write cop description and example of bad / good code. For every
      # `SupportedStyle` and unique configuration, there needs to be examples.
      # Examples must have valid Ruby syntax. Do not use upticks.
      #
      # @example EnforcedStyle: bar (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   bad_bar_method
      #
      #   # bad
      #   bad_bar_method(args)
      #
      #   # good
      #   good_bar_method
      #
      #   # good
      #   good_bar_method(args)
      #
      # @example EnforcedStyle: foo
      #   # Description of the `foo` style.
      #
      #   # bad
      #   bad_foo_method
      #
      #   # bad
      #   bad_foo_method(args)
      #
      #   # good
      #   good_foo_method
      #
      #   # good
      #   good_foo_method(args)
      #
      class RedundantSafeNavigation < Cop
        include RuboCop::Typed::CopHelper

        MSG = 'Do not use safe navigation operator with non nilable expression.'

        def on_csend(node)
          type = RuboCop::Typed::Util.type_of_node(node: node, processed_source: processed_source)
          p [node, type]
          return if RuboCop::Typed::Util.nilable?(type)

          add_offense(node)
        end
      end
    end
  end
end
