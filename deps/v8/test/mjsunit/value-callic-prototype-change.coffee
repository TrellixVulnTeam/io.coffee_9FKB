# Copyright 2008 the V8 project authors. All rights reserved.
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

# Test that the inline caches correctly detect that constant
# functions on value prototypes change.
testString = ->
  f = (s, expected) ->
    result = s.toString()
    assertEquals expected, result
    return
  i = 0

  while i < 10
    s = String.fromCharCode(i)
    f s, s
    i++
  String::toString = ->
    "ostehaps"

  i = 0

  while i < 10
    s = String.fromCharCode(i)
    f s, "ostehaps"
    i++
  return
testNumber = ->
  f = (n, expected) ->
    result = n.toString()
    assertEquals expected, result
    return
  Number::toString = ->
    0

  i = 0

  while i < 10
    f i, 0
    i++
  Number::toString = ->
    42

  i = 0

  while i < 10
    f i, 42
    i++
  return
testBoolean = ->
  f = (b, expected) ->
    result = b.toString()
    assertEquals expected, result
    return
  Boolean::toString = ->
    0

  i = 0

  while i < 10
    f (i % 2 is 0), 0
    i++
  Boolean::toString = ->
    42

  i = 0

  while i < 10
    f (i % 2 is 0), 42
    i++
  return
testString()
testNumber()
testBoolean()