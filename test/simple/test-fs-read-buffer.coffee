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
path = require("path")
Buffer = require("buffer").Buffer
fs = require("fs")
filepath = path.join(common.fixturesDir, "x.txt")
fd = fs.openSync(filepath, "r")
expected = "xyz\n"
bufferAsync = new Buffer(expected.length)
bufferSync = new Buffer(expected.length)
readCalled = 0
fs.read fd, bufferAsync, 0, expected.length, 0, (err, bytesRead) ->
  readCalled++
  assert.equal bytesRead, expected.length
  assert.deepEqual bufferAsync, new Buffer(expected)
  return

r = fs.readSync(fd, bufferSync, 0, expected.length, 0)
assert.deepEqual bufferSync, new Buffer(expected)
assert.equal r, expected.length
process.on "exit", ->
  assert.equal readCalled, 1
  return

