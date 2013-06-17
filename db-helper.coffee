mongodb = require 'mongodb'
config = require './config'
Db = mongodb.Db
Connection = mongodb.Connection
Server = mongodb.Server
BSON = mongodb.BSON
ObjectID = mongodb.ObjectID


client = new Db 'meteor', new Server(config.host, config.port, {}), w: 1

module.exports = 
  needInsertUpdateOrNot: (moduleName, sourceCodeLastModifiedDate, insertUpdateCallback)->
    client.open (error, client)->
      debugger
      throw error if error 
      collection = new mongodb.Collection client, config.moduleCollection
      cursor = collection.find 
        $and: [
            name: moduleName
          ,  
            lastModifiedTime:
              $gte: sourceCodeLastModifiedDate
        ]

      cursor.nextObject (err, validConfigDoc)->
        client.close()
        insertUpdateCallback(!validConfigDoc)


  persistDoc: (doc, lastModifiedTime, callback)->
    doc.lastModifiedTime = lastModifiedTime
    client.open (error, client)->
      throw error if error
      collection = new mongodb.Collection client, config.moduleCollection
      collection.update {name: doc.name}, {$set: doc}, {safe: true, upsert: true}, (err)->
        throw err if err
        client.close()
        callback()
  
