# Copyright 2014 the V8 project authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Flags: --harmony-tostring
testMathToString = ->
  assertEquals "[object Math]", "" + Math
  assertEquals "Math", Math[Symbol.toStringTag]
  desc = Object.getOwnPropertyDescriptor(Math, Symbol.toStringTag)
  assertTrue desc.configurable
  assertFalse desc.writable
  assertEquals "Math", desc.value
  return
testMathToString()
