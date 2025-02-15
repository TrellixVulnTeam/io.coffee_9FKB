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

# username = "user", password = "pass:"
check = (request) ->
  
  # the correct authorization header is be passed
  assert.strictEqual request.headers.authorization, "Basic dXNlcjpwYXNzOg=="
  return
common = require("../common")
assert = require("assert")
http = require("http")
url = require("url")
testURL = url.parse("http://user:pass%3A@localhost:" + common.PORT)
server = http.createServer((request, response) ->
  
  # run the check function
  check.call this, request, response
  response.writeHead 200, {}
  response.end "ok"
  server.close()
  return
)
server.listen common.PORT, ->
  
  # make the request
  http.request(testURL).end()
  return

