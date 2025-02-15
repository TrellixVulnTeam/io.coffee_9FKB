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
constants = require("constants")
fs = require("fs")
O_APPEND = constants.O_APPEND or 0
O_CREAT = constants.O_CREAT or 0
O_DIRECTORY = constants.O_DIRECTORY or 0
O_EXCL = constants.O_EXCL or 0
O_NOCTTY = constants.O_NOCTTY or 0
O_NOFOLLOW = constants.O_NOFOLLOW or 0
O_RDONLY = constants.O_RDONLY or 0
O_RDWR = constants.O_RDWR or 0
O_SYMLINK = constants.O_SYMLINK or 0
O_SYNC = constants.O_SYNC or 0
O_TRUNC = constants.O_TRUNC or 0
O_WRONLY = constants.O_WRONLY or 0
assert.equal fs._stringToFlags("r"), O_RDONLY
assert.equal fs._stringToFlags("r+"), O_RDWR
assert.equal fs._stringToFlags("w"), O_TRUNC | O_CREAT | O_WRONLY
assert.equal fs._stringToFlags("w+"), O_TRUNC | O_CREAT | O_RDWR
assert.equal fs._stringToFlags("a"), O_APPEND | O_CREAT | O_WRONLY
assert.equal fs._stringToFlags("a+"), O_APPEND | O_CREAT | O_RDWR
assert.equal fs._stringToFlags("wx"), O_TRUNC | O_CREAT | O_WRONLY | O_EXCL
assert.equal fs._stringToFlags("xw"), O_TRUNC | O_CREAT | O_WRONLY | O_EXCL
assert.equal fs._stringToFlags("wx+"), O_TRUNC | O_CREAT | O_RDWR | O_EXCL
assert.equal fs._stringToFlags("xw+"), O_TRUNC | O_CREAT | O_RDWR | O_EXCL
assert.equal fs._stringToFlags("ax"), O_APPEND | O_CREAT | O_WRONLY | O_EXCL
assert.equal fs._stringToFlags("xa"), O_APPEND | O_CREAT | O_WRONLY | O_EXCL
assert.equal fs._stringToFlags("ax+"), O_APPEND | O_CREAT | O_RDWR | O_EXCL
assert.equal fs._stringToFlags("xa+"), O_APPEND | O_CREAT | O_RDWR | O_EXCL
("+ +a +r +w rw wa war raw r++ a++ w++" + "x +x x+ rx rx+ wxx wax xwx xxx").split(" ").forEach (flags) ->
  assert.throws ->
    fs._stringToFlags flags
    return

  return

