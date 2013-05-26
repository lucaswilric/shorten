exports.not_found = (res) ->
    res.writeHead(404, {'content-type': 'text/plain'})
    res.end('Sorry, nothing here')

exports.bad_request = (res, msg) ->
    res.writeHead(400, {'content-type': 'text/plain'})
    res.end(msg)

exports.found = (res, url) ->
    res.writeHead(302, {'content-type': 'text/plain', 'location': url})
    res.end()

exports.error = (res, msg) ->
  res.writeHead(500, {'content-type': 'text/plain'})
  res.end(msg)