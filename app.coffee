connect = require('connect')
http = require('http')
shorten = require('./shorten.coffee')

port = process.env.PORT || 5000

app = connect()
        .use(connect.logger('dev'))
        .use(connect.bodyParser())
        .use(shorten.route)

http.createServer(app).listen(port)
console.log("Listening on port " + port)
