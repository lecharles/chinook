class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :tracks
end

#let's play around in the rails console...
#Artist.all #i get an object of type artist.
#Artist.all.first

#Artist.first
#Artist.last

#Artist.find(4)

#Artist.where(name: "Queen")
#Artist.where(:name => "Queen") LO MISMO que L12

# Rails will protect from SQL injection attacks
# set artist name first: artist_name = "alanis"

# Artist.where("name ILIKE '#{artist_name}'")
# => never do this cuz it passes directly to the DB
# => the Rails way is:

# Artist.where("name ILIKE ?", "#{artist_name}")
# => by doing so Rails will prevent sql injeciton attack.

# How many tracks in the DB.
# SELECT COUNT(*) FROM "tracks"
#
# Track.where(album_id: 5)
#
# Track.where(album_id: 5).sum(:unit_price)

# Check ACTIVE RECORD QUERY INTERFACE
#
# DB is powerful and can do operations with it.
# You wanna get as much as you want
# SUM
# MIN
# MAX
# FIND among a bunch of records.
# What work you want the DB to do takes practice?
#
# But:
# Filtering
# Sorting
# Computation/Calculation done in the DB
# Get that stuff done in the DB then return to Ruby.

# Association:
# Between models
# Data types...
