# frozen_string_literal: true

$LOAD_PATH << File.expand_path('~/ghq/github.com/soutaro/steep/vendor/ruby-signature/lib') # FIXME

require 'rubocop'
require 'steep'

require_relative 'rubocop/typed'
require_relative 'rubocop/typed/version'
require_relative 'rubocop/typed/inject'

RuboCop::Typed::Inject.defaults!

require_relative 'rubocop/cop/typed_cops'
