# Copyright 2012 the V8 project authors. All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Google Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Regression test checking that the sequence of element access in built-in
# array functions is specification conform (i.e. [[HasProperty]] might return
# bogus result after [[Get]] has been called).
CheckSequence = (builtin, callback) ->
  array = [
    1
    2
    3
  ]
  callback_count = 0
  callback_wrapper = ->
    callback_count++
    callback()

  
  # Define getter that will delete itself upon first invocation.
  Object.defineProperty array, "1",
    get: ->
      delete array[1]

      return

    configurable: true

  assertTrue array.hasOwnProperty("1")
  builtin.apply array, [
    callback_wrapper
    "argument"
  ]
  assertFalse array.hasOwnProperty("1")
  assertEquals 3, callback_count
  return
CheckSequence Array::every, ->
  true

CheckSequence Array::filter, ->
  true

CheckSequence Array::forEach, ->
  0

CheckSequence Array::map, ->
  0

CheckSequence Array::reduce, ->
  0

CheckSequence Array::reduceRight, ->
  0

CheckSequence Array::some, ->
  false

