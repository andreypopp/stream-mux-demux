{ok, notEqual, deepEqual} = require 'assert'
muxdemux = require './src/index'

describe 'stream-mux-demux', ->

  s = {}

  beforeEach ->
    a = muxdemux()
    b = muxdemux()

    aa = a.createStream('a')
    ab = a.createStream('b')

    ba = b.createStream('a')
    bb = b.createStream('b')

    s = {a, aa, ab, b, ba, bb}

  it 'stores substreams', ->
    {a, b} = s
    notEqual a.streams.a, undefined
    notEqual a.streams.b, undefined
    notEqual b.streams.a, undefined
    notEqual b.streams.b, undefined

  it 'multiplexes', (done) ->
    {a, aa, ab} = s
    seenA = false
    seenB = false
    a.on 'data', (chunk) ->
      [name, payload] = chunk
      switch name
        when 'a'
          deepEqual payload, 'x'
          seenA = true
        when 'b'
          deepEqual payload, 'y'
          seenB = true

      done() if seenA and seenB

    aa.write('x')
    ab.write('y')

  it 'demultiplexes', (done) ->
    {a, aa, ab} = s
    seenA = false
    seenB = false
    aa.on 'data', (chunk) ->
      deepEqual chunk, 'x'
      seenA = true
      done() if seenA and seenB
    ab.on 'data', (chunk) ->
      deepEqual chunk, 'y'
      seenB = true
      done() if seenA and seenB
    a.write(['a', 'x'])
    a.write(['b', 'y'])

  it 'mux-demux', (done) ->
    {a, aa, ab, b, ba, bb} = s
    a.pipe(b).pipe(a)
    seenA = false
    seenB = false
    aa.on 'data', (chunk) ->
      deepEqual chunk, 'x'
      seenA = true
      done() if seenA and seenB
    ab.on 'data', (chunk) ->
      deepEqual chunk, 'y'
      seenB = true
      done() if seenA and seenB
    ba.write('x')
    bb.write('y')

  it 'propagates "end" event', (done) ->

    {a, aa} = s
    aa.on 'end', -> done()
    a.emit 'end'
