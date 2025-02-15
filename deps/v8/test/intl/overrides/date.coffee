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

# Tests Date.prototype.toLocaleXXXString method overrides.
date = new Date()

# Defaults for toLocaleXXXString
dtfDate = new Intl.DateTimeFormat()
dtfTime = new Intl.DateTimeFormat([],
  hour: "numeric"
  minute: "numeric"
  second: "numeric"
)
dtfAll = new Intl.DateTimeFormat([],
  year: "numeric"
  month: "numeric"
  day: "numeric"
  hour: "numeric"
  minute: "numeric"
  second: "numeric"
)
assertEquals dtfAll.format(date), date.toLocaleString()
assertEquals dtfDate.format(date), date.toLocaleDateString()
assertEquals dtfTime.format(date), date.toLocaleTimeString()

# Specify locale, default options for toLocaleXXXString
locale = ["sr"]
dtfDate = new Intl.DateTimeFormat(locale)
dtfTime = new Intl.DateTimeFormat(locale,
  hour: "numeric"
  minute: "numeric"
  second: "numeric"
)
dtfAll = new Intl.DateTimeFormat(locale,
  year: "numeric"
  month: "numeric"
  day: "numeric"
  hour: "numeric"
  minute: "numeric"
  second: "numeric"
)
assertEquals dtfAll.format(date), date.toLocaleString(locale)
assertEquals dtfDate.format(date), date.toLocaleDateString(locale)
assertEquals dtfTime.format(date), date.toLocaleTimeString(locale)

# Specify locale and options for toLocaleXXXString
locale = ["ko"]
options =
  year: "numeric"
  month: "long"
  day: "numeric"
  hour: "numeric"
  minute: "2-digit"
  second: "numeric"

dtf = new Intl.DateTimeFormat(locale, options)
assertEquals dtf.format(date), date.toLocaleString(locale, options)
assertEquals dtf.format(date), date.toLocaleDateString(locale, options)
assertEquals dtf.format(date), date.toLocaleTimeString(locale, options)
