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

# A large function containing a try/catch - this prevent DFG compilation.
doesntDFGCompile = ->
  callMe = ->
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  callMe 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  try
    return 1
  catch e
    return 2
  return
test = (x) ->
  x()
description "This tests that exceptions are thrown correctly."

# warmup the test method
i = 0
while i < 200
  test doesntDFGCompile
  ++i

#
caughtException = false
try
  test()
catch e
  caughtException = true
shouldBe "caughtException", "true"
successfullyParsed = true
