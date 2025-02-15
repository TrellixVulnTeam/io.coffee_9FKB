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
require "../common"
assert = require("assert")
exec = require("child_process").exec
os = require("os")
success_count = 0
str = "hello"

# default encoding
child = exec("echo " + str, (err, stdout, stderr) ->
  assert.ok "string", typeof (stdout), "Expected stdout to be a string"
  assert.ok "string", typeof (stderr), "Expected stderr to be a string"
  assert.equal str + os.EOL, stdout
  success_count++
  return
)

# no encoding (Buffers expected)
child = exec("echo " + str,
  encoding: null
, (err, stdout, stderr) ->
  assert.ok stdout instanceof Buffer, "Expected stdout to be a Buffer"
  assert.ok stderr instanceof Buffer, "Expected stderr to be a Buffer"
  assert.equal str + os.EOL, stdout.toString()
  success_count++
  return
)
process.on "exit", ->
  assert.equal 2, success_count
  return

