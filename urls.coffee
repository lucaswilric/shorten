mongo = require('mongodb')
server = new mongo.Server '127.0.0.1', 27017, {}
client = new mongo.Db 'shorten', server, {safe: false}

# Might be safer to have one connection per request. Instantiate a new mongo.Db on every request?

findInternal = (query, _callback) ->
  client.collection 'urls', (err, coll) ->
    if err?
      console.log err
    else
      # console.log query
      coll.find query, {key: 1, url: 1, _id: 0}, (err, cursor) ->
        if err?
          console.log err
        else
          cursor.toArray _callback

exports.save = (_key, _url, _callback) ->
  client.collection 'urls', (err, coll) ->
    coll.save({key: _key, url: _url}, {w:1}, _callback)

exports.find = (_key, _callback) ->
  console.log _key
  findInternal {key: _key}, (err, result) ->
    if err?
      console.log err
    else
      _callback(result)

exports.all = (_callback) ->
  findInternal {}, (err, result) ->
    if err?
      console.log err
    else
      _callback(result)

exports.with_max_key = (_callback) ->
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
          _callback(result[0].key)

exports.count = (_callback) ->
  client.collection 'urls', (err, coll) ->
    coll.count _callback

client.open (err, result) ->
  console.log err if err?

# cb = (msg, printResult) ->
#   printResult = true unless printResult?
#   (e,r) ->
#     console.log msg || 'default callback'
#     console.log e
#     console.log r if printResult

# client.open (e,r) ->
#   #exports.find 'key', cb('find')

# #  exports.save 'key', 'http://google.com/', cb('save')

#   exports.find 'key', (e,docs) ->
#       #console.log docs
#       console.log docs.length

#   exports.with_max_key (key) ->
#     console.log key

#   exports.count (err, count) ->
#     console.log count

#   close = () ->
#     console.log('closing')
#     client.close()
#   setTimeout(close, 1000)
