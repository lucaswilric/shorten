require('./string-utils.coffee')
require('./array-utils.coffee')

tr = require('./text-respond.coffee')

urls = require('./urls.coffee')

get_key = (callback) ->
  # Find the highest existing key
  urls.with_max_key (key) ->
    newKey = (key || '').inc()
    # Check it doesn't already exist
    urls.find newKey, (docs) ->
      newKey = newKey.inc() if docs.length > 0 or newKey in ['new', 'urls']
      # Assign it
      callback(newKey)

exports.create_url = (req, res) ->
  get_key (k) ->
    urls.save k, req.body.url, (err, result) ->
      if err?
        tr.error(res, 'Error while saving')
      else
        res.end("http://#{ req.headers['host'] }/#{ result.key }")

exports.redirect = (req, res) ->
  url = req.url
  next('route') if '/urls' == url
  urls.find url.substring(1,url.length), (docs) ->
    if docs.length > 0
      tr.found(res, docs[0].url)
    else
      tr.not_found(res)

exports.all_urls = (req, res) ->
  urls.all (docs) ->
    res.end(JSON.stringify(docs))