###

  Multiplexing-demultiplexing of several object streams inside single object
  stream.

###

through = require 'through'

module.exports = (options = {}) ->
  ###

    Create mux-demux stream.

    :param options: Object with options
    :option error: Propagate error on substreams (default ``false``)

  ###

  s = through (obj) ->
    [name, obj] = obj
    ss = s.streams[name]
    if not ss
      console.warn "orphaned data for stream #{name}"
    else
      ss.emit 'data', obj

  s.streams = {}

  s.on 'end', ->
    for name, ss of s.streams
      ss.emit 'end'

  s.createStream = (name) ->
    ss = s.streams[name] = through (obj) ->
      s.emit 'data', [name, obj]

    ss.on 'end', ->
      s.streams[name] = undefined

    if options.error
      s.on 'error', -> ss.emit 'error'

    ss

  s
