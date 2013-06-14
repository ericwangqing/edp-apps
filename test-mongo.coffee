mongodb = require 'mongodb'
Db = mongodb.Db
Connection = mongodb.Connection
Server = mongodb.Server
BSON = mongodb.BSON
ObjectID = mongodb.ObjectID

# client = new Db 'meteor', new Server('127.0.0.1', 3002, {}), w: 1
# client.open (error, client)->
#   throw error if error 
#   collection = new mongodb.Collection client, 'softwareModules'
#   collection.find({}, {limit: 10}).toArray (error, docs)->
#     console.dir docs

obj = 
  name: 'DOOR_NAME', description: '门名称'
  values: 
    value: 1, description: '前门'
    value: 2, description: '后门'
  

console.log "obj: %j", obj

