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
unless process.versions.openssl
  console.error "Skipping because node compiled without OpenSSL."
  process.exit 0

# disable strict server certificate validation by the client
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"
common = require("../common")
assert = require("assert")
https = require("https")
fs = require("fs")
seen_req = false
options =
  key: fs.readFileSync(common.fixturesDir + "/keys/agent1-key.pem")
  cert: fs.readFileSync(common.fixturesDir + "/keys/agent1-cert.pem")

server = https.createServer(options, (req, res) ->
  assert.equal "GET", req.method
  assert.equal "/foo?bar", req.url
  res.writeHead 200,
    "Content-Type": "text/plain"

  res.write "hello\n"
  res.end()
  server.close()
  seen_req = true
  return
)
server.listen common.PORT, ->
  https.get "https://127.0.0.1:" + common.PORT + "/foo?bar"
  return

process.on "exit", ->
  assert seen_req
  return

