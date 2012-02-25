# EventMachine Logger

An experimental logger class for EventMachine applications.

## Usage

EM::Logger is a simple delegator around the ruby logger class.  It responds to all the log levels you are familiar with from existing loggers (info, debug, warn, etc.).  The only difference is that it's instantiated by passing an existing logger in when initializing

    require 'eventmachine'
    require 'logger'
    require 'em-logger'

    log = Logger.new(STDOUT)
    logger = EM::Logger.new(log)

    EM.run do
      logger.info('ohai')

      EM.stop
    end


## Contributing

Pull requests welcome: fork, make a topic branch, commit (squash when possible) *with tests* and I'll happily consider.

## Copyright

Copyright (c) 2012 Steve Agalloco. See [LICENSE](https://github.com/spagalloco/em-logger/blob/master/LICENSE.md) for detail