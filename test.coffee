fortunes = require "./fortunate.coffee"


#console.log fortunes.tell(process.argv)

#maybe try from your own system's fortunes
console.log fortunes.tell(process.argv,"/usr/share/games/fortunes/")
#or
#args=["-s","robot"]
#fortunes.tell(args)