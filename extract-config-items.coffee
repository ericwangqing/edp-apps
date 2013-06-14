fs = require 'fs.extra'
path = require 'path'
# _ = require 'underscore'

extract = (libRoot)->
  moduleConfigurations = []
  walker = fs.walk libRoot
  walker.on 'file', (root, stat, next)->
    if (isSourceFile stat) and (not isModuleConfigurationExisted stat.name)
      filepath = path.join root, stat.name
      fs.readFile filepath, {encoding: 'utf8'}, (error, sourceCode)->
        throw error if error 
        console.log "filepath is: #{filepath}"
        moduleConfigurations.push configuration if configuration = getModuleConfiguration sourceCode
    next()  

  walker.on 'end', ->
    console.log "modules: #{moduleConfigurations.length}"
    moduleConfigurations.forEach (conf)-> console.log "configuration: %j", conf
    persistModuleConfigurations moduleConfigurations

isSourceFile = (stat)->
  # console.log (path.extname stat.name)
  stat.isFile() and (path.extname stat.name) in ['.c', '.coffee']

isModuleConfigurationExisted = (filename)->
  # TODO
  false

getModuleConfiguration = (sourceCode)->
  # (sourceCode.split '\n')[0]
  console.log sourceCode
  edpAnnotations = getEdpAnnotations sourceCode
  debugger
  if edpAnnotations?.length
    configuration = getModuleInfo edpAnnotations
    configuration.configurableItems = getconfigurableItems edpAnnotations
    configuration

getEdpAnnotations = (sourceCode)-> # get annotations and strip out all '*'
  annotations = []
  annoSectionPattern = /\/\*[\s\S]+?\*\//g
  annoSections = sourceCode.match annoSectionPattern
  if annoSections?.length
    inSectionContentPattern = /^\/\*([\s\S]+?)\*\/$/
    annoSections.forEach (section)->
      annotations.push (section.match inSectionContentPattern)[1].replace /\*+/g, ''
  annotations

getModuleInfo = do ->
  attributes = ['name', 'description', 'author', 'version']
  attributeLinePattern = /^@?(name|description|author|version)\s*:\s*(.+)$/
  (annotations)->
    moduleInfo = {}
    moduleAnnotationPattern = /@module\s*\r?\n([\s\S]+)/
    for anno in annotations
      continue if not moduleAnnotationPattern.test anno
      moduleAnnoContent = (anno.match moduleAnnotationPattern)[1]
    for line in moduleAnnoContent.split /\r?\n/
      if group = line.trim().match attributeLinePattern
        moduleInfo[group[1]] = group[2]
    moduleInfo

getconfigurableItems = (annotations)->
  [] # TODO


# process.argv.forEach (val, index, array)->
#   console.log "index: #{index}, val: #{val}, array: %j", array

persistModuleConfigurations = (configurations)->
  # TODO

extract process.argv[2]


