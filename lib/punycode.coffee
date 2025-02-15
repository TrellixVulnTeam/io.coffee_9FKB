#! https://mths.be/punycode v1.3.2 by @mathias 
((root) ->
  
  ###*
  Detect free variables
  ###
  
  ###*
  The `punycode` object.
  @name punycode
  @type Object
  ###
  
  ###*
  Highest positive signed 32-bit float value
  ###
  # aka. 0x7FFFFFFF or 2^31-1
  
  ###*
  Bootstring parameters
  ###
  # 0x80
  # '\x2D'
  
  ###*
  Regular expressions
  ###
  # unprintable ASCII chars + non-ASCII chars
  # RFC 3490 separators
  
  ###*
  Error messages
  ###
  
  ###*
  Convenience shortcuts
  ###
  
  ###*
  Temporary variable
  ###
  
  #--------------------------------------------------------------------------
  
  ###*
  A generic error utility function.
  @private
  @param {String} type The error type.
  @returns {Error} Throws a `RangeError` with the applicable error message.
  ###
  error = (type) ->
    throw RangeError(errors[type])return
  
  ###*
  A generic `Array#map` utility function.
  @private
  @param {Array} array The array to iterate over.
  @param {Function} callback The function that gets called for every array
  item.
  @returns {Array} A new array of values returned by the callback function.
  ###
  map = (array, fn) ->
    length = array.length
    result = []
    result[length] = fn(array[length])  while length--
    result
  
  ###*
  A simple `Array#map`-like wrapper to work with domain name strings or email
  addresses.
  @private
  @param {String} domain The domain name or email address.
  @param {Function} callback The function that gets called for every
  character.
  @returns {Array} A new string of characters returned by the callback
  function.
  ###
  mapDomain = (string, fn) ->
    parts = string.split("@")
    result = ""
    if parts.length > 1
      
      # In email addresses, only the domain name should be punycoded. Leave
      # the local part (i.e. everything up to `@`) intact.
      result = parts[0] + "@"
      string = parts[1]
    
    # Avoid `split(regex)` for IE8 compatibility. See #17.
    string = string.replace(regexSeparators, ".")
    labels = string.split(".")
    encoded = map(labels, fn).join(".")
    result + encoded
  
  ###*
  Creates an array containing the numeric code points of each Unicode
  character in the string. While JavaScript uses UCS-2 internally,
  this function will convert a pair of surrogate halves (each of which
  UCS-2 exposes as separate characters) into a single code point,
  matching UTF-16.
  @see `punycode.ucs2.encode`
  @see <https://mathiasbynens.be/notes/javascript-encoding>
  @memberOf punycode.ucs2
  @name decode
  @param {String} string The Unicode input string (UCS-2).
  @returns {Array} The new array of code points.
  ###
  ucs2decode = (string) ->
    output = []
    counter = 0
    length = string.length
    value = undefined
    extra = undefined
    while counter < length
      value = string.charCodeAt(counter++)
      if value >= 0xd800 and value <= 0xdbff and counter < length
        
        # high surrogate, and there is a next character
        extra = string.charCodeAt(counter++)
        if (extra & 0xfc00) is 0xdc00 # low surrogate
          output.push ((value & 0x3ff) << 10) + (extra & 0x3ff) + 0x10000
        else
          
          # unmatched surrogate; only append this code unit, in case the next
          # code unit is the high surrogate of a surrogate pair
          output.push value
          counter--
      else
        output.push value
    output
  
  ###*
  Creates a string based on an array of numeric code points.
  @see `punycode.ucs2.decode`
  @memberOf punycode.ucs2
  @name encode
  @param {Array} codePoints The array of numeric code points.
  @returns {String} The new Unicode string (UCS-2).
  ###
  ucs2encode = (array) ->
    map(array, (value) ->
      output = ""
      if value > 0xffff
        value -= 0x10000
        output += stringFromCharCode(value >>> 10 & 0x3ff | 0xd800)
        value = 0xdc00 | value & 0x3ff
      output += stringFromCharCode(value)
      output
    ).join ""
  
  ###*
  Converts a basic code point into a digit/integer.
  @see `digitToBasic()`
  @private
  @param {Number} codePoint The basic numeric code point value.
  @returns {Number} The numeric value of a basic code point (for use in
  representing integers) in the range `0` to `base - 1`, or `base` if
  the code point does not represent a value.
  ###
  basicToDigit = (codePoint) ->
    return codePoint - 22  if codePoint - 48 < 10
    return codePoint - 65  if codePoint - 65 < 26
    return codePoint - 97  if codePoint - 97 < 26
    base
  
  ###*
  Converts a digit/integer into a basic code point.
  @see `basicToDigit()`
  @private
  @param {Number} digit The numeric value of a basic code point.
  @returns {Number} The basic code point whose value (when used for
  representing integers) is `digit`, which needs to be in the range
  `0` to `base - 1`. If `flag` is non-zero, the uppercase form is
  used; else, the lowercase form is used. The behavior is undefined
  if `flag` is non-zero and `digit` has no uppercase form.
  ###
  digitToBasic = (digit, flag) ->
    
    #  0..25 map to ASCII a..z or A..Z
    # 26..35 map to ASCII 0..9
    digit + 22 + 75 * (digit < 26) - ((flag isnt 0) << 5)
  
  ###*
  Bias adaptation function as per section 3.4 of RFC 3492.
  https://tools.ietf.org/html/rfc3492#section-3.4
  @private
  ###
  adapt = (delta, numPoints, firstTime) ->
    k = 0
    delta = (if firstTime then floor(delta / damp) else delta >> 1)
    delta += floor(delta / numPoints)
    while delta > baseMinusTMin * tMax >> 1 # no initialization
      delta = floor(delta / baseMinusTMin)
      k += base
    floor k + (baseMinusTMin + 1) * delta / (delta + skew)
  
  ###*
  Converts a Punycode string of ASCII-only symbols to a string of Unicode
  symbols.
  @memberOf punycode
  @param {String} input The Punycode string of ASCII-only symbols.
  @returns {String} The resulting string of Unicode symbols.
  ###
  decode = (input) ->
    
    # Don't use UCS-2
    output = []
    inputLength = input.length
    out = undefined
    i = 0
    n = initialN
    bias = initialBias
    basic = undefined
    j = undefined
    index = undefined
    oldi = undefined
    w = undefined
    k = undefined
    digit = undefined
    t = undefined
    baseMinusT = undefined
    
    ###*
    Cached calculation results
    ###
    
    # Handle the basic code points: let `basic` be the number of input code
    # points before the last delimiter, or `0` if there is none, then copy
    # the first basic code points to the output.
    basic = input.lastIndexOf(delimiter)
    basic = 0  if basic < 0
    j = 0
    while j < basic
      
      # if it's not a basic code point
      error "not-basic"  if input.charCodeAt(j) >= 0x80
      output.push input.charCodeAt(j)
      ++j
    
    # Main decoding loop: start just after the last delimiter if any basic code
    # points were copied; start at the beginning otherwise.
    index = (if basic > 0 then basic + 1 else 0) # no final expression
    while index < inputLength
      
      # `index` is the index of the next character to be consumed.
      # Decode a generalized variable-length integer into `delta`,
      # which gets added to `i`. The overflow checking is easier
      # if we increase `i` as we go, then subtract off its starting
      # value at the end to obtain `delta`.
      oldi = i # no condition
      w = 1
      k = base

      loop
        error "invalid-input"  if index >= inputLength
        digit = basicToDigit(input.charCodeAt(index++))
        error "overflow"  if digit >= base or digit > floor((maxInt - i) / w)
        i += digit * w
        t = (if k <= bias then tMin else ((if k >= bias + tMax then tMax else k - bias)))
        break  if digit < t
        baseMinusT = base - t
        error "overflow"  if w > floor(maxInt / baseMinusT)
        w *= baseMinusT
        k += base
      out = output.length + 1
      bias = adapt(i - oldi, out, oldi is 0)
      
      # `i` was supposed to wrap around from `out` to `0`,
      # incrementing `n` each time, so we'll fix that now:
      error "overflow"  if floor(i / out) > maxInt - n
      n += floor(i / out)
      i %= out
      
      # Insert `n` at position `i` of the output
      output.splice i++, 0, n
    ucs2encode output
  
  ###*
  Converts a string of Unicode symbols (e.g. a domain name label) to a
  Punycode string of ASCII-only symbols.
  @memberOf punycode
  @param {String} input The string of Unicode symbols.
  @returns {String} The resulting Punycode string of ASCII-only symbols.
  ###
  encode = (input) ->
    n = undefined
    delta = undefined
    handledCPCount = undefined
    basicLength = undefined
    bias = undefined
    j = undefined
    m = undefined
    q = undefined
    k = undefined
    t = undefined
    currentValue = undefined
    output = []
    inputLength = undefined
    handledCPCountPlusOne = undefined
    baseMinusT = undefined
    qMinusT = undefined
    
    ###*
    `inputLength` will hold the number of code points in `input`.
    ###
    
    ###*
    Cached calculation results
    ###
    
    # Convert the input in UCS-2 to Unicode
    input = ucs2decode(input)
    
    # Cache the length
    inputLength = input.length
    
    # Initialize the state
    n = initialN
    delta = 0
    bias = initialBias
    
    # Handle the basic code points
    j = 0
    while j < inputLength
      currentValue = input[j]
      output.push stringFromCharCode(currentValue)  if currentValue < 0x80
      ++j
    handledCPCount = basicLength = output.length
    
    # `handledCPCount` is the number of code points that have been handled;
    # `basicLength` is the number of basic code points.
    
    # Finish the basic string - if it is not empty - with a delimiter
    output.push delimiter  if basicLength
    
    # Main encoding loop:
    while handledCPCount < inputLength
      
      # All non-basic code points < n have been handled already. Find the next
      # larger one:
      m = maxInt
      j = 0

      while j < inputLength
        currentValue = input[j]
        m = currentValue  if currentValue >= n and currentValue < m
        ++j
      
      # Increase `delta` enough to advance the decoder's <n,i> state to <m,0>,
      # but guard against overflow
      handledCPCountPlusOne = handledCPCount + 1
      error "overflow"  if m - n > floor((maxInt - delta) / handledCPCountPlusOne)
      delta += (m - n) * handledCPCountPlusOne
      n = m
      j = 0
      while j < inputLength
        currentValue = input[j]
        error "overflow"  if currentValue < n and ++delta > maxInt
        if currentValue is n
          
          # Represent delta as a generalized variable-length integer
          q = delta # no condition
          k = base

          loop
            t = (if k <= bias then tMin else ((if k >= bias + tMax then tMax else k - bias)))
            break  if q < t
            qMinusT = q - t
            baseMinusT = base - t
            output.push stringFromCharCode(digitToBasic(t + qMinusT % baseMinusT, 0))
            q = floor(qMinusT / baseMinusT)
            k += base
          output.push stringFromCharCode(digitToBasic(q, 0))
          bias = adapt(delta, handledCPCountPlusOne, handledCPCount is basicLength)
          delta = 0
          ++handledCPCount
        ++j
      ++delta
      ++n
    output.join ""
  
  ###*
  Converts a Punycode string representing a domain name or an email address
  to Unicode. Only the Punycoded parts of the input will be converted, i.e.
  it doesn't matter if you call it on a string that has already been
  converted to Unicode.
  @memberOf punycode
  @param {String} input The Punycoded domain name or email address to
  convert to Unicode.
  @returns {String} The Unicode representation of the given Punycode
  string.
  ###
  toUnicode = (input) ->
    mapDomain input, (string) ->
      (if regexPunycode.test(string) then decode(string.slice(4).toLowerCase()) else string)

  
  ###*
  Converts a Unicode string representing a domain name or an email address to
  Punycode. Only the non-ASCII parts of the domain name will be converted,
  i.e. it doesn't matter if you call it with a domain that's already in
  ASCII.
  @memberOf punycode
  @param {String} input The domain name or email address to convert, as a
  Unicode string.
  @returns {String} The Punycode representation of the given domain name or
  email address.
  ###
  toASCII = (input) ->
    mapDomain input, (string) ->
      (if regexNonASCII.test(string) then "xn--" + encode(string) else string)

  freeExports = typeof exports is "object" and exports and not exports.nodeType and exports
  freeModule = typeof module is "object" and module and not module.nodeType and module
  freeGlobal = typeof global is "object" and global
  root = freeGlobal  if freeGlobal.global is freeGlobal or freeGlobal.window is freeGlobal or freeGlobal.self is freeGlobal
  punycode = undefined
  maxInt = 2147483647
  base = 36
  tMin = 1
  tMax = 26
  skew = 38
  damp = 700
  initialBias = 72
  initialN = 128
  delimiter = "-"
  regexPunycode = /^xn--/
  regexNonASCII = /[^\x20-\x7E]/
  regexSeparators = /[\x2E\u3002\uFF0E\uFF61]/g
  errors =
    overflow: "Overflow: input needs wider integers to process"
    "not-basic": "Illegal input >= 0x80 (not a basic code point)"
    "invalid-input": "Invalid input"

  baseMinusTMin = base - tMin
  floor = Math.floor
  stringFromCharCode = String.fromCharCode
  key = undefined
  
  #--------------------------------------------------------------------------
  
  ###*
  Define the public API
  ###
  punycode =
    
    ###*
    A string representing the current Punycode.js version number.
    @memberOf punycode
    @type String
    ###
    version: "1.3.2"
    
    ###*
    An object of methods to convert from JavaScript's internal character
    representation (UCS-2) to Unicode code points, and back.
    @see <https://mathiasbynens.be/notes/javascript-encoding>
    @memberOf punycode
    @type Object
    ###
    ucs2:
      decode: ucs2decode
      encode: ucs2encode

    decode: decode
    encode: encode
    toASCII: toASCII
    toUnicode: toUnicode

  
  ###*
  Expose `punycode`
  ###
  
  # Some AMD build optimizers, like r.js, check for specific condition patterns
  # like the following:
  if typeof define is "function" and typeof define.amd is "object" and define.amd
    define "punycode", ->
      punycode

  else if freeExports and freeModule
    if module.exports is freeExports # in Node.js or RingoJS v0.8.0+
      freeModule.exports = punycode
    else # in Narwhal or RingoJS v0.7.0-
      for key of punycode
        punycode.hasOwnProperty(key) and (freeExports[key] = punycode[key])
  else # in Rhino or a web browser
    root.punycode = punycode
  return
) this
