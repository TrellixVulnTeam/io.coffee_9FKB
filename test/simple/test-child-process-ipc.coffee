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
spawn = require("child_process").spawn
path = require("path")
sub = path.join(common.fixturesDir, "echo.js")
gotHelloWorld = false
gotEcho = false
child = spawn(process.argv[0], [sub])
child.stderr.on "data", (data) ->
  console.log "parent stderr: " + data
  return

child.stdout.setEncoding "utf8"
child.stdout.on "data", (data) ->
  console.log "child said: " + JSON.stringify(data)
  unless gotHelloWorld
    console.error "testing for hello world"
    assert.equal "hello world\r\n", data
    gotHelloWorld = true
    console.error "writing echo me"
    child.stdin.write "echo me\r\n"
  else
    console.error "testing for echo me"
    assert.equal "echo me\r\n", data
    gotEcho = true
    child.stdin.end()
  return

child.stdout.on "end", (data) ->
  console.log "child end"
  return

process.on "exit", ->
  assert.ok gotHelloWorld
  assert.ok gotEcho
  return

