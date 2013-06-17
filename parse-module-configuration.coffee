# TODO: 添加抽取配置时的异常，以便提示作者注释书写出错。
fs = require 'fs.extra'
path = require 'path'

parseModuleConfiguration = (filepath, callback)->
  fs.readFile filepath, {encoding: 'utf8'}, (error, sourceCode)->
    throw error if error 
    # console.log "filepath is: #{filepath}"
    if configuration = getModuleConfiguration sourceCode
      changeAuthorNameToId configuration
      configuration.path = filepath
    callback(configuration)

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
  extractModuleInfo (getEdpAnnotationParts annotations, moduleAnnotationPattern)[0]

getEdpAnnotationParts = (annotations, partPattern)->
  annoParts = []
  for anno in annotations
    continue if not partPattern.test anno
    annoParts.push (anno.match partPattern)[1]
  annoParts


extractModuleInfo = (moduleAnnoContent)->
  moduleInfo = {}
  attributeLinePattern = /^@?(name|description|author|version)\s*:\s*(.+)$/
  for line in moduleAnnoContent.split /\r?\n/
    if group = line.trim().match attributeLinePattern
      moduleInfo[group[1]] = group[2]
  moduleInfo

getconfigurableItems = (annotations)->
  configurableItems = [] 
  configurableItemAnnotationPattern = /@config-item\s*\r?\n([\s\S]+)/
  for annoContent in getEdpAnnotationParts annotations, configurableItemAnnotationPattern
    configurableItems.push extractConfigurableItem annoContent
  configurableItems

extractConfigurableItem = (annoContent)->
  configurableItem = 
    name: (annoContent.match /name\s*:\s*([^,\s]+)\s*,?\s*/)[1]
    description: (annoContent.match /description\s*:\s*(.+)\s*,?\s*/)[1]
    values: extractConfigurableItemValues annoContent
  configurableItem.multiple = 'multiple' if annoContent.match /\bmultiple\s*:/
  configurableItem

extractConfigurableItemValues = (annoContent)->
  # 从便于developer书写源程序注释的角度来说，定义如下的规则：
  # 1、当有多个value出现时，如示例中hp21.c的DEFAULT_STATUS，values的值为object数组
  # 2、当只有一个value，或者values出现时：
  #     2.1、如果其后为数组表达式，如示例hp21.c的CONTROL_PINS[]，values的值为primitive数组
  #     2.2、此外，values的值为'string'
  if hasMoreThanOneValue annoContent
    values = extractObjectArrayValues annoContent 
  else if hasOneValueOrValues annoContent
    if isIntegerArray annoContent # 目前仅实现了整形数数组，字母数组、字符串数组等，尚未考虑
      values = extractIntegerArray annoContent
    else
      values = 'string'

hasMoreThanOneValue = (annoContent)->
  (annoContent.match /\bvalue\b/g)?.length > 1

extractObjectArrayValues = (annoContent)->
  values = []
  for annoValue in annoContent.match /value\s*:.+/g
    values.push
      value: (annoValue.match /value\s*:\s*([^,\s]+)\s*,?\s*/)[1]
      description: (annoValue.match /description\s*:\s*([^,\s]+)\s*,?\s*/)[1]
  values

hasOneValueOrValues = (annoContent)->
  (annoContent.match /\bvalues?\b/g)?.length is 1

isIntegerArray = (annoContent)->
  annoContent.match /values\s*:\s*\[\d+\.\.\d+\]/

extractIntegerArray = (annoContent)->
  groups = annoContent.match /values\s*:\s*\[(\d+)\.\.(\d+)\]/ 
  [(parseInt groups[1])..(parseInt groups[2])]


changeAuthorNameToId = (configuration)->
  # TODO: 直接查询mongodb，获取id
  configuration.author = 'AUTHOR_ID'




module.exports = parseModuleConfiguration