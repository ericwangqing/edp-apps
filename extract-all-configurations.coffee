fs = require 'fs.extra'
path = require 'path'
parseModuleConfiguration = require './parse-module-configuration'
# _ = require 'underscore'

extractAllConfigurations = (libRoot, callback)->
  moduleConfigurations = []
  walker = fs.walk libRoot
  walker.on 'file', (root, stat, next)->
    if (isSourceFile stat) and (not isModuleConfigurationExisted stat.name)
      parseModuleConfiguration (path.join root, stat.name), moduleConfigurations, next
    else
      next()  

  walker.on 'end', ->
    persistModuleConfigurations moduleConfigurations, callback

isSourceFile = (stat)->
  # console.log (path.extname stat.name)
  stat.isFile() and (path.extname stat.name) in ['.c', '.coffee']

isModuleConfigurationExisted = (filename)->
  # TODO
  false

persistModuleConfigurations = (configurations, callback)->
  # TODO
  callback configurations

module.exports = extractAllConfigurations



