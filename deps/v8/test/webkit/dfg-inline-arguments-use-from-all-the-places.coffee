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
foo = (o, b, c) ->
  [
    foo.arguments
    bar.arguments
  ].concat o.f
fuzz = (a, b) ->
  [
    foo.arguments
    bar.arguments
    getter.arguments
    fuzz.arguments
  ]
getter = ->
  [
    foo.arguments
    bar.arguments
    getter.arguments
  ].concat fuzz(42, 56)
bar = (o, b, c) ->
  [bar.arguments].concat foo(o, b, c)
argsToStr = (args) ->
  return "" + args  if args.length is undefined or args.charAt isnt undefined
  str = "[" + args + ": "
  i = 0

  while i < args.length
    str += ", "  if i
    str += argsToStr(args[i])
    ++i
  str + "]"
description "This tests that inlining preserves basic function.arguments functionality when said functionality is used from inside and outside getters and from inlined code, all at once."
o = {}
o.__defineGetter__ "f", getter
__i = 0

while __i < 200
  text1 = "[[object Arguments]: [object Object], b" + __i + ", c" + __i + "]"
  text2 = "[[object Arguments]: ]"
  text3 = "[[object Arguments]: 42, 56]"
  shouldBe "argsToStr(bar(o, \"b\" + __i, \"c\" + __i))", "\"[[object Arguments],[object Arguments],[object Arguments],[object Arguments],[object Arguments],[object Arguments],[object Arguments],[object Arguments],[object Arguments],[object Arguments]: " + text1 + ", " + text1 + ", " + text1 + ", " + text1 + ", " + text1 + ", " + text2 + ", " + text1 + ", " + text1 + ", " + text2 + ", " + text3 + "]\""
  ++__i
