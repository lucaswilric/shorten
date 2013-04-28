require('./string-utils.coffee')
require('./array-utils.coffee')

tr = require('./text-respond.coffee')

urls = {}

get_key = () ->
  # Find the highest existing key
  keys = Object.keys(urls)
  maxKey = (if keys.length > 0 then keys.max() else '').toString()
  # Increment it
  newKey = maxKey.inc()
  # Check it doesn't already exist
  check = urls[newKey]
  return get_key() if check? or newKey in ['new', 'urls']
  # Assign it
  return newKey

create_url = (req) ->
  k = get_key()
  urls[k] = req.body.url
  'http://' + req.headers['host'] + '/' + k

find = (res, url) ->
  longUrl = urls[url.substring(1,url.length)]
  if longUrl?
    tr.found(res, longUrl)
  else
    tr.not_found(res)

exports.route = (req, res) ->
  switch req.method
    when 'POST'
      switch req.url
        when '/new' 
          if req.body.url?
            res.end(create_url(req))
          else
            tr.bad_request(res, 'Parameter `url` is required.')
        else tr.not_found(res)
    when 'GET'
      switch req.url
        when '/new'
          tr.bad_request(res, 'You need to POST to this URL.')
        when '/urls'
          res.end(JSON.stringify(urls))
        else
          find(res, req.url)