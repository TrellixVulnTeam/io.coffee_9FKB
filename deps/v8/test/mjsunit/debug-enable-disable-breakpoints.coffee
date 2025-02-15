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

# Simple debug event handler which just counts the number of break points hit.
listener = (event, exec_state, event_data, data) ->
  break_point_hit_count++  if event is Debug.DebugEvent.Break
  return

# Add the debug event listener.

# Test function.
f = ->
  a = 1
  b = 2
  return
Debug = debug.Debug
break_point_hit_count = undefined
Debug.setListener listener

# This tests enabeling and disabling of break points including the case
# with several break points in the same location.
break_point_hit_count = 0

# Set a breakpoint in f.
bp1 = Debug.setBreakPoint(f)
f()
assertEquals 1, break_point_hit_count

# Disable the breakpoint.
Debug.disableBreakPoint bp1
f()
assertEquals 1, break_point_hit_count

# Enable the breakpoint.
Debug.enableBreakPoint bp1
f()
assertEquals 2, break_point_hit_count

# Set another breakpoint in f at the same place.
bp2 = Debug.setBreakPoint(f)
f()
assertEquals 3, break_point_hit_count

# Disable the second breakpoint.
Debug.disableBreakPoint bp2
f()
assertEquals 4, break_point_hit_count

# Disable the first breakpoint.
Debug.disableBreakPoint bp1
f()
assertEquals 4, break_point_hit_count

# Enable both breakpoints.
Debug.enableBreakPoint bp1
Debug.enableBreakPoint bp2
f()
assertEquals 5, break_point_hit_count

# Disable the first breakpoint.
Debug.disableBreakPoint bp1
f()
assertEquals 6, break_point_hit_count

# Deactivate all breakpoints.
Debug.debuggerFlags().breakPointsActive.setValue false
f()
assertEquals 6, break_point_hit_count

# Enable the first breakpoint.
Debug.enableBreakPoint bp1
f()
assertEquals 6, break_point_hit_count

# Activate all breakpoints.
Debug.debuggerFlags().breakPointsActive.setValue true
f()
assertEquals 7, break_point_hit_count
