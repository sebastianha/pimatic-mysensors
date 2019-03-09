module.exports = (env) ->
  events = require 'events'
  SerialPort = require('serialport')
  Readline = require('@serialport/parser-readline')
  Promise = env.require 'bluebird'

  class SerialPortDriver extends events.EventEmitter
    constructor: (protocolOptions)->
      env.logger.debug "initializing new SerialPortDriver"
      @port = new SerialPort(protocolOptions.serialDevice, {
        baudRate: protocolOptions.baudrate
      })
      @parser = new Readline()
      @port.pipe(@parser)
      
    connect: (timeout, retries) ->
      return new Promise( (resolve, reject) =>
        @parser.on('data', (line) =>
          @emit('line', line) 
        )
      )

    disconnect: -> @port.close()
    write: (data) -> @port.write(data)
  module.exports = SerialPortDriver
