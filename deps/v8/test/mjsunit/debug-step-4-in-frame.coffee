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

# Flags: --expose-debug-as debug
# Get the Debug object exposed from the debug context global object.

# Tests how debugger can step over not necessarily in the top frame.

# Simple 3 functions, that protocol their execution state in global
# variable state.
f = ->
  a = 1978
  state[2] = 0
  while state[2] < 3
    undefined
    state[2]++
  return
g = ->
  state[1] = 0
  while state[1] < 3
    f()
    state[1]++
  return
h = ->
  state = [
    -1
    -1
    -1
  ]
  state[0] = 0
  while state[0] < 3
    g()
    state[0]++
  return
TestCase = (frame_index, step_count, expected_final_state) ->
  listener = (event, exec_state, event_data, data) ->
    print "Here (" + event + "/" + listener_state + "): " + exec_state.frame(0).sourceLineText()
    try
      if event is Debug.DebugEvent.Break
        if listener_state is 0
          Debug.clearBreakPoint bp
          context_frame = undefined
          context_frame = exec_state.frame(frame_index)  if frame_index isnt `undefined`
          exec_state.prepareStep Debug.StepAction.StepNext, step_count, context_frame
          listener_state = 1
        else if listener_state is 1
          state_snapshot = String(state)
          print "State: " + state_snapshot
          Debug.setListener null
          listener_state = 2
    catch e
      listener_exception = e
    return
  print "Test case, parameters " + frame_index + "/" + step_count
  listener_exception = null
  state_snapshot = undefined
  listener_state = undefined
  bp = undefined
  
  # Add the debug event listener.
  listener_state = 0
  Debug.setListener listener
  bp = Debug.setBreakPoint(f, 1)
  h()
  Debug.setListener null
  if listener_exception isnt null
    print "Exception caught: " + listener_exception
    assertUnreachable()
  assertEquals expected_final_state, state_snapshot
  return
Debug = debug.Debug
state = undefined

# Warm-up -- make sure all is compiled and ready for breakpoint.
h()

# Stepping in the default (top) frame.
TestCase `undefined`, 0, "0,0,-1"
TestCase `undefined`, 1, "0,0,-1"
TestCase `undefined`, 2, "0,0,0"
TestCase `undefined`, 5, "0,0,1"
TestCase `undefined`, 8, "0,0,3"

# Stepping in the frame #0 (should be exactly the same as above).
TestCase 0, 0, "0,0,-1"
TestCase 0, 1, "0,0,-1"
TestCase 0, 2, "0,0,0"
TestCase 0, 5, "0,0,1"
TestCase 0, 8, "0,0,3"

# Stepping in the frame #1.
TestCase 1, 0, "0,0,3"
TestCase 1, 3, "0,1,3"
TestCase 1, 7, "0,3,3"

# Stepping in the frame #2.
TestCase 2, 3, "1,3,3"
TestCase 2, 7, "3,3,3"
