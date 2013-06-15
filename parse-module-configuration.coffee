fs = require 'fs.extra'
path = require 'path'

parseModuleConfiguration = (filepath, moduleConfigurations, callback)->
  fs.readFile filepath, {encoding: 'utf8'}, (error, sourceCode)->
    throw error if error 
    # console.log "filepath is: #{filepath}"
    moduleConfigurations.push configuration if configuration = getModuleConfiguration sourceCode
    callback()

getModuleConfiguration = (sourceCode)->
  # console.log sourceCode
  edpAnnotations = getEdpAnnotations sourceCode
  if edpAnnotations?.length
    configuration = getModuleInfo edpAnnotations
    configuration.configurableItems = getconfigurableItems edpAnnotations
    configuration

getEdpAnnotations = (sourceCode)-> # get annotations and strip out all '*'
  annoSectionPattern = /\/\*[\s\S]+?\*\//g
  annoSections = sourceCode.match annoSectionPattern
  extractEdpAnnotations annoSections

extractEdpAnnotations = (annoSections)->
  annotations = []
  if annoSections?.length
    inSectionContentPattern = /^\/\*([\s\S]+?)\*\/$/
    annoSections.forEach (section)->
      annotations.push (section.match inSectionContentPattern)[1].replace /\*+/g, ''
  annotations


getModuleInfo = (annotations)->
  moduleAnnotationPattern = /@module\s*\r?\n([\s\S]+)/
  for anno in annotations
    continue if not moduleAnnotationPattern.test anno
    moduleAnnoContent = (anno.match moduleAnnotationPattern)[1]
  extractModuleInfo moduleAnnoContent

extractModuleInfo = (moduleAnnoContent)->
  moduleInfo = {}
  attributeLinePattern = /^@?(name|description|author|version)\s*:\s*(.+)$/
  for line in moduleAnnoContent.split /\r?\n/
    if group = line.trim().match attributeLinePattern
      moduleInfo[group[1]] = group[2]
  moduleInfo

getconfigurableItems = (annotations)->
  [] # TODO

module.exports = parseModuleConfiguration