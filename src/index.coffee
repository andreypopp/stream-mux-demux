###

  Multiplexing-demultiplexing of several object streams inside single object
  stream.

###

through = require 'through'

module.exports = ->

  s = through (obj) ->
    [name, obj] = obj
    ss = s.streams[name]
    if not ss
      console.warn "orphaned data for stream #{name}"
    else
      ss.emit 'data', obj

  s.streams = {}

  s.createStream = (name) ->
    ss = s.streams[name] = through (obj) ->
      s.emit 'data', [name, obj]
    ss

  s
