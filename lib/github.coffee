path         = require('path')
fs           = require('fs')
github       = require('octonode')
WatchJS      = require("watchjs")
watch        = WatchJS.watch
unwatch      = WatchJS.unwatch
callWatchers = WatchJS.callWatchers
EventEmitter = require('events').EventEmitter

# this is a generic token
client = github.client("b88ebd287229cba593058175b38b059b13af6034")

class Github extends EventEmitter

  blacklist: [
    "AddonDownloader"
    "vikinghug.com"
    "VikingBuddies"
    "VikingDocs"
    "VikingWarriorResource"
    "VikingStalkerResource"
  ]

  repos: []

  constructor: -> return

  setRepos: (repos) -> @repos = repos

  findRepo: (_repo) ->
    return null if @repos.length == 0

    for repo, i in @repos
      if _repo.id == repo.id or _repo.name == repo.name
        return i
    return null

  getRepos: (owner) ->
    org = client.org(owner)
    org.repos (err, array, headers) =>
      if err
        console.log err
        return
      array = @filterForBlacklist(array)

      for repo, i in array
        @initRepo(repo, i)

      @sort(@repos)


  initRepo: (repo, i) ->
    payload =
      id                : repo.id
      owner             : repo.owner.login
      name              : repo.name
      git_url           : repo.git_url
      html_url          : repo.html_url
      issues_url        : "#{repo.html_url}/issues"
      open_issues_count : repo.open_issues_count
      pushed_at         : repo.pushed_at
      recent_update     : @checkForRecentUpdate(repo.pushed_at)

    index = @findRepo(repo)
    if index?
      @repos[index] = payload
    else
      @repos.push(payload)


    self = @
    watch payload, "pushed_at", (key, command, data) ->
      self.emit("UPDATE", this)
    @emit("UPDATE", payload)

  checkForRecentUpdate: (time) ->
    past = new Date(time).getTime()
    now  = new Date().getTime()
    delta = Math.abs(now - past) / 1000
    return Math.floor(delta / 3600) < 12

  filterForBlacklist: (array) ->
    self = this
    return array.filter (repo) ->
      n = 0
      self.blacklist.map (name) => n += (repo.name == name)
      return repo if n == 0

  sort: (repos) ->
    repos.sort (a,b) ->
      aStr = a.name.toLowerCase()
      bStr = b.name.toLowerCase()
      if (aStr > bStr)
        return 1
      else if (bStr > aStr)
        return -1
      else
        return 0

  runCommand: (command, data) ->
    repo = client.repo("#{data.owner}/#{data.name}")
    repo[command] (err, response, headers) =>
      data[command] = response



module.exports = new Github()
