
# Module dependencies

express = require('express')
routes = require('./routes')
http = require('http')
path = require('path')

shorten = require('./shorten.coffee')

port = process.env.PORT || 5000

app = express()

app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)
app.use(express.static(path.join(__dirname, 'public')))

# development only
app.use(express.errorHandler()) if 'development' == app.get('env')

app.get('/', routes.index)

app.get('/urls', shorten.all_urls)

app.get(/^\/([A-Za-z0-9]+)$/, shorten.redirect)

app.post('/new', (req, res) ->
  if req.body.url?
    shorten.create_url(req,res)
  else
    tr.bad_request(res, 'Parameter `url` is required.')
)

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)

