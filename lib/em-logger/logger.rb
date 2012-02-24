require 'eventmachine'

module EventMachine
  class LogMessage
    attr_accessor :severity, :message, :progname

    def initialize(severity, message=nil, progname=nil)
      @severity = severity
      @message = message
      @progname = progname
    end

  end

  class Logger

    attr_reader :logger
    attr_reader :logger_queue

    def initialize(logger)
      @logger = logger
      @logger_queue = EM::Queue.new

      queue_processor = Proc.new do |log_message|
        @logger.add(log_message.severity, log_message.message, log_message.progname)
        EM.next_tick { @logger_queue.pop(&queue_processor) }
      end

      @logger_queue.pop(&queue_processor)
    end

    def add(severity, message = nil, progname = nil, &block)
      return true if severity < @logger.level
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @logger.progname
        end
      end
      @logger_queue.push(LogMessage.new(severity, message, progname))
    end
    alias log add

    # Log a +DEBUG+ message.
    def debug(progname = nil, &block)
      add(::Logger::DEBUG, nil, progname, &block)
    end

    # Log a +INFO+ message.
    def info(progname = nil, &block)
      add(::Logger::INFO, nil, progname, &block)
    end

    # Log a +WARN+ message.
    def warn(progname = nil, &block)
      add(::Logger::WARN, nil, progname, &block)
    end

    # Log a +ERROR+ message.
    def error(progname = nil, &block)
      add(::Logger::ERROR, nil, progname, &block)
    end

    # Log a +FATAL+ message.
    def fatal(progname = nil, &block)
      add(::Logger::FATAL, nil, progname, &block)
    end

    # Log an +UNKNOWN+ message.
    def unknown(progname = nil, &block)
      add(::Logger::UNKNOWN, nil, progname, &block)
    end

    def <<(data)
      @logger_queue.push(LogMessage.new(nil,data))
    end

    def method_missing(method, *args, &block)
      return super unless @logger.respond_to?(method)
      @logger.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      @logger.respond_to?(method, include_private) || super(method, include_private)
    end

  end
end