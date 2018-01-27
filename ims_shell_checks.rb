require_relative "ims_impl.rb"

class IMS_Shell_Checker
  def initialize
    @execution = IMS_impl.new
  end

  def help(cmd)
    @execution.help_me
  end

  def info_filter(cmd)
    if cmd[0].nil? # The only part the user put in was 'info'
      @execution.info
    elsif cmd[0] == 'track' && cmd.length >= 2
      @execution.info_track(cmd[1]) #cmd[1] should be an int
    elsif cmd[0] == 'artist' && cmd.length >= 2
      @execution.info_artist(cmd[1]) #cmd[1] should be an id of an artist
    else
      puts "Invalid format for getting information. Type in 'help' for a list of commands."
    end  #End of if-else chain for 'info'
  end

  def add_filter(cmd)
    if cmd.length < 1 #Invalid format
      puts "Invalid format for adding data. Type in 'help' for a list of commands."
    elsif cmd[0] == 'track'
      reconstruct_and_execute(cmd[1..cmd.length-1])
    elsif cmd[0] == 'artist'
      if cmd.length != 2
        puts "Artists use exactly their first name and last name to be added. Type in 'help' for a list of commands."
      else
        @execution.add_artist(cmd[1], cmd[2]) #Should be an artist's first name and last name
      end
    else
      puts "Not a valid command. Type in 'help' for a list of commands."
    end # End of if-else chain for 'add'
  end

  def play_filter(cmd)
    if (cmd.length != 2) || (cmd[0] != "track") || !cmd[1].match(/[0-9]+/) #looks for digits
      puts "Invalid format for playing tracks. Type in 'help' for a list of commands."
    else
      @execution.play_track(cmd[1]) #Should be an int
    end #End of if-else chain for 'play'
  end

  def count_filter(cmd)
    if cmd.length < 1 || cmd[0] != 'tracks'
      puts "Not a valid command. Type in 'help' for a list of commands."
    elsif cmd.length != 3 || cmd[1] != 'by'
      puts "No artist id was specified. Type in 'help' for a list of commands."
    else
      @execution.list_tracks(cmd[2]) # Should be the id of an artist
    end #End of if-else chain for 'count'
  end

  def tracklist_filter(cmd)
    @execution.tracklist(cmd)
  end

  def artist_list_filter(cmd)
    @execution.artist_list(cmd)
  end

  def list_filter(cmd)
    if cmd.length < 1 || cmd[0] != 'tracks'
      puts "Not a valid command. Type in 'help' for a list of commands."
    elsif cmd.length != 3 || cmd[1] != 'by'
      puts "No artist id was specified. Type in 'help' for a list of commands."
    else
      @execution.count_tracks(cmd[2]) # Should be the id of an artist
    end #End of if-else chain for 'count'
  end

  #Rebuilds the track's name and add it to the disk
  def reconstruct_and_execute(words)
    if words.length > 2 && words.include?('by') #A song is written by someone, yes? Plus, we want a name for the track.
      count = 0
      track_name = "" #Need to reconstruct the track name, since we turned the string into an array
      while count < words.length - 2 # You do not want to include the "by id" segment of the command
        track_name.insert(-1, words[count] + " ")
        count += 1
      end
      #byebug
      count += 1 #Should bring you to the artist id. You don't want to include 'by' that separates track from id
      if count == words.length-1 #Are you at the artist's id in the array of words?
        track_name = track_name.rstrip
        @execution.add_track(track_name, words[count]) #Should be a track name and the id of an artist
      else # They put in the artist's whole name
        puts "To add a track, you need to put in the artist's id. See 'help' for the format."
      end
    else #Invalid format
      puts "Invalid format for adding tracks. Type in 'help' for a list of commands."
    end
  end
end
