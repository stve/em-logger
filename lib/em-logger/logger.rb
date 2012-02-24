require 'eventmachine'

module EventMachine
  class LogMessage
    attr_accessor :severity, :message, :progname

    def initialize(sev, message=nil, progname=nil)
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
    end

    def level; @logger.level; end
    def level=(l); @logger.level = l; end

    def datetime_format; @logger.datetime_format; end
    def datetime_format=(l); @logger.datetime_format = l; end

    def progname; @logger.progname; end
    def progname=(l); @logger.progname = l; end

    def formatter; @logger.formatter; end
    def formatter=(l); @logger.formatter = l; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +DEBUG+ messages.
    def debug?; @logger.debug?; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +INFO+ messages.
    def info?; @logger.info?; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +WARN+ messages.
    def warn?; @logger.warn?; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +ERROR+ messages.
    def error?; @logger.error?; end

    # Returns +true+ iff the current severity level allows for the printing of
    # +FATAL+ messages.
    def fatal?; @logger.fatal?; end

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

    def close
      @logger.close
    end

  end
end