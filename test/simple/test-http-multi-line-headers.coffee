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
http = require("http")
net = require("net")
gotResponse = false
server = net.createServer((conn) ->
  body = "Yet another node.js server."
  response = "HTTP/1.1 200 OK\r\n" + "Connection: close\r\n" + "Content-Length: " + body.length + "\r\n" + "Content-Type: text/plain;\r\n" + " x-unix-mode=0600;\r\n" + " name=\"hello.txt\"\r\n" + "\r\n" + body
  conn.end response
  server.close()
  return
)
server.listen common.PORT, ->
  http.get
    host: "127.0.0.1"
    port: common.PORT
  , (res) ->
    assert.equal res.headers["content-type"], "text/plain; x-unix-mode=0600; name=\"hello.txt\""
    gotResponse = true
    res.destroy()
    return

  return

process.on "exit", ->
  assert.ok gotResponse
  return

