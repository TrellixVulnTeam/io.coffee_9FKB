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
foo = ->
  bar.arguments
fuzz = ->
  baz.arguments
bar = (a, b, c) ->
  foo a, b, c
baz = (a, b, c) ->
  array1 = bar(a, b, c)
  array2 = fuzz(a, b, c)
  result = []
  i = 0

  while i < array1.length
    result.push array1[i]
    ++i
  i = 0

  while i < array2.length
    result.push array2[i]
    ++i
  result
description "This tests that inlining preserves basic function.arguments functionality when said functionality is used from outside of the code where inlining actually happened."
__i = 0

while __i < 200
  shouldBe "\"\" + baz(\"a\" + __i, \"b\" + (__i + 1), \"c\" + (__i + 2))", "\"a" + __i + ",b" + (__i + 1) + ",c" + (__i + 2) + ",a" + __i + ",b" + (__i + 1) + ",c" + (__i + 2) + "\""
  ++__i
successfullyParsed = true
