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
util = require("util")
fork = require("child_process").fork
if process.env.NODE_TEST_FORK
  req = http.request(
    headers:
      "Content-Length": "42"

    method: "POST"
    host: "127.0.0.1"
    port: common.PORT
  , process.exit)
  req.write "BAM"
  req.end()
else
  server = http.createServer((req, res) ->
    res.writeHead 200,
      "Content-Length": "42"

    req.pipe res
    req.on "close", ->
      server.close()
      res.end()
      return

    return
  )
  server.listen common.PORT, ->
    fork __filename,
      env: util._extend(process.env,
        NODE_TEST_FORK: "1"
      )

    return

