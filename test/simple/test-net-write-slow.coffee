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
common = require("../common")
assert = require("assert")
net = require("net")
SIZE = 2e5
N = 10
flushed = 0
received = 0
buf = new Buffer(SIZE)
buf.fill 0x61 # 'a'
server = net.createServer((socket) ->
  socket.setNoDelay()
  socket.setTimeout 1000
  socket.on "timeout", ->
    assert.fail "flushed: " + flushed + ", received: " + received + "/" + SIZE * N
    return

  i = 0

  while i < N
    socket.write buf, ->
      ++flushed
      socket.setTimeout 0  if flushed is N
      return

    ++i
  socket.end()
  return
).listen(common.PORT, ->
  conn = net.connect(common.PORT)
  conn.on "data", (buf) ->
    received += buf.length
    conn.pause()
    setTimeout (->
      conn.resume()
      return
    ), 20
    return

  conn.on "end", ->
    server.close()
    return

  return
)
process.on "exit", ->
  assert.equal received, SIZE * N
  return

