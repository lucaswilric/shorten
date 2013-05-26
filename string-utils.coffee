String::reverse = () ->
  return this.split('').reverse().join('')

String::revReplace = (old, new_) ->
  return this.reverse().replace(old, new_).reverse()

String::inc = () ->
  legend = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  return legend[0] if this == ''
  newStr = new String(this).toString()
  lastChar = newStr.charAt(newStr.length-1)
  newCharIndex = legend.indexOf(lastChar)+1
  if newCharIndex < legend.length
    newChar = legend.charAt(newCharIndex)
    newStr = newStr.revReplace(lastChar,newChar)
  else
    newStr = String.inc(newStr.substring(0,newStr.length-1))+legend[0]
  return newStr
