# defaults, types, and shorthands.
Octal = ->
validateOctal = (data, k, val) ->
  
  # must be either an integer or an octal string.
  if typeof val is "number"
    data[k] = val
    return true
  if typeof val is "string"
    return false  if val.charAt(0) isnt "0" or isNaN(val)
    data[k] = parseInt(val, 8).toString(8)
  return
validateSemver = (data, k, val) ->
  return false  unless semver.valid(val)
  data[k] = semver.valid(val)
  return
validateTag = (data, k, val) ->
  val = ("" + val).trim()
  return false  if not val or semver.validRange(val)
  data[k] = val
  return
validateStream = (data, k, val) ->
  return false  unless val instanceof Stream
  data[k] = val
  return

# Don't let --tag=1.2.3 ever be a thing

# c:\node\node.exe --> prefix=c:\node\

# /usr/local/bin/node --> prefix=/usr/local

# destdir only is respected on Unix

# local-address must be listed as an IP for a local network interface
# must be IPv4 due to node bug
getLocalAddresses = ->
  Object.keys(os.networkInterfaces()).map((nic) ->
    os.networkInterfaces()[nic].filter((addr) ->
      addr.family is "IPv4"
    ).map (addr) ->
      addr.address

  ).reduce((curr, next) ->
    curr.concat next
  , []).concat `undefined`
  return
path = require("path")
url = require("url")
Stream = require("stream").Stream
semver = require("semver")
stableFamily = semver.parse(process.version)
nopt = require("nopt")
os = require("os")
osenv = require("osenv")
log = undefined
try
  log = require("npmlog")
catch er
  util = require("util")
  log = warn: (m) ->
    console.warn m + " " + util.format.apply(util, [].slice.call(arguments, 1))
    return
exports.Octal = Octal
nopt.typeDefs.semver =
  type: semver
  validate: validateSemver

nopt.typeDefs.Octal =
  type: Octal
  validate: validateOctal

nopt.typeDefs.Stream =
  type: Stream
  validate: validateStream

tag = {}
nopt.typeDefs.tag =
  type: tag
  validate: validateTag

nopt.invalidHandler = (k, val, type) ->
  log.warn "invalid config", k + "=" + JSON.stringify(val)
  if Array.isArray(type)
    if type.indexOf(url) isnt -1
      type = url
    else type = path  if type.indexOf(path) isnt -1
  switch type
    when tag
      log.warn "invalid config", "Tag must not be a SemVer range"
    when Octal
      log.warn "invalid config", "Must be octal number, starting with 0"
    when url
      log.warn "invalid config", "Must be a full url with 'http://'"
    when path
      log.warn "invalid config", "Must be a valid filesystem path"
    when Number
      log.warn "invalid config", "Must be a numeric value"
    when Stream
      log.warn "invalid config", "Must be an instance of the Stream class"

if not stableFamily or (+stableFamily.minor % 2)
  stableFamily = null
else
  stableFamily = stableFamily.major + "." + stableFamily.minor
defaults = undefined
temp = osenv.tmpdir()
home = osenv.home()
uidOrPid = (if process.getuid then process.getuid() else process.pid)
if home
  process.env.HOME = home
else
  home = path.resolve(temp, "npm-" + uidOrPid)
cacheExtra = (if process.platform is "win32" then "npm-cache" else ".npm")
cacheRoot = process.platform is "win32" and process.env.APPDATA or home
cache = path.resolve(cacheRoot, cacheExtra)
globalPrefix = undefined
Object.defineProperty exports, "defaults",
  get: ->
    return defaults  if defaults
    if process.env.PREFIX
      globalPrefix = process.env.PREFIX
    else if process.platform is "win32"
      globalPrefix = path.dirname(process.execPath)
    else
      globalPrefix = path.dirname(path.dirname(process.execPath))
      globalPrefix = path.join(process.env.DESTDIR, globalPrefix)  if process.env.DESTDIR
    defaults =
      "always-auth": false
      "bin-links": true
      browser: null
      ca: null
      cafile: null
      cache: cache
      "cache-lock-stale": 60000
      "cache-lock-retries": 10
      "cache-lock-wait": 10000
      "cache-max": Infinity
      "cache-min": 10
      cert: null
      color: true
      depth: Infinity
      description: true
      dev: false
      editor: osenv.editor()
      "engine-strict": false
      force: false
      "fetch-retries": 2
      "fetch-retry-factor": 10
      "fetch-retry-mintimeout": 10000
      "fetch-retry-maxtimeout": 60000
      git: "git"
      "git-tag-version": true
      global: false
      globalconfig: path.resolve(globalPrefix, "etc", "npmrc")
      group: (if process.platform is "win32" then 0 else process.env.SUDO_GID or (process.getgid and process.getgid()))
      heading: "npm"
      "ignore-scripts": false
      "init-module": path.resolve(home, ".npm-init.js")
      "init-author-name": ""
      "init-author-email": ""
      "init-author-url": ""
      "init-version": "1.0.0"
      "init-license": "ISC"
      json: false
      key: null
      link: false
      "local-address": `undefined`
      loglevel: "warn"
      logstream: process.stderr
      long: false
      message: "%s"
      "node-version": process.version
      npat: false
      "onload-script": false
      optional: true
      parseable: false
      prefix: globalPrefix
      production: process.env.NODE_ENV is "production"
      "proprietary-attribs": true
      proxy: process.env.HTTP_PROXY or process.env.http_proxy or null
      "https-proxy": process.env.HTTPS_PROXY or process.env.https_proxy or process.env.HTTP_PROXY or process.env.http_proxy or null
      "user-agent": "npm/{npm-version} " + "node/{node-version} " + "{platform} " + "{arch}"
      "rebuild-bundle": true
      registry: "https://registry.npmjs.org/"
      rollback: true
      save: false
      "save-bundle": false
      "save-dev": false
      "save-exact": false
      "save-optional": false
      "save-prefix": "^"
      scope: ""
      searchopts: ""
      searchexclude: null
      searchsort: "name"
      shell: osenv.shell()
      shrinkwrap: true
      "sign-git-tag": false
      spin: true
      "strict-ssl": true
      tag: "latest"
      tmp: temp
      unicode: true
      "unsafe-perm": process.platform is "win32" or process.platform is "cygwin" or not (process.getuid and process.setuid and process.getgid and process.setgid) or process.getuid() isnt 0
      usage: false
      user: (if process.platform is "win32" then 0 else "nobody")
      userconfig: path.resolve(home, ".npmrc")
      umask: (if process.umask then process.umask() else parseInt("022", 8))
      version: false
      versions: false
      viewer: (if process.platform is "win32" then "browser" else "man")
      _exit: true

    defaults

