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
fail = ->
  assert 0 # `node --debug-brk script.js` should not quit
  return
test = (arg) ->
  child = spawn(process.execPath, [
    arg
    script
  ])
  child.on "exit", fail
  
  # give node time to start up the debugger
  setTimeout (->
    child.removeListener "exit", fail
    child.kill()
    return
  ), 2000
  process.on "exit", ->
    assert child.killed
    return

  return
common = require("../common")
assert = require("assert")
spawn = require("child_process").spawn
script = common.fixturesDir + "/empty.js"
test "--debug-brk"
test "--debug-brk=5959"
