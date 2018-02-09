Fortunes = require "./fortunate.coffee"

#maybe try from your own system's fortunes
# p='/opt/local/share/games/fortune'
# fortunes = new Fortunes(p)
# console.log fortunes.tell( process.argv.slice(2) )
# console.log fortunes.get("fortunes")

l='./testFortunes'
local = new Fortunes(l)
console.log local.tell(process.argv.slice(2))
console.log local.get("robot")
