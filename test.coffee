Fortunes = require "./fortunate.coffee"
fortunes = new Fortunes("./testFortunes")

#console.log fortunes.tell(process.argv)

#maybe try from your own system's fortunes

console.log fortunes.tell( process.argv.slice(2) )
#or
#args=["-s","robot"]
#fortunes.tell(args)