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

create_url = (req, res) ->
  get_key (k) ->
    urls.save k, req.body.url, (err, result) ->
      if err?
        tr.error(res, 'Error while saving')
      else
        res.end("http://#{ req.headers['host'] }/#{ result.key }")

redirect = (res, url) ->
  urls.find url.substring(1,url.length), (docs) ->
    if docs.length > 0
      tr.found(res, docs[0].url)
    else
      tr.not_found(res)

exports.route = (req, res) ->
  switch req.method
    when 'POST'
      switch req.url
        when '/new' 
          if req.body.url?
            create_url(req,res)
          else
            tr.bad_request(res, 'Parameter `url` is required.')
        else 
          tr.not_found(res)
    when 'GET'
      switch req.url
        when '/new'
          tr.bad_request(res, 'You need to POST to this URL.')
        when '/urls'
          urls.all (docs) ->
            res.end(JSON.stringify(docs))
        else
          redirect(res, req.url)
