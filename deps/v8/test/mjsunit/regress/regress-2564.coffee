# Copyright 2013 the V8 project authors. All rights reserved.
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
o = [
  f0 = ->
    throw new Error()
  f1 = ->
    o[0]()
  f2 = ->
    o[1]()
  f3 = ->
    o[2]()
]
Error.prepareStackTrace = (error, frames) ->
  Error.prepareStackTrace = `undefined` # Prevent recursion.
  try
    assertEquals 5, frames.length
    
    # Don't check the last frame since that's the top-level code.
    i = 0

    while i < frames.length - 1
      assertEquals o[i], frames[i].getFunction()
      assertEquals o, frames[i].getThis()
      
      # Private fields are no longer accessible.
      assertEquals `undefined`, frames[i].receiver
      assertEquals `undefined`, frames[i].fun
      assertEquals `undefined`, frames[i].pos
      i++
    return "success"
  catch e
    return "fail"
  return

try
  o[3]()
catch e
  assertEquals "success", e.stack
o = [
  f0 = ->
    throw new Error()
  f1 = ->
    o[0]()
  f2 = ->
    "use strict"
    o[1]()
  f3 = ->
    o[2]()
]
Error.prepareStackTrace = (error, frames) ->
  Error.prepareStackTrace = `undefined` # Prevent recursion.
  try
    assertEquals 5, frames.length
    i = 0

    while i < 2
      
      # The first two frames are still sloppy mode.
      assertEquals o[i], frames[i].getFunction()
      assertEquals o, frames[i].getThis()
      i++
    i = 2

    while i < frames.length
      
      # The rest are poisoned by the first strict mode function.
      assertEquals `undefined`, frames[i].getFunction()
      assertEquals `undefined`, frames[i].getThis()
      i++
    i = 0

    while i < frames.length - 1
      
      # Function name remains accessible.
      assertEquals "f" + i, frames[i].getFunctionName()
      i++
    return "success"
  catch e
    return e
  return

try
  o[3]()
catch e
  assertEquals "success", e.stack
o = [
  f0 = ->
    "use strict"
    throw new Error()
  f1 = ->
    o[0]()
  f2 = ->
    o[1]()
  f3 = ->
    o[2]()
]
Error.prepareStackTrace = (error, frames) ->
  Error.prepareStackTrace = `undefined` # Prevent recursion.
  try
    assertEquals 5, frames.length
    i = 0

    while i < frames.length
      
      # The rest are poisoned by the first strict mode function.
      assertEquals `undefined`, frames[i].getFunction()
      assertEquals `undefined`, frames[i].getThis()
      # Function name remains accessible.
      assertEquals "f" + i, frames[i].getFunctionName()  if i < frames.length - 1
      i++
    return "success"
  catch e
    return e
  return

try
  o[3]()
catch e
  assertEquals "success", e.stack
