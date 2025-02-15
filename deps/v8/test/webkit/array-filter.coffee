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
passUndefined = (element, index, array) ->
  typeof element is "undefined"
passEven = (a) ->
  not (a & 1)
passAfter5 = (element, index) ->
  index >= 5
toObject = (array) ->
  result = {}
  result.length = array.length
  for i of array
    result[i] = array[i]
  result.filter = Array::filter
  result
reverseInsertionOrder = (array) ->
  obj = toObject(array)
  props = []
  for i of obj
    props.push i
  result = {}
  i = props.length - 1

  while i >= 0
    result[props[i]] = obj[props[i]]
    i--
  result.filter = Array::filter
  result
filterLog = (f) ->
  (i, j) ->
    try
      debug [
        i
        j
        arguments[2].toString().substring(0, 20)
      ].toString()
      return f.apply(this, arguments)
    catch e
      console.error e
    return
description "Tests for Array.prototype.filter"
sparseArrayLength = 10100
mixPartialAndFast = new Array(sparseArrayLength)
mixPartialAndFast[sparseArrayLength - 1] = sparseArrayLength - 1
i = 0

while i < 10
  mixPartialAndFast[i] = i
  i++
shouldBe "[undefined].filter(passUndefined)", "[undefined]"
shouldBe "(new Array(20)).filter(passUndefined)", "[]"
shouldBe "[0,1,2,3,4,5,6,7,8,9].filter(passEven)", "[0,2,4,6,8]"
shouldBe "[0,1,2,3,4,5,6,7,8,9].filter(passAfter5)", "[5,6,7,8,9]"
shouldBe "mixPartialAndFast.filter(passAfter5)", "[5,6,7,8,9,sparseArrayLength-1]"

# Generic Object
shouldBe "toObject([undefined]).filter(passUndefined)", "[undefined]"
shouldBe "toObject(new Array(20)).filter(passUndefined)", "[]"
shouldBe "toObject([0,1,2,3,4,5,6,7,8,9]).filter(passEven)", "[0,2,4,6,8]"
shouldBe "toObject([0,1,2,3,4,5,6,7,8,9]).filter(passAfter5)", "[5,6,7,8,9]"
shouldBe "toObject(mixPartialAndFast).filter(passAfter5)", "[5,6,7,8,9,sparseArrayLength-1]"

# Reversed generic Object
shouldBe "reverseInsertionOrder([undefined]).filter(passUndefined)", "[undefined]"
shouldBe "reverseInsertionOrder(new Array(20)).filter(passUndefined)", "[]"
shouldBe "reverseInsertionOrder([0,1,2,3,4,5,6,7,8,9]).filter(passEven)", "[0,2,4,6,8]"
shouldBe "reverseInsertionOrder([0,1,2,3,4,5,6,7,8,9]).filter(passAfter5)", "[5,6,7,8,9]"
shouldBe "reverseInsertionOrder(mixPartialAndFast).filter(passAfter5)", "[5,6,7,8,9,sparseArrayLength-1]"

# Log evaluation order
shouldBe "reverseInsertionOrder([undefined]).filter(filterLog(passUndefined))", "[undefined]"
shouldBe "reverseInsertionOrder(new Array(20)).filter(filterLog(passUndefined))", "[]"
shouldBe "reverseInsertionOrder([0,1,2,3,4]).filter(filterLog(passEven))", "[0,2,4]"
shouldBe "reverseInsertionOrder(mixPartialAndFast).filter(filterLog(passAfter5))", "[5,6,7,8,9,sparseArrayLength-1]"
shouldBe "([undefined]).filter(filterLog(passUndefined))", "[undefined]"
shouldBe "(new Array(20)).filter(filterLog(passUndefined))", "[]"
shouldBe "([0,1,2,3,4]).filter(filterLog(passEven))", "[0,2,4]"
shouldBe "(mixPartialAndFast).filter(filterLog(passAfter5))", "[5,6,7,8,9,sparseArrayLength-1]"
shouldBe "[1,2,3].filter(function(i,j,k,l,m){ return m=!m; })", "[1,2,3]"
