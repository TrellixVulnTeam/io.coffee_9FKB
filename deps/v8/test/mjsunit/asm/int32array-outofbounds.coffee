# Copyright 2014 the V8 project authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
Module = (stdlib, foreign, heap) ->
  load = (i) ->
    i = i | 0
    i = MEM32[i >> 2] | 0
    i
  store = (i, v) ->
    i = i | 0
    v = v | 0
    MEM32[i >> 2] = v
    return
  "use asm"
  MEM32 = new stdlib.Int32Array(heap)
  load: load
  store: store
m = Module(this, {}, new ArrayBuffer(4))
m.store 0, 0x12345678
i = 1

while i < 64
  m.store i * 4 * 32 * 1024, i
  ++i
assertEquals 0x12345678, m.load(0)
i = 1

while i < 64
  assertEquals 0, m.load(i * 4 * 32 * 1024)
  ++i
