# Copyright Joyent, Inc. and other Node contributors.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the
# following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
# USE OR OTHER DEALINGS IN THE SOFTWARE.
pingPongTest = (port, host, on_complete) ->
  N = 1000
  count = 0
  sent_final_ping = false
  server = net.createServer(
    allowHalfOpen: true
  , (socket) ->
    assert.equal true, socket.remoteAddress isnt null
    assert.equal true, socket.remoteAddress isnt `undefined`
    address = socket.remoteAddress
    if host is "127.0.0.1"
      assert.equal address, "127.0.0.1"
    else if not host? or host is "localhost"
      assert address is "127.0.0.1" or address is "::ffff:127.0.0.1"
    else
      console.log "host = " + host + ", remoteAddress = " + address
      assert.equal address, "::1"
    socket.setEncoding "utf8"
    socket.setNoDelay()
    socket.timeout = 0
    socket.on "data", (data) ->
      console.log "server got: " + JSON.stringify(data)
      assert.equal "open", socket.readyState
      assert.equal true, count <= N
      socket.write "PONG"  if /PING/.exec(data)
      return

    socket.on "end", ->
      assert.equal "writeOnly", socket.readyState
      socket.end()
      return

    socket.on "close", (had_error) ->
      assert.equal false, had_error
      assert.equal "closed", socket.readyState
      socket.server.close()
      return

    return
  )
  server.listen port, host, ->
    client = net.createConnection(port, host)
    client.setEncoding "utf8"
    client.on "connect", ->
      assert.equal "open", client.readyState
      client.write "PING"
      return

    client.on "data", (data) ->
      console.log "client got: " + data
      assert.equal "PONG", data
      count += 1
      if sent_final_ping
        assert.equal "readOnly", client.readyState
        return
      else
        assert.equal "open", client.readyState
      if count < N
        client.write "PING"
      else
        sent_final_ping = true
        client.write "PING"
        client.end()
      return

    client.on "close", ->
      assert.equal N + 1, count
      assert.equal true, sent_final_ping
      on_complete()  if on_complete
      tests_run += 1
      return

    return

  return
common = require("../common")
assert = require("assert")
net = require("net")
tests_run = 0

# All are run at once, so run on different ports 
pingPongTest common.PORT, "localhost"
pingPongTest common.PORT + 1, null

# This IPv6 isn't working on Solaris
solaris = /sunos/i.test(process.platform)
pingPongTest common.PORT + 2, "::1"  unless solaris
process.on "exit", ->
  assert.equal (if solaris then 2 else 3), tests_run
  return

