# The face of this program. Its purpose is two-fold:
# 1. Accept user input and make sure that user input is correct (but not to an overly exhaustive degree)
# 2. Relay the relevant information to the "brain" of this program, ims_impl.rb

require_relative "ims_shell_checks.rb"

class IMS_Shell
  #Get the brain working.
  filter = IMS_Shell_Checker.new
  #Say hello!
  puts "Welcome to the Interactive Music Shell. Please give a command: "

  #Will never stop unless you say so.
  while true
    print "ims> "
    input = $stdin.gets.chomp
    input = input.downcase.strip #Eliminate trailing whitespace and makes case matching easier
    cmd = input.split(" ") #parse the input for easier case handling
    # At the moment, this implementation assumes the user has a decent idea of how to use
    # the application... So no in-depth length checking.

    #Bye!
    if cmd[0] == 'exit'
      puts "Thank you for using the Interactive Music Shell. Your progress has been saved."
      break

    elsif cmd[0] == 'help' #Get a list of commands
      filter.help(cmd[0])

    elsif cmd[0] == 'info' #A few different things it could be...
      filter.info_filter(cmd[1..cmd.length-1])

    elsif cmd[0] == 'add' #Two things you can add: tracks and artists
      filter.add_filter(cmd[1..cmd.length-1])

    elsif cmd[0] == 'play' #Doesn't actually play the song, just prints stuff and changes a few things in ims_impl.rb
      filter.play_filter(cmd[1..cmd.length-1])

    elsif cmd[0] == 'list' #Gives a list of songs related to the artist's id
      filter.list_filter(cmd[1..cmd.length-1])

    elsif cmd[0] == 'count' #Gives the number of songs related to the artist's id
      filter.count_filter(cmd[1..cmd.length-1])

    elsif cmd[0] == 'tracklist' #Gives the list of tracks in the IMS
      filter.tracklist_filter(cmd[0])

    elsif cmd[0] == 'artist-list' #Gives the list of artists in the IMS
      filter.artist_list_filter(cmd[0])

    else
       puts "Not a valid command. Type in 'help' for a list of commands."
    end #End of if-else chain for cmd[0]

  end #End of while loop

end
