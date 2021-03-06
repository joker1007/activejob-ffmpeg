require "spec_helper"

describe ActiveJob::Ffmpeg do
  describe ".get_aspect" do
    subject { ActiveJob::Ffmpeg.get_aspect("#{sample_dir}/sample_16_9.mp4") }

    it { should eq "16/9".to_r }
  end

  describe "#do_encode" do
    context "MP4" do
      subject(:encoder) { ActiveJob::Ffmpeg::Encoder::MP4.new }

      describe "on_progress callback" do
        before do
          encoder.on_progress = Proc.new {|progress| true }
        end

        it "on_progress receive call" do
          expect(encoder.on_progress).to receive(:call).with(an_instance_of(Float)).at_least(4).and_call_original
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.mp4")
        end

        describe "shellescape" do
          it "on_progress receive call" do
            expect(encoder.on_progress).to receive(:call).with(an_instance_of(Float)).at_least(4).and_call_original
            encoder.do_encode("#{sample_dir}/hoge's title.mp4", "#{sample_dir}/output.mp4")
          end
        end
      end

      describe "on_complete callback" do
        before do
          encoder.on_complete = Proc.new {|encoder| true }
        end

        it "on_complete receive call" do
          expect(encoder.on_complete).to receive(:call).with(encoder).once
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.mp4")
        end
      end

      describe "debug log" do
        before do
          ENV["DEBUG"] = "1"
          expect(ActiveJob::Ffmpeg.logger).to be_a(Logger)
        end

        after do
          ENV["DEBUG"] = nil
        end

        it "should call logger.debug" do
          expect(ActiveJob::Ffmpeg.logger).to receive(:debug)
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.mp4")
        end
      end
    end

    context "WebM" do
      subject(:encoder) { ActiveJob::Ffmpeg::Encoder::WebM.new }

      describe "on_progress callback" do
        before do
          encoder.on_progress = Proc.new {|progress| true }
        end

        it "on_progress receive call" do
          expect(encoder.on_progress).to receive(:call).with(an_instance_of(Float)).at_least(4)
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.webm")
        end
      end

      describe "on_complete callback" do
        before do
          encoder.on_complete = Proc.new {|encoder| true }
        end

        it "on_complete receive call" do
          expect(encoder.on_complete).to receive(:call).with(encoder).once
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.webm")
        end
      end
    end
  end
end

describe ActiveJob::Ffmpeg::BaseJob do
  context "When job is performed" do
    class ::TestJob < ActiveJob::Ffmpeg::BaseJob
    end

    it "should receive do_encode" do
      input_filename = "#{sample_dir}/sample.mp4"
      output_filename = "#{sample_dir}/output.mp4"
      expect_any_instance_of(ActiveJob::Ffmpeg::Encoder::MP4).to receive(:do_encode).with(input_filename, output_filename).once
      TestJob.perform_later(input_filename, output_filename)
    end
  end

  context "Job class has on_progress method" do
    class ProgressJob < ActiveJob::Ffmpeg::BaseJob

      def on_progress(progress, extra_data = {})
        true
      end
    end

    it "should receive on_progress" do
      input_filename = "#{sample_dir}/sample.mp4"
      output_filename = "#{sample_dir}/output.mp4"
      expect_any_instance_of(ProgressJob).to receive(:on_progress).with(an_instance_of(Float), {}).at_least(4)
      ProgressJob.perform_later(input_filename, output_filename)
    end
  end

  context "Job class has on_complete method" do
    class CompleteJob < ActiveJob::Ffmpeg::BaseJob

      def on_complete(encoder, extra_data = {})
        true
      end
    end

    it "should receive on_complete" do
      input_filename = "#{sample_dir}/sample.mp4"
      output_filename = "#{sample_dir}/output.mp4"
      expect_any_instance_of(CompleteJob).to receive(:on_complete).with(an_instance_of(ActiveJob::Ffmpeg::Encoder::MP4), {"id" => 1}).once
      CompleteJob.perform_later(input_filename, output_filename, {"id" => 1})
    end
  end
end

