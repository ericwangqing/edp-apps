fs = require 'fs.extra'
path = require 'path'
parseModuleConfiguration = require './parse-module-configuration'
dbHelper = require './db-helper'
# _ = require 'underscore'

extractAllConfigurations = (libRoot, callback)->
  configurations = [] #仅仅是为了单元测试的需要，
  walker = fs.walk libRoot
  walker.on 'file', (root, stats, next)->
    if (isSourceFile stats)
      insertOrUpdateConfiguration stats.name, stats.mtime, (needInsertOrUpdate)->
        if needInsertOrUpdate
          parseModuleConfiguration (path.join root, stats.name), (configuration)->
            configurations.push configuration
            persistModuleConfiguration configuration, stats.mtime, next
        else
          next()
    else
      next()  

  walker.on 'end', ->
    callback configurations

isSourceFile = (stats)->
  # console.log (path.extname stats.name)
  stats.isFile() and (path.extname stats.name) in ['.c', '.coffee']

insertOrUpdateConfiguration = (filename, lastModifiedTime, insertUpdateCallback)->
  dbHelper.needInsertUpdateOrNot (getModuleName filename), lastModifiedTime, insertUpdateCallback

getModuleName = (filename)->
  (path.basename filename, path.extname filename).toUpperCase() # 所有的模块名均为大写。

persistModuleConfiguration = (configuration, lastModifiedTime, callback)->
  dbHelper.persistDoc configuration, lastModifiedTime, callback

module.exports = extractAllConfigurations