exports.types =
  "always-auth": Boolean
  "bin-links": Boolean
  browser: [
    null
    String
  ]
  ca: [
    null
    String
    Array
  ]
  cafile: path
  cache: path
  "cache-lock-stale": Number
  "cache-lock-retries": Number
  "cache-lock-wait": Number
  "cache-max": Number
  "cache-min": Number
  cert: [
    null
    String
  ]
  color: [
    "always"
    Boolean
  ]
  depth: Number
  description: Boolean
  dev: Boolean
  editor: String
  "engine-strict": Boolean
  force: Boolean
  "fetch-retries": Number
  "fetch-retry-factor": Number
  "fetch-retry-mintimeout": Number
  "fetch-retry-maxtimeout": Number
  git: String
  "git-tag-version": Boolean
  global: Boolean
  globalconfig: path
  group: [
    Number
    String
  ]
  "https-proxy": [
    null
    url
  ]
  "user-agent": String
  heading: String
  "ignore-scripts": Boolean
  "init-module": path
  "init-author-name": String
  "init-author-email": String
  "init-author-url": [
    ""
    url
  ]
  "init-license": String
  "init-version": semver
  json: Boolean
  key: [
    null
    String
  ]
  link: Boolean
  "local-address": getLocalAddresses()
  loglevel: [
    "silent"
    "error"
    "warn"
    "http"
    "info"
    "verbose"
    "silly"
  ]
  logstream: Stream
  long: Boolean
  message: String
  "node-version": [
    null
    semver
  ]
  npat: Boolean
  "onload-script": [
    null
    String
  ]
  optional: Boolean
  parseable: Boolean
  prefix: path
  production: Boolean
  "proprietary-attribs": Boolean
  proxy: [
    null
    url
  ]
  "rebuild-bundle": Boolean
  registry: [
    null
    url
  ]
  rollback: Boolean
  save: Boolean
  "save-bundle": Boolean
  "save-dev": Boolean
  "save-exact": Boolean
  "save-optional": Boolean
  "save-prefix": String
  scope: String
  searchopts: String
  searchexclude: [
    null
    String
  ]
  searchsort: [
    "name"
    "-name"
    "description"
    "-description"
    "author"
    "-author"
    "date"
    "-date"
    "keywords"
    "-keywords"
  ]
  shell: String
  shrinkwrap: Boolean
  "sign-git-tag": Boolean
  spin: [
    "always"
    Boolean
  ]
  "strict-ssl": Boolean
  tag: tag
  tmp: path
  unicode: Boolean
  "unsafe-perm": Boolean
  usage: Boolean
  user: [
    Number
    String
  ]
  userconfig: path
  umask: Octal
  version: Boolean
  versions: Boolean
  viewer: String
  _exit: Boolean

exports.shorthands =
  s: [
    "--loglevel"
    "silent"
  ]
  d: [
    "--loglevel"
    "info"
  ]
  dd: [
    "--loglevel"
    "verbose"
  ]
  ddd: [
    "--loglevel"
    "silly"
  ]
  noreg: ["--no-registry"]
  N: ["--no-registry"]
  reg: ["--registry"]
  "no-reg": ["--no-registry"]
  silent: [
    "--loglevel"
    "silent"
  ]
  verbose: [
    "--loglevel"
    "verbose"
  ]
  quiet: [
    "--loglevel"
    "warn"
  ]
  q: [
    "--loglevel"
    "warn"
  ]
  h: ["--usage"]
  H: ["--usage"]
  "?": ["--usage"]
  help: ["--usage"]
  v: ["--version"]
  f: ["--force"]
  gangster: ["--force"]
  gangsta: ["--force"]
  desc: ["--description"]
  "no-desc": ["--no-description"]
  local: ["--no-global"]
  l: ["--long"]
  m: ["--message"]
  p: ["--parseable"]
  porcelain: ["--parseable"]
  g: ["--global"]
  S: ["--save"]
  D: ["--save-dev"]
  E: ["--save-exact"]
  O: ["--save-optional"]
  y: ["--yes"]
  n: ["--no-yes"]
  B: ["--save-bundle"]
  C: ["--prefix"]
