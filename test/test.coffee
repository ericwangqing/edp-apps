extractAllConfigurations = require '../extract-all-configurations'
should = require 'should'

describe '简单测试extract all configuration', ->
  sourceLib = 'source'
  it '可以萃取到module info', (done)->
    extractAllConfigurations sourceLib, (moduleConfigurations)->
      moduleConfigurations.length.should.eql 1
      configuration = moduleConfigurations[0]
      shouldHaveProperty configuration, 'name', 'HP21'
      shouldHaveProperty configuration, 'description', '开门模块'
      shouldHaveProperty configuration, 'author', '黄华明'
      shouldHaveProperty configuration, 'version', '1.1'
      done()

shouldHaveProperty = (obj, propertyName, propertyValue)->
  return false if not obj.should.have.property propertyName
  obj[propertyName].should.eql propertyValue