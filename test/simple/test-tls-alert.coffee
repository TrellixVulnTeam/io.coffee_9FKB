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
filenamePEM = (n) ->
  require("path").join common.fixturesDir, "keys", n + ".pem"
loadPEM = (n) ->
  fs.readFileSync filenamePEM(n)
common = require("../common")
unless common.opensslCli
  console.error "Skipping because node compiled without OpenSSL CLI."
  process.exit 0
assert = require("assert")
fs = require("fs")
tls = require("tls")
spawn = require("child_process").spawn
success = false
server = tls.Server(
  secureProtocol: "TLSv1_2_server_method"
  key: loadPEM("agent2-key")
  cert: loadPEM("agent2-cert")
, null).listen(common.PORT, ->
  args = [
    "s_client"
    "-quiet"
    "-tls1_1"
    "-connect"
    "127.0.0.1:" + common.PORT
  ]
  client = spawn(common.opensslCli, args)
  out = ""
  client.stderr.setEncoding "utf8"
  client.stderr.on "data", (d) ->
    out += d
    if /SSL alert number 70/.test(out)
      success = true
      server.close()
    return

  return
)
process.on "exit", ->
  assert success
  return

