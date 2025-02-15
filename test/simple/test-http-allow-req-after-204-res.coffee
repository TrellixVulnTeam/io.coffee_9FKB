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

# first 204 or 304 works, subsequent anything fails

# Methods don't really matter, but we put in something realistic.
nextRequest = ->
  method = methods.shift()
  console.error "writing request: %s", method
  request = http.request(
    port: common.PORT
    method: method
    path: "/"
  , (response) ->
    response.on "end", ->
      if methods.length is 0
        console.error "close server"
        server.close()
      else
        
        # throws error:
        nextRequest()
      return

    
    # works just fine:
    #process.nextTick(nextRequest);
    response.resume()
    return
  )
  request.end()
  return
common = require("../common")
http = require("http")
assert = require("assert")
codes = [
  204
  200
]
methods = [
  "DELETE"
  "DELETE"
]
server = http.createServer((req, res) ->
  code = codes.shift()
  assert.equal "number", typeof code
  assert.ok code > 0
  console.error "writing %d response", code
  res.writeHead code, {}
  res.end()
  return
)
server.listen common.PORT, nextRequest
