# Copyright 2014 the V8 project authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Flags: --stack-size=100 --turbo-deoptimization
f = (a, x) ->
  a.length = x
  f a, x + 1
  return
a = []
Object.observe a, ->

assertThrows (->
  f a, 1
  return
), RangeError
