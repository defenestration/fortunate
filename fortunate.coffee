fs = require 'fs'
path = require 'path'
default_fortunes = path.resolve __dirname, "testFortunes"

module.exports = class Fortune
  constructor: ( @fortune_path = default_fortunes ) ->
    exists = fs.existsSync @fortune_path
    if exists 
      files = fs.readdirSync(@fortune_path)
      excludes = ///
      .(u8|dat|bak)$
      ///
      # exclude the extraneous files
      @fortune_list = ( f for f in files when ! f.match excludes )
    else
      @fortune_list = []

  list_cookies: () ->
    return @fortune_list

  open_cookie: ( cookie ) ->
    #get fortunes from fortune file
    fortunes = fs.readFileSync( "#{@fortune_path}/#{cookie}", 'utf8' )
      .replace /^%%.*\n/g, "" #removing lines starting with %%
      .split '\n%\n'
    return fortunes

  get: ( cookie = "" ) ->
    if @fortune_list.length == 0
      return "No fortunes found!"
    if cookie != ""
      if not @fortune_list.includes cookie
        return "Fortune not found! #{cookie}"
    else 
      #pull a random fortune cookie file
      cookie = @fortune_list[ Math.floor( Math.random() * @fortune_list.length ) ]
    fortunes = @open_cookie(cookie) 
    fortune_num = Math.floor( Math.random() * fortunes.length )
    return fortunes[fortune_num]

  tell: ( args = [] ) ->
    # emulate linux fortune, kinda
    rm_element = (array, str) ->
      if array.indexOf(str) > -1
        array.splice(str, 1 ) 
        return [array, true]
      else
        return [array, false]

    [ args, d ] = rm_element(args, "-d")
    console.log "d", d if d
    # console.log "fortune_list", @fortune_list
    if not @fortune_list > 0  #fail on empty list
      return "No fortunes found!"
    
    # getto option parsing, but works well enough
    short = args.indexOf("-s");
    args.splice(short, 1 ) if short > -1 

    c = args.indexOf("-c")
    args.splice(c, 1) if c > -1

    list_files = args.indexOf("-f");
    args.splice(list_files, 1 ) if list_files > -1
    
    cfile
    fortune_num
    #remaining arg if exists should be a cookie file
    if args[0]
      cfile = args[0]
      args.shift()
      console.log "splice", cfile, args if d
      # if number given, use it as the fortune id
      if args[0]
        if args[0].match /\d+/
          fortune_num = args[0] - 1  # 0 indexed for array
          args.shift()
          console.log "n", fortune_num if d
    #if we got -f, just show possible fortune cookie files 
    return "#{@fortune_list.join ", "}" if list_files > -1 
    if cfile
      if @fortune_list.includes cfile  #pull fortune from specific cookie file
        #console.log args[2]
        fortune_file = cfile
      else
        return "Fortune file not found! #{cfile}"
    else #pull a random fortune cookie file
      fortune_file = @fortune_list[ Math.floor( Math.random() * @fortune_list.length ) ]
      console.log "fortune_file", fortune_file if d
    #end


    # build array of fortunes from the given cookie
    fortunes = fs.readFileSync( "#{@fortune_path}/#{fortune_file}", 'utf8' )
      .replace /^%%.*\n/g, "" #removing lines starting with %%
      .split '\n%\n'

    # clean empty elements
    fortunes = ( f for f in fortunes when f != '' )

    # if you only want short fortunes:
    if short > -1 
      short_fortunes = (f for f in fortunes when f.length < 160 )
      fortunes = short_fortunes

    # the fortunes array is zero indexed, but to match array.length, and to require sensable user input, it should be 1 indexed.
    # if a numeric argument exists, and a fortune file specified, print that id
    console.log "cfile", cfile, "fortune_num", fortune_num if d
    if not cfile? and not fortune_num?
      fortune_num = Math.floor( Math.random() * fortunes.length )

    fortune = fortunes[ fortune_num ]

    output = ""
    if c > -1 
      # add 1 to fortune_num here so it will match the desired fortune
      output = "#{fortune_file} [#{fortune_num + 1}/#{fortunes.length }]" + (if short > -1 then " (short)" else "") + "\n"
    output += "#{fortune}"
    return output
  #end