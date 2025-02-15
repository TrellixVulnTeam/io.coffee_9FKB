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
https = require("https")
fs = require("fs")
assert = require("assert")
if [
  "linux"
  "win32"
].indexOf(process.platform) is -1
  console.log "Skipping platform-specific test."
  process.exit()
options =
  key: fs.readFileSync(common.fixturesDir + "/keys/agent1-key.pem")
  cert: fs.readFileSync(common.fixturesDir + "/keys/agent1-cert.pem")

server = https.createServer(options, (req, res) ->
  console.log "Connect from: " + req.connection.remoteAddress
  assert.equal "127.0.0.2", req.connection.remoteAddress
  req.on "end", ->
    res.writeHead 200,
      "Content-Type": "text/plain"

    res.end "You are from: " + req.connection.remoteAddress
    return

  req.resume()
  return
)
server.listen common.PORT, "127.0.0.1", ->
  options =
    host: "localhost"
    port: common.PORT
    path: "/"
    method: "GET"
    localAddress: "127.0.0.2"
    rejectUnauthorized: false

  req = https.request(options, (res) ->
    res.on "end", ->
      server.close()
      process.exit()
      return

    res.resume()
    return
  )
  req.end()
  return

