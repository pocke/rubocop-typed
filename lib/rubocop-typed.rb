# frozen_string_literal: true

$LOAD_PATH << File.expand_path('~/ghq/github.com/soutaro/steep/vendor/ruby-signature/lib') # FIXME

require 'rubocop'
require 'steep'

require_relative 'rubocop/typed'
require_relative 'rubocop/typed/version'
require_relative 'rubocop/typed/inject'
require_relative 'rubocop/typed/steep_driver'
require_relative 'rubocop/typed/cop_helper'

RuboCop::Typed::Inject.defaults!
RuboCop::Typed.init_steep_project

require_relative 'rubocop/cop/typed_cops'
