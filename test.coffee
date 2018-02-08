fortunes = require "./fortunate.coffee"


#console.log fortunes.tell(process.argv)

#maybe try from your own system's fortunes
console.log fortunes.tell(process.argv,"./testFortunes")
#or
#args=["-s","robot"]
#fortunes.tell(args)