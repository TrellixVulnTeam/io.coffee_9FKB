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

# test convenience methods with and without options supplied
common = require("../common.js")
assert = require("assert")
zlib = require("zlib")
hadRun = 0
expect = "blahblahblahblahblahblah"
opts =
  level: 9
  chunkSize: 1024

[
  [
    "gzip"
    "gunzip"
  ]
  [
    "gzip"
    "unzip"
  ]
  [
    "deflate"
    "inflate"
  ]
  [
    "deflateRaw"
    "inflateRaw"
  ]
].forEach (method) ->
  zlib[method[0]] expect, opts, (err, result) ->
    zlib[method[1]] result, opts, (err, result) ->
      assert.equal result, expect, "Should get original string after " + method[0] + "/" + method[1] + " with options."
      hadRun++
      return

    return

  zlib[method[0]] expect, (err, result) ->
    zlib[method[1]] result, (err, result) ->
      assert.equal result, expect, "Should get original string after " + method[0] + "/" + method[1] + " without options."
      hadRun++
      return

    return

  result = zlib[method[0] + "Sync"](expect, opts)
  result = zlib[method[1] + "Sync"](result, opts)
  assert.equal result, expect, "Should get original string after " + method[0] + "/" + method[1] + " with options."
  hadRun++
  result = zlib[method[0] + "Sync"](expect)
  result = zlib[method[1] + "Sync"](result)
  assert.equal result, expect, "Should get original string after " + method[0] + "/" + method[1] + " without options."
  hadRun++
  return

process.on "exit", ->
  assert.equal hadRun, 16, "expect 16 compressions"
  return

