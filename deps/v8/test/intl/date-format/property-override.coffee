# Copyright 2013 the V8 project authors. All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Google Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Checks for security holes introduced by Object.property overrides.
# For example:
# Object.defineProperty(Array.prototype, 'locale', {
#   set: function(value) {
#     throw new Error('blah');
#   },
#   configurable: true,
#   enumerable: false
# });
#
# would throw in case of (JS) x.locale = 'us' or (C++) x->Set('locale', 'us').
#
# Update both date-format.js and date-format.cc so they have the same list of
# properties.

# First get supported properties.
# Some of the properties are optional, so we request them.
properties = []
options = Intl.DateTimeFormat("en-US",
  weekday: "short"
  era: "short"
  year: "numeric"
  month: "short"
  day: "numeric"
  hour: "numeric"
  minute: "numeric"
  second: "numeric"
  timeZoneName: "short"
).resolvedOptions()
for prop of options
  properties.push prop  if options.hasOwnProperty(prop)
expectedProperties = [
  "calendar"
  "day"
  "era"
  "hour12"
  "hour"
  "locale"
  "minute"
  "month"
  "numberingSystem"
  "second"
  "timeZone"
  "timeZoneName"
  "weekday"
  "year"
]
assertEquals expectedProperties.length, properties.length
properties.forEach (prop) ->
  assertFalse expectedProperties.indexOf(prop) is -1
  return

taintProperties properties
locale = Intl.DateTimeFormat().resolvedOptions().locale
