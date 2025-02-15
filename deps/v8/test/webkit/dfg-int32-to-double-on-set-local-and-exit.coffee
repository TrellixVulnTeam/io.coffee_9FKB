# Copyright 2013 the V8 project authors. All rights reserved.
# Copyright (C) 2005, 2006, 2007, 2008, 2009 Apple Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1.  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# 2.  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
checkpoint = (text) ->
  debug "Checkpoint: " + text
  counter++
  return
func1 = ->
  checkpoint "a"
  a = Date.now() + Date.now() + Date.now() + Date.now() + Date.now() + Date.now()
  checkpoint "b"
  return
func2 = ->
  checkpoint "c"
  Date.now() + Date.now() + Date.now() + Date.now() + Date.now() + Date.now()
func3 = (s) ->
  checkpoint "1"
  s = func1() # The bug is that this function will be called twice, if our Int32ToDouble hoisting does a backward speculation.
  checkpoint "2"
  s = func2()
  checkpoint "3"
  s
test = ->
  func3 1
description "Tests that an Int32ToDouble placed on a SetLocal does a forward exit."
counter = 0
i = 0

while i < 200
  test()
  i++
shouldBe "counter", "1200"
