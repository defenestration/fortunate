fs = require 'fs'
path = require 'path'
default_fortunes = path.resolve __dirname, "testFortunes"

module.exports = class Fortune
	constructor: ( @fortune_path = default_fortunes ) ->
		files = fs.readdirSync(@fortune_path)
		excludes = ///
		.(u8|dat|bak)$
		///
		# exclude the extraneous files
		@fortune_list = ( f for f in files when ! f.match excludes )

	list_cookies: () ->
		return @fortune_list

	tell: ( args = [] ) ->
		# getto option parsing, but works well enough
		short = args.indexOf("-s");
		args.splice(short, 1 ) if short > -1 

		cookie = args.indexOf("-c")
		args.splice(cookie, 1) if cookie > -1

		list_files = args.indexOf("-f");
		args.splice(list_files, 1 ) if list_files > -1
		
		#if we got -f, just show possible fortune cookie files 
		return "#{@fortune_list.join ", "}" if list_files > -1 
		
		if args[2]
			if @fortune_list.includes args[2]  #pull fortune from specific cookie file
				#console.log args[2]
				fortune_file = args[2]
			else
				return "Fortune file not found! #{args[2]}"

		else #pull a random fortune cookie file
			fortune_file = @fortune_list[ Math.floor( Math.random() * @fortune_list.length ) ]
		#end

		# build array of fortunes from the given cookie
		fortunes = fs.readFileSync( "#{@fortune_path}/#{fortune_file}", 'utf8' )
			.split '\n%\n'

		# clean empty elements
		fortunes = ( f for f in fortunes when f != '' )

		# if you only want short fortunes:
		if short > -1 
			short_fortunes = (f for f in fortunes when f.length < 160 )
			fortunes = short_fortunes

		# the fortunes array is zero indexed, but to match array.length, and to require sensable user input, it should be 1 indexed.
		if args[3]
			fortune_num = args[3] - 1  # 0 indexed for array
			user_fortune_num = args[3] # 1 indexed, for display
		else
			fortune_num = Math.floor( Math.random()*fortunes.length )
			user_fortune_num = fortune_num + 1

		fortune = fortunes[ fortune_num ]

		output = ""
		if cookie > -1 
			# add 1 to fortune_num here so it will match the desired fortune
			output = "#{fortune_file} [#{user_fortune_num}/#{fortunes.length }]" + (if short > -1 then " (short)" else "") + "\n"
		output += "#{fortune}"
		return output
	#end