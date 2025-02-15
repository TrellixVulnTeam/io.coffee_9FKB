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
description "This test case tests the Date constructor. " + "In particular, it tests many cases of creating a Date from another Date " + "and creating a Date from an object that has both valueOf and toString functions."
object = new Object
object.valueOf = ->
  1111

object.toString = ->
  "2222"

shouldBe "isNaN(new Date(\"\"))", "true"
timeZoneOffset = Date.parse("Dec 25 1995") - Date.parse("Dec 25 1995 GMT")
shouldBe "new Date(1111).getTime()", "1111"
shouldBe "new Date(object).getTime()", "1111"
shouldBe "new Date(new Date(1111)).getTime()", "1111"
shouldBe "new Date(new Date(1111).toString()).getTime()", "1000"
shouldBe "new Date(1111, 1).getTime() - timeZoneOffset", "-27104803200000"
shouldBe "new Date(1111, 1, 1).getTime() - timeZoneOffset", "-27104803200000"
shouldBe "new Date(1111, 1, 1, 1).getTime() - timeZoneOffset", "-27104799600000"
shouldBe "new Date(1111, 1, 1, 1, 1).getTime() - timeZoneOffset", "-27104799540000"
shouldBe "new Date(1111, 1, 1, 1, 1, 1).getTime() - timeZoneOffset", "-27104799539000"
shouldBe "new Date(1111, 1, 1, 1, 1, 1, 1).getTime() - timeZoneOffset", "-27104799538999"
shouldBe "new Date(1111, 1, 1, 1, 1, 1, 1, 1).getTime() - timeZoneOffset", "-27104799538999"
shouldBe "new Date(1111, 1, 1, 1, 1, 1, 1, 1, 1).getTime() - timeZoneOffset", "-27104799538999"
shouldBe "new Date(1111, 1, 1, 1, 1, 1, 1, 1, 1).getTime() - timeZoneOffset", "-27104799538999"
shouldBe "new Date(new Date(1111, 1)).getTime() - timeZoneOffset", "-27104803200000"
shouldBe "new Date(new Date(1111, 1, 1)).getTime() - timeZoneOffset", "-27104803200000"
shouldBe "new Date(new Date(1111, 1, 1, 1)).getTime() - timeZoneOffset", "-27104799600000"
shouldBe "new Date(new Date(1111, 1, 1, 1, 1, 1)).getTime() - timeZoneOffset", "-27104799539000"
shouldBe "new Date(new Date(1111, 1, 1, 1, 1, 1, 1)).getTime() - timeZoneOffset", "-27104799538999"
shouldBe "new Date(new Date(1111, 1, 1, 1, 1, 1, 1, 1)).getTime() - timeZoneOffset", "-27104799538999"
shouldBe "new Date(new Date(1111, 1, 1, 1, 1, 1, 1, 1, 1)).getTime() - timeZoneOffset", "-27104799538999"
shouldBe "Number(new Date(new Date(Infinity, 1, 1, 1, 1, 1, 1, 1, 1)).getTime() - timeZoneOffset)", "Number.NaN"
shouldBe "Number(new Date(new Date(1, Infinity, 1, 1, 1, 1, 1, 1, 1)).getTime() - timeZoneOffset)", "Number.NaN"
shouldBe "Number(new Date(new Date(1, 1, Infinity, 1, 1, 1, 1, 1, 1)).getTime() - timeZoneOffset)", "Number.NaN"
shouldBe "Number(new Date(new Date(1, 1, 1, Infinity, 1, 1, 1, 1, 1)).getTime() - timeZoneOffset)", "Number.NaN"
shouldBe "Number(new Date(new Date(1, 1, 1, 1, Infinity, 1, 1, 1, 1)).getTime() - timeZoneOffset)", "Number.NaN"
shouldBe "Number(new Date(new Date(1, 1, 1, 1, 1, Infinity, 1, 1, 1)).getTime() - timeZoneOffset)", "Number.NaN"
shouldBe "Number(new Date(new Date(1, 1, 1, 1, 1, 1, Infinity, 1, 1)).getTime() - timeZoneOffset)", "Number.NaN"
shouldBe "Number(new Date(new Date(1, 1, 1, 1, 1, 1, 1, 1, Infinity)).getTime() - timeZoneOffset)", "-2174770738999"

# In Firefox, the results of the following tests are timezone-dependent, which likely implies that the implementation is not quite correct.
# Our results are even worse, though, as the dates are clipped: (new Date(1111, 1201).getTime()) == (new Date(1111, 601).getTime())
# shouldBe('new Date(1111, 1111, 1111, 1111, 1111, 1111, 1111, 1111).getTime() - timeZoneOffset', '-24085894227889');
# shouldBe('new Date(new Date(1111, 1111, 1111, 1111, 1111, 1111, 1111, 1111)).getTime() - timeZoneOffset', '-24085894227889');

# Regression test for Bug 26978 (https://bugs.webkit.org/show_bug.cgi?id=26978)
testStr = ""
year = valueOf: ->
  testStr += 1
  2007

month = valueOf: ->
  testStr += 2
  2

date = valueOf: ->
  testStr += 3
  4

hours = valueOf: ->
  testStr += 4
  13

minutes = valueOf: ->
  testStr += 5
  50

seconds = valueOf: ->
  testStr += 6
  0

ms = valueOf: ->
  testStr += 7
  999

testStr = ""
new Date(year, month, date, hours, minutes, seconds, ms)
shouldBe "testStr", "\"1234567\""
testStr = ""
Date.UTC year, month, date, hours, minutes, seconds, ms
shouldBe "testStr", "\"1234567\""
