stream-mux-demux
================

Multiplex-demultiplex object streams over object stream

To get started, install ``stream-mux-demux`` package via ``npm``::

    % npm install stream-mux-demux

After that you will be able to use ``stream-rpc`` library in your code.  The
basic usage example is as follows::

    var muxdemux = require('stream-mux-demux');

    var server = muxdemux(),
        client = muxdemux();

    server.pipe(client).pipe(server);

    var sEvents = server.createStream('events'),
        cEvents = client.createStream('events');

    var sRPC = server.createStream('rpc'),
        cRPC = client.createStream('rpc');

Now ``sEvents`` communicates with ``cEvents`` and ``sRPC`` — with ``cRPC`` using
`server-client` pipeline as a transport stream.

Note that ``server`` and ``client`` streams are `object` streams, that means
that for piping them over a network will require choosing a serialization
protocol, something like
stream-serializer_ could help
there.

.. _stream-serializer: https://github.com/dominictarr/stream-serializer
