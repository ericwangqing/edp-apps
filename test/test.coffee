extractAllConfigurations = require '../extract-all-configurations'
should = require 'should'

describe '简单测试extract all configuration', ->
  sourceLib = 'source'
  it '可以萃取到module info', (done)->
    extractAllConfigurations sourceLib, (moduleConfigurations)->
      moduleConfigurations.length.should.eql 1
      configuration = moduleConfigurations[0]
      shouldHaveProperty configuration, 'name', 'HP21'
      shouldHaveProperty configuration, 'description', '洗碗机开、关门控制模块，惠普芯片HP21'
      shouldHaveProperty configuration, 'author', 'AUTHOR_ID'
      shouldHaveProperty configuration, 'version', '1.1'
      shouldHaveProperty configuration, 'path', 'source/hp21.c'
      done()

  it '可以萃取到configurable item', (done)->
    extractAllConfigurations sourceLib, (moduleConfigurations)->
      configurableItems = moduleConfigurations[0].configurableItems
      configurableItems.should.have.length 3
      shouldHaveItem configurableItems, 
        name: 'DOOR_NAME'
        description: '门的名字'
        values: 'string'

      shouldHaveItem configurableItems,
        name: 'DEFAULT_STATUS'
        description: '门默认开关的状态'
        values: [
            value: '1', description: '前门'
          ,
            value: '2', description: '后门'
        ]

      shouldHaveItem configurableItems,
        name: 'CONTROL_PINS[]'
        description: '控制信号输入引脚'
        values: [0..5]
        multiple: 'multiple'

      done()




shouldHaveProperty = (obj, propertyName, propertyValue)->
  return false if not obj.should.have.property propertyName
  obj[propertyName].should.eql propertyValue

shouldHaveItem = (configurableItems, correctItem)->
  for item in configurableItems
    if item.name is correctItem.name
      item.should.eql correctItem 
      return
  should.fail "Configurable Item: #{correctItem.name} was not found."
