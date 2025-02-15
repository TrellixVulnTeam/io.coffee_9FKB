# Copyright Joyent, Inc. and other Node contributors.

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the
# following conditions:

# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
# USE OR OTHER DEALINGS IN THE SOFTWARE.
assert = require("assert")
common = require("../common")
if process.platform is "win32"
  console.log "skipping test on windows"
  process.exit 0
exec = require("child_process").exec
cmdline = "ulimit -c 0; " + process.execPath
cmdline += " --max-old-space-size=4 --max-semi-space-size=1"
cmdline += " -e \"a = []; for (i = 0; i < 1e9; i++) { a.push({}) }\""
exec cmdline, (err, stdout, stderr) ->
  unless err
    console.log stdout
    console.log stderr
    assert false, "this test should fail"
    return
  if err.code isnt 134 and err.signal isnt "SIGABRT"
    console.log stdout
    console.log stderr
    console.log err
    assert false, err
  return

