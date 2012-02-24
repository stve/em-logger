require 'spec_helper'

describe EventMachine::Logger do

  context 'creating' do
    it 'instatiates with a logger' do
      EM.run_block do
        l = ::Logger.new(STDOUT)
        eml = EventMachine::Logger.new(l)
        eml.logger.should eq(l)
      end
    end
  end

  context 'log statements' do
    let(:loggr) { ::Logger.new(STDOUT) }
    let(:eml) { EventMachine::Logger.new(loggr) }

    %w(debug info warn error fatal).each do |l|
      describe "##{l}" do
        it 'pushes the log message onto the logger_queue' do
          eml.logger_queue.should_receive('push').once
          eml.send("#{l}", 'this is a test')
        end
      end

      describe "##{l}?" do
        it 'passes through to the underlying logger' do
          loggr.should_receive("#{l}?").once
          eml.send("#{l}?")
        end
      end
    end

    describe "#unknown" do
      it 'pushes the log message onto the logger_queue' do
        eml.logger_queue.should_receive('push').once
        eml.unknown('this is a test')
      end
    end

    describe '#<<' do
      it 'pushes the log message onto the logger_queue' do
        eml.logger_queue.should_receive('push').once
        eml << 'this is a test'
      end
    end
  end

  context 'queuing' do
    let(:loggr) { ::Logger.new(STDOUT) }

    describe '#add' do
      context 'when logging below the defined level' do
        it 'pushes the log message onto the logger_queue' do
          loggr.level = ::Logger::WARN
          eml = EventMachine::Logger.new(loggr)
          eml.logger_queue.should_not_receive('push')
          eml.add(::Logger::INFO, 'this is a test').should be_true
        end
      end

      context 'when logging above the defined level' do
        it 'pushes the log message onto the logger_queue' do
          eml = EventMachine::Logger.new(loggr)
          eml.logger_queue.should_receive('push').once
          eml.add(::Logger::INFO, 'this is a test')
        end
      end

      context 'when using a block' do
        it 'evaluates the block' do
          eml = EventMachine::Logger.new(loggr)
          eml.logger_queue.should_receive('push').once
          eml.add(::Logger::INFO) { 'ohai' }
        end
      end
    end
  end

  context 'delegating to logger' do
    let(:loggr) { ::Logger.new(STDOUT) }

    describe 'method_missing' do
      it 'passes through to the underlying logger' do
        eml = EventMachine::Logger.new(loggr)
        loggr.should_receive("level").once
        eml.level
      end

      it 'returns the underlying loggers value' do
        loggr.level = ::Logger::WARN
        eml = EventMachine::Logger.new(loggr)
        eml.level.should eq(::Logger::WARN)
      end
    end

    describe 'respond_to?' do
      it 'responds to methods defined on the logger' do
        eml = EventMachine::Logger.new(loggr)
        eml.respond_to?('level').should be_true
      end
    end
  end

end