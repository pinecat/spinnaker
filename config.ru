# frozen_string_literal: true

require_relative "lib/spinnaker"

use Spinnaker
run do |_env|
  [200, {}, ["<head><title>The Expanse</title></head><body><p>Welcome to my blog!</p></body>"]]
end
