https://github.com/defenestration/fortunate

unix fortune clone for node/coffeescript/javascript

args: 
	-s - short fortunes only 
	-c - show cookie file & info
	-f - list fortune cookie files
	[cookie [fortune Number]] - for specific cookie file, and fortune

A directory can also be passed to the module to use your fortune files elsewhere on your system.

Fortune files are just '\n%\n' delimited files, so it is easy to create your own.  

Unlike unix fortune, a .dat file (made with strfile) is not required. 