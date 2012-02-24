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

  describe '#level' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("level").once
      eml.level
    end  end

  describe '#level=' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("level=").once
      eml.level = ::Logger::WARN
    end
  end

  describe '#datetime_format' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("datetime_format").once
      eml.datetime_format
    end
  end

  describe '#datetime_format=' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("datetime_format=").once
      eml.datetime_format = '%Y'
    end
  end

  describe '#progname' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("progname").once
      eml.progname
    end
  end

  describe '#progname=' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("progname=").once
      eml.progname = 'EM::Logger tests'
    end
  end

  describe '#formatter' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("formatter").once
      eml.formatter
    end
  end

  describe '#formatter=' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("formatter=").once
      eml.formatter = stub('Formatter')
    end
  end

  %w(debug info warn error fatal).each do |l|
    describe "##{l}" do
      it 'pushes the log message onto the logger_queue' do
        loggr = ::Logger.new(STDOUT)
        eml = EventMachine::Logger.new(loggr)
        eml.logger_queue.should_receive('push').once
        eml.send("#{l}", 'this is a test')
      end
    end

    describe "##{l}?" do
      it 'passes through to the underlying logger' do
        loggr = stub('Logger')
        eml = EventMachine::Logger.new(loggr)
        loggr.should_receive("#{l}?").once
        eml.send("#{l}?")
      end
    end
  end

  describe "#unknown" do
    it 'pushes the log message onto the logger_queue' do
      loggr = ::Logger.new(STDOUT)
      eml = EventMachine::Logger.new(loggr)
      eml.logger_queue.should_receive('push').once
      eml.unknown('this is a test')
    end
  end

  describe '#add' do
    pending
  end

  describe '#<<' do
    it 'pushes the log message onto the logger_queue' do
      loggr = ::Logger.new(STDOUT)
      eml = EventMachine::Logger.new(loggr)
      eml.logger_queue.should_receive('push').once
      eml << 'this is a test'
    end
  end

  describe '#close' do
    it 'passes through to the underlying logger' do
      loggr = stub('Logger')
      eml = EventMachine::Logger.new(loggr)
      loggr.should_receive("close").once
      eml.close
    end
  end

end