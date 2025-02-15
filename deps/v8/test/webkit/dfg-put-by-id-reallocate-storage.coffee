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
  o = {}
  o.a = 1
  o.b = 2
  o.c = 3
  o.d = 4
  o.e = 5
  o.f = 6
  o.g = 7
  o.h = 8
  o.i = 9
  o.j = 10
  o.k = 11
  o.l = 12
  o.m = 13
  o.n = 14
  o
description "Tests that a DFG PutById that allocates, and then reallocates, property storage works."
i = 0

while i < 150
  o = foo()
  shouldBe "o.a", "1"
  shouldBe "o.b", "2"
  shouldBe "o.c", "3"
  shouldBe "o.d", "4"
  shouldBe "o.e", "5"
  shouldBe "o.f", "6"
  shouldBe "o.g", "7"
  shouldBe "o.h", "8"
  shouldBe "o.i", "9"
  shouldBe "o.j", "10"
  shouldBe "o.k", "11"
  shouldBe "o.l", "12"
  shouldBe "o.m", "13"
  shouldBe "o.n", "14"
  ++i
