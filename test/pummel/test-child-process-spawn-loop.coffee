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
doSpawn = (i) ->
  child = spawn("python", [
    "-c"
    "print " + SIZE + " * \"C\""
  ])
  count = 0
  child.stdout.setEncoding "ascii"
  child.stdout.on "data", (chunk) ->
    count += chunk.length
    return

  child.stderr.on "data", (chunk) ->
    console.log "stderr: " + chunk
    return

  child.on "close", ->
    
    # + 1 for \n or + 2 for \r\n on Windows
    assert.equal SIZE + ((if is_windows then 2 else 1)), count
    if i < N
      doSpawn i + 1
    else
      finished = true
    return

  return
common = require("../common")
assert = require("assert")
spawn = require("child_process").spawn
is_windows = process.platform is "win32"
SIZE = 1000 * 1024
N = 40
finished = false
doSpawn 0
process.on "exit", ->
  assert.ok finished
  return

