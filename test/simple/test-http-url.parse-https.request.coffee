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

# https options
check = (request) ->
  
  # assert that I'm https
  assert.ok request.socket._secureEstablished
  return
common = require("../common")
assert = require("assert")
https = require("https")
url = require("url")
fs = require("fs")
clientRequest = undefined
httpsOptions =
  key: fs.readFileSync(common.fixturesDir + "/keys/agent1-key.pem")
  cert: fs.readFileSync(common.fixturesDir + "/keys/agent1-cert.pem")

testURL = url.parse("https://localhost:" + common.PORT)
testURL.rejectUnauthorized = false
server = https.createServer(httpsOptions, (request, response) ->
  
  # run the check function
  check.call this, request, response
  response.writeHead 200, {}
  response.end "ok"
  server.close()
  return
)
server.listen common.PORT, ->
  
  # make the request
  clientRequest = https.request(testURL)
  
  # since there is a little magic with the agent
  # make sure that the request uses the https.Agent
  assert.ok clientRequest.agent instanceof https.Agent
  clientRequest.end()
  return

