require 'active_job'
require 'active_support/core_ext/hash'

module ActiveJob
  module Ffmpeg
    class BaseJob < ActiveJob::Base
      def perform(input_filename, output_filename, extra_data = {}, format = :mp4)
        case format.to_s
        when "mp4"
          encoder = Encoder::MP4.new
        when "webm"
          encoder = Encoder::WebM.new
        end

        encoder.on_progress = Proc.new {|progress| on_progress(progress, extra_data)} \
          if respond_to?(:on_progress)

        encoder.on_complete = Proc.new {|enc| on_complete(enc, extra_data)} \
          if respond_to?(:on_complete)

        encoder.do_encode(input_filename, output_filename)
      end
    end
  end
end
