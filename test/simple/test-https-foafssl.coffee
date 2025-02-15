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
unless common.opensslCli
  console.error "Skipping because node compiled without OpenSSL CLI."
  process.exit 0
assert = require("assert")
join = require("path").join
fs = require("fs")
spawn = require("child_process").spawn
https = require("https")
options =
  key: fs.readFileSync(common.fixturesDir + "/agent.key")
  cert: fs.readFileSync(common.fixturesDir + "/agent.crt")
  requestCert: true

reqCount = 0
CRLF = "\r\n"
body = "hello world\n"
cert = undefined
subjectaltname = undefined
modulus = undefined
exponent = undefined
server = https.createServer(options, (req, res) ->
  reqCount++
  console.log "got request"
  cert = req.connection.getPeerCertificate()
  subjectaltname = cert.subjectaltname
  modulus = cert.modulus
  exponent = cert.exponent
  res.writeHead 200,
    "content-type": "text/plain"

  res.end body
  return
)
server.listen common.PORT, ->
  args = [
    "s_client"
    "-quiet"
    "-connect"
    "127.0.0.1:" + common.PORT
    "-cert"
    join(common.fixturesDir, "foafssl.crt")
    "-key"
    join(common.fixturesDir, "foafssl.key")
  ]
  client = spawn(common.opensslCli, args)
  client.stdout.on "data", (data) ->
    message = data.toString()
    contents = message.split(CRLF + CRLF).pop()
    assert.equal body, contents
    server.close()
    return

  client.stdin.write "GET /\n\n"
  client.on "error", (error) ->
    throw errorreturn

  return

process.on "exit", ->
  assert.equal subjectaltname, "URI:http://example.com/#me"
  assert.equal modulus, "A6F44A9C25791431214F5C87AF9E040177A8BB89AC803F7E09" + "BBC3A5519F349CD9B9C40BE436D0AA823A94147E26C89248ADA2BE3DD4D34E8C2896" + "4694B2047D217B4F1299371EA93A83C89AB9440724131E65F2B0161DE9560CDE9C13" + "455552B2F49CF0FB00D8D77532324913F6F80FF29D0A131D29DB06AFF8BE191B7920" + "DC2DAE1C26EA82A47847A10391EF3BF6AABB3CC40FF82100B03A4F0FF1809278E4DD" + "FDA7DE954ED56DC7AD9A47EEBC37D771A366FC60A5BCB72373BEC180649B3EFA0E90" + "92707210B41B90032BB18BC91F2046EBDAF1191F4A4E26D71879C4C7867B62FCD508" + "E8CE66E82D128A71E915809FCF44E8DE774067F1DE5D70B9C03687"
  assert.equal exponent, "10001"
  return

