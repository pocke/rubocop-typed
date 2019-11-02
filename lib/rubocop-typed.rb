# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/typed'
require_relative 'rubocop/typed/version'
require_relative 'rubocop/typed/inject'

RuboCop::Typed::Inject.defaults!

require_relative 'rubocop/cop/typed_cops'
