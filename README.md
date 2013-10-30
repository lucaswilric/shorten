# Shorten

## An API-only Node.JS-based CoffeeScript URL shortener

I generally think that [URL shorteners are bad for the web](http://blog.lucasrichter.id.au/posts/url-shortening-sucks-when-bandwidth-is-scarce.html), but I needed a simple project that would let me brush up on my CoffeeScript. Plus, many small URL shorteners is a lesser evil than a few big ones.

### Examples

Shorten a URL:

```bash
$ curl --data url=http%3A%2F%2Fgoogle.com%2F http://localhost:5000/new

http://localhost:5000/1
```

Get the list of shortened URLs:

```bash
$ curl -i http://localhost:5000/urls

HTTP/1.1 200 OK
Date: Fri, 24 May 2013 11:29:20 GMT
Connection: keep-alive
Transfer-Encoding: chunked

{"1":"http://github.com/lucaswilric/shorten","2":"http://blog.lucasrichter.id.au/"}
```

