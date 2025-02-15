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
unauthorized = ->
  req = https.request(
    port: common.PORT
    rejectUnauthorized: false
  , (res) ->
    assert not req.socket.authorized
    res.resume()
    rejectUnauthorized()
    return
  )
  req.on "error", (err) ->
    throw errreturn

  req.end()
  return
rejectUnauthorized = ->
  options = port: common.PORT
  options.agent = new https.Agent(options)
  req = https.request(options, (res) ->
    assert false
    return
  )
  req.on "error", (err) ->
    authorized()
    return

  req.end()
  return
authorized = ->
  options =
    port: common.PORT
    ca: [fs.readFileSync(path.join(common.fixturesDir, "test_cert.pem"))]

  options.agent = new https.Agent(options)
  req = https.request(options, (res) ->
    res.resume()
    assert req.socket.authorized
    server.close()
    return
  )
  req.on "error", (err) ->
    assert false
    return

  req.end()
  return
unless process.versions.openssl
  console.error "Skipping because node compiled without OpenSSL."
  process.exit 0
common = require("../common")
assert = require("assert")
https = require("https")
fs = require("fs")
path = require("path")
options =
  key: fs.readFileSync(path.join(common.fixturesDir, "test_key.pem"))
  cert: fs.readFileSync(path.join(common.fixturesDir, "test_cert.pem"))

reqCount = 0
server = https.createServer(options, (req, res) ->
  ++reqCount
  res.writeHead 200
  res.end()
  req.resume()
  return
).listen(common.PORT, ->
  unauthorized()
  return
)
process.on "exit", ->
  assert.equal reqCount, 2
  return

