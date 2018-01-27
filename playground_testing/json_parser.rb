require 'json'
#Extracting json files, converting them to hashes and using them
#file = File.read('test.json')
#puts file
#hash = JSON.parse(file)
#puts hash.to_s
#hash = {"first_name": "John","last_name": "Wells","initials": "jw",
#  "songs":{"1": "song 1","2": "song 2","3": "song 3","4": "song 4"}}
#puts hash["first_name"]
#puts hash["last_name"]
#puts hash["initials"]
#puts hash["songs"]

#Adding to the json file we already have
#hash["songs"]["4"] = "song 4"
#puts hash["songs"]

#File.open("test.json", "w") do |f|
#  f.write(hash.to_json)
#  f.close
#end

#Creating a new file
#guy = {"first_name": "Donald", "last_name": "Fox", "initials": "df", "songs": {"1": "song 3", "2": "song 42"}}
#puts guy.to_s
#File.new("test_two.json")

#File.open("test_two.json", "w") do |f|
#  f.write(guy.to_json)
#  f.close
#end

#Doing this replaces the contents of test.json
#File.open("test.json", "w") do |f|
#  f.write(hash.to_json)
#  f.close
#end

# Trying a composite file. More tricky, but it holds more.
file = File.read("third.json")
disk = JSON.parse(file)
disk.each do |f|
  i = 0
  f.each do |s|
    if i % 2 == 0
      print "Artist #{s}'s first name: "
    else
      puts s["first_name"]
    end
    i += 1
  end
end
#puts disk.class
#puts disk.to_s
#puts disk["jw"] #would be the initials of the person
#i = 1
#disk["jw"]["songs"].each do |song|
#  puts song
#end
#profiles = disk.values
#puts profiles[0]
#puts profiles[1]
#puts profiles[2]
#puts profiles.class

#puts "cats"["cats".length-1]
#puts "#{34 + 45}".class
#entry = {"first_name": "Kyle", "last_name": "Carter", "initials": "kc", "songs": {"1": "song 63"}}
#var = "string".to_sym
#disk[entry[:initials]] = entry
#puts disk.to_s
#File.open("third.json", "w") do |f|
#  f.write(JSON.pretty_generate(disk))
#  f.close
#end
