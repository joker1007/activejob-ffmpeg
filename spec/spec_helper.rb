$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'active_job'
require 'active_job/ffmpeg'

require 'tapp'

$spec_dir = File.dirname(File.expand_path(__FILE__))

RSpec.configure do |config|
  config.order = :random
end

def sample_dir
  File.expand_path("../samples", __FILE__)
end
