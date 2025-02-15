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

# This is similar to simple/test-socket-write-after-fin, except that
# we don't set allowHalfOpen.  Then we write after the client has sent
# a FIN, and this is an error.  However, the standard "write after end"
# message is too vague, and doesn't actually tell you what happens.
net = require("net")
serverData = ""
gotServerEnd = false
clientData = ""
gotClientEnd = false
gotServerError = false
server = net.createServer((sock) ->
  sock.setEncoding "utf8"
  sock.on "error", (er) ->
    console.error er.code + ": " + er.message
    gotServerError = er
    return

  sock.on "data", (c) ->
    serverData += c
    return

  sock.on "end", ->
    gotServerEnd = true
    sock.write serverData
    sock.end()
    return

  server.close()
  return
)
server.listen common.PORT
sock = net.connect(common.PORT)
sock.setEncoding "utf8"
sock.on "data", (c) ->
  clientData += c
  return

sock.on "end", ->
  gotClientEnd = true
  return

process.on "exit", ->
  assert.equal clientData, ""
  assert.equal serverData, "hello1hello2hello3\nTHUNDERMUSCLE!"
  assert gotClientEnd
  assert gotServerEnd
  assert gotServerError
  assert.equal gotServerError.code, "EPIPE"
  assert.notEqual gotServerError.message, "write after end"
  console.log "ok"
  return

sock.write "hello1"
sock.write "hello2"
sock.write "hello3\n"
sock.end "THUNDERMUSCLE!"
