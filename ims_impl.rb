require 'json'
require 'byebug'
# As the name implies, this is the "brain" of the program.
# It accesses two json files, artist_list.json and tracklist.json as the storage.
# It manipulates these two files in order to maintain state.

class IMS_impl
  def initialize
    #Keeps track of the most recent three tracks played by the user.
    file1 = File.read("tracklist.json")
    file2 = File.read("artist_list.json")
    tracks = JSON.parse(file1)
    artists = JSON.parse(file2)
    @track_list = Hash.new
    @track_list["1"] = "Nothing"
    @track_list["2"] = "Nothing"
    @track_list["3"] = "Nothing"
    @no_tracks = tracks.keys.length #Number of tracks stored in the json file
    @no_artists = artists.keys.length #Number of artists stored in the json file
  end

  #Self-explanatory method that gives the list of commands the IMS can do, and in the format it accepts.
  def help_me()
    print "\nThis is a list of the available commands:"
    puts "'help': access this list of commands"
    puts "'add artist <artist name>': adds a new artist to the database and will refer to them by their initials"
    puts "'info': returns the number of songs and artists on disk in addition to the last 3 songs played"
    puts "'info track <track #>': displays information on a track by its number in the database"
    puts "'info artist <initials>': displays information about a certain artist by ID"
    puts "'tracklist': displays all tracks in the IMS"
    puts "'artist-list': displays all artists in the IMS"
    puts "'add track <track name> by <initials>': adds new track to database"
    puts "'play track <track #>': Simulates playing a track by recording it at a certain time"
    puts "'list tracks by <initials>': counts the number of tracks by artist with given id"
    print "'count tracks by <initials>': displays the number of tracks by artist with given id\n\n"
  end

  #Only gives basic information; in particular,
  # 1. The number of artists in the json file
  # 2. The number of tracks in the json file
  # 3. The three most recent tracks played by the IMS
  #  a. This one resets after each time the IMS boots up.
  def info
    print "\nThere are #{@no_tracks} songs and #{@no_artists} artists recorded on the disk.\n"
    puts "These are the last three tracks played by the Interactive Music Shell during this session:"
    puts "1: " + @track_list["1"]
    puts "2: " + @track_list["2"]
    puts "3: " + @track_list["3"]
    print "\n"
  end

  # Fetches tracklist.json and displays the information associated to the key
  def info_track(number) #number is a String
    file = File.read('tracklist.json')
    tracks = JSON.parse(file)
    if tracks.has_key?(number)
      print "\n"
      puts "Basic information on track #{number}:"
      puts "Title: #{tracks[number]["title"]}"
      print "Artist: #{tracks[number]["artist"]}\n\n"
    elsif number.nil? || !number.is_a?(String)
      puts "No track was listed. Tracks are listed by number in this IMS."
    else
      puts "That track does not exist in this IMS. Did you provide a track number?"
    end
    #puts number
  end

  # Fetches artist_list.json and displays the information associated to the key
  def info_artist(id)
    file = File.read('artist_list.json')
    artists = JSON.parse(file)
    if artists.has_key?(id)
      print "\n"
      puts "Basic information on artist #{id}:"
      puts "Name: #{artists[id]["first_name"]} #{artists[id]["last_name"]}"
      puts "IMS id: #{id}"
      puts "List of songs: "
      i = 0
      artists[id]["songs"].each do |song|
        puts " - #{song}"
        i += 1
      end
      print "\n"
    elsif id.nil? || !id.is_a?(String)
      puts "No artist id was provided. Artists are listed by id in this IMS."
    else
      puts "That artist does not exist in this IMS. Did you provide an artist id?"
    end
    #puts id
  end

  # Fetches artist_list.json, adds the new artist and rewrites the json file.
  def add_artist(f_name, l_name)
    file = File.read('artist_list.json')
    artists = JSON.parse(file)
    exists = false
    existing = artists.values
    existing.each do |art|
      if art["first_name"] == f_name && art["last_name"] == l_name
        exists = true
        break
      end
    end
    if exists
      puts "This artist already exists in the IMS."
    else
      k = f_name[0] + l_name[0]
      counter = 1
      while artists.has_key?(k)
        k = k + "_" + counter.to_s
        counter += 1
      end
      entry = {"id": k, "first_name": f_name, "last_name": l_name, "songs": []}
      artists[k.to_sym] = entry
      @no_artists += 1
      File.open("artist_list.json", "w") do |f|
        f.write(JSON.pretty_generate(artists))
        f.close
      end
      puts "Artist '#{f_name} #{l_name}' added to IMS. Refer to this artist using this id: '#{k}'"
    end
    #puts f_name
    #puts l_name
  end

  # Fetches tracklist.json, adds the new track and rewrites the json file.
  def add_track(track, id)
    file1 = File.read('tracklist.json')
    file2 = File.read('artist_list.json')
    tracks = JSON.parse(file1)
    artists = JSON.parse(file2)
    exists = false
    tracks.values.each do |t|
      #byebug
      if t["title"] == track && t["artist"] == id
        exists = true
        break
      end
    end
    if exists
      puts "This track already exists in the IMS."
    elsif !artists.has_key?(id)
      puts "The artist with id '#{id}' does not exist in the database. Please add this artist first, then add this track."
    else
      entry = {"title": track, "artist": id}
      tracks["#{@no_tracks + 1}".to_sym] = entry
      artists[id]["songs"] << track
      File.open("tracklist.json", "w") do |f|
        f.write(JSON.pretty_generate(tracks))
        f.close
      end
      File.open("artist_list.json", "w") do |f2|
        f2.write(JSON.pretty_generate(artists))
        f2.close
      end
      @no_tracks += 1
      puts "Track '#{track}' has been added to the IMS. It can be referred to as track #{@no_tracks}."
    end
    #puts track
    #puts id
  end

  # Adds the track to the three most recently played tracks on the IMS.
  def play_track(number) #number is a String
    file = File.read('tracklist.json')
    tracks = JSON.parse(file)
    if tracks.has_key?(number)
      puts "Now playing: #{tracks[number]["title"]} by #{tracks[number]["artist"]}"
      @track_list["3"] = @track_list["2"]
      @track_list["2"] = @track_list["1"]
      @track_list["1"] = "#{tracks[number]["title"]} by #{tracks[number]["artist"]}"
    else
      puts "Track #{number} does not exist in the IMS."
    end
    #puts "playing track #{number}."
  end

  def tracklist(list)
    file = File.read('tracklist.json')
    tracks = JSON.parse(file)
    puts "There are currently #{@no_tracks} tracks in this IMS:"
    print "\n"
    tracks.each do |t|
      i = 0
      t.each do |entry|
        if i % 2 == 0
          print "Track #{entry}: "
        else
          puts "'#{entry["title"]}' by #{entry["artist"]}"
        end
        i += 1
      end
    end
    print "\n"
  end

  def artist_list(list)
    file = File.read('artist_list.json')
    artists = JSON.parse(file)
    puts "There are currently #{@no_artists} artists in this IMS:"
    print "\n"
    artists.each do |a|
      i = 0
      a.each do |entry|
        if i % 2 == 0
          print "Artist ID #{entry}: "
        else
          puts "#{entry["first_name"]} #{entry["last_name"]}"
        end
        i += 1
      end
    end
    print "\n"
  end

  # Fetches artist_list.json and displays all tracks associated with the artist.
  def list_tracks(id)
    file = File.read('artist_list.json')
    artists = JSON.parse(file)
    count = 0
    if artists.has_key?(id)
      puts "The artist with id '#{id}' has these songs on this IMS:"
      artists[id]["songs"].each do |song|
        puts " - #{song}"
        count += 1
      end
      print "\n"
    else
      puts "The artist with id '#{id}' does not exist on this IMS."
    end
    #puts id
  end

  #Fetches artist_list.json and gives the number of tracks the artist has in that file.
  def count_tracks(id)
    file = File.read('artist_list.json')
    artists = JSON.parse(file)
    count = 0
    if artists.has_key?(id)
      artists[id]["songs"].each do |song|
        count += 1
      end
      puts "The artist with id '#{id}' has #{count} songs on this IMS."
    else
      puts "The artist with id '#{id}' does not exist on this IMS."
    end
    #puts id
  end
end
