mongo_url = process.env.MONGOHQ_URL || 'mongodb://127.0.0.1:27017/shorten'
mongo = require('mongodb')

findInternal = (query, _callback) ->
  mongo.MongoClient.connect mongo_url, (err, client) ->
    client.collection('urls').find query, {key: 1, url: 1, _id: 0}, (err, cursor) ->
      if err?
        console.log err
      else
        cursor.toArray _callback

exports.save = (_key, _url, _callback) ->
  mongo.MongoClient.connect mongo_url, (err, client) ->
    client.collection 'urls', (err, coll) ->
      coll.save({key: _key, url: _url}, {w:1}, _callback)

exports.find = (_key, _callback) ->
  mongo.MongoClient.connect mongo_url, (err, client) ->
    findInternal {key: _key}, (err, result) ->
      if err?
        console.log err
      else
        _callback(result)

exports.all = (_callback) ->
  mongo.MongoClient.connect mongo_url, (err, client) ->
    findInternal {}, (err, result) ->
      if err?
        console.log err
      else
        _callback(result)

exports.with_max_key = (_callback) ->
  mongo.MongoClient.connect mongo_url, (err, client) ->
    client.collection 'urls', (err, coll) ->
      coll.aggregate [
        {$match: {key: {'$ne': null}}},
        {$sort: {key: -1}},
        {$limit: 1}
        ], 
        (err, result) ->
          if err?
            console.log err
          else
            _callback(if result.length > 0 then result[0].key else '')

exports.count = (_callback) ->
  mongo.MongoClient.connect mongo_url, (err, client) ->
    client.collection 'urls', (err, coll) ->
      coll.count _callback
