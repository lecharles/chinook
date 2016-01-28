# Assignment

## SQL
In order to complete these exercises, you'll need the `psql` command line tool.

#### psql

In your command line, type
```bash
psql chinook_development
```
Don't forget to use semi-colons after each SQL statement!

To quit, simply type ctrl + d.

### Exercises

Of course, these can be done as one or more steps.

Check out [W3Schools' SQL Reference](http://www.w3schools.com/sql/sql_syntax.asp) as a reference.

**Answer with SQL code, not the query results!**

1) Count how many tracks belong to the MediaType "Protected MPEG-4 video file".
```SQL
SELECT * FROM tracks; #impossible and stupid to look "manually from here" :)
\d media_types;
SELECT * FROM media_types; #indicates that media_type_id for "Protected MPEG-4 video file" is 3
SELECT * FROM tracks WHERE media_type_id = 3;

```

2) Find the least expensive Track that has the Genre "Electronica/Dance".
```SQL
SELECT unit_price FROM tracks; #nope
SELECT tracks, unit_price FROM tracks;
SELECT name, album_id, genre_id, unit_price FROM tracks WHERE unit_price < 1;
\d genre;
SELECT * FROM genres;
SELECT name, composer, unit_price FROM tracks WHERE genre_id = 15 AND unit_price < 1;
```

3) Find the all the Artists whose names start with A.
```SQL
SELECT id, name FROM artists WHERE name LIKE 'A%' ORDER BY name ASC; #case sensitive: it will only give "A...s" in this case
SELECT id, name FROM artists WHERE name ILIKE 'A%' ORDER BY name ASC; #case insentive: it will give you "a...s" & "A...s"
```

4) Find all the Tracks that belong to the first Playlist.
```SQL
SELECT id, name FROM tracks; #nope
SELECT id, name FROM playlists; #oh no
SELECT playlist_id FROM playlists_tracks; #et non
SELECT * FROM tracks JOIN playlists_tracks ON tracks.id = playlists_tracks.track_id WHERE playlists_tracks.playlist_id = 1;
SELECT name, composer FROM tracks JOIN playlists_tracks ON tracks.id = playlists_tracks.track_id WHERE playlists_tracks.playlist_id = 1;
SELECT name, composer, unit_price FROM tracks JOIN playlists_tracks ON tracks.id = playlists_tracks.track_id WHERE playlists_tracks.playlist_id = 1;
```

## Active Record Query Interface
In order to complete these exercises, you'll need to launch your Rails console with
```bash
$ rails c
```

### Practice

Getting to know the Active Record Query Interface will definitely pay off in the long run. You should read through the [Rails Guide on Active Record Query Interface](http://guides.rubyonrails.org/active_record_querying.html)  and get to know it well.

With Chinook, you can start your rails console and try out the following queries. The cool part is, the console will also show you the SQL it actually generated and ran to execute the query.

All these practice examples are making use of some of the most commonplace methods. That said, DO TRY the other ones. And don't forget, **you can chain these different methods** to refine your results!

#### Finding
##### Retrieving a Single Object
[These methods](http://guides.rubyonrails.org/active_record_querying.html#retrieving-a-single-object) will return a single object. Notice that the SQL queries that are generated always use `LIMIT 1` and sometimes include an `ORDER BY` clause.

`.find`, `.first`, `.last`, `.find_by` are very commonly used methods and you'll see them often.

```ruby
artist = Artist.find(22)
```
```ruby
album = Album.first
```
```ruby
track = Track.last
```
```ruby
my_playlist = Playlist.find_by(name: "90’s Music")
```

##### Retrieving Multiple Objects
[These methods](http://guides.rubyonrails.org/active_record_querying.html#retrieving-multiple-objects) help you find multiple objects. You can also use `.find` with an array of ids.

Other popular multiple object finders are `.all`, `.find_each`, `.find_in_batches`

```ruby
tracks = Track.find([1, 10, 55])
```
```ruby
Genre.find_each do |a|
  puts a.name
end
```

#### Conditions
`.where` is the go-to method when it comes to conditionally finding data. You can pass in conditions as SQL strings, Ruby arrays or hashes. Strings are considered unsafe, however!

Instead of...
```ruby
Artist.where("name = 'AC/DC'")
```
...you should properly sanitize any user input by using an array to prevent SQL injection!
```ruby
Artist.where("name = ?", 'AC/DC')
```

Using a hash
```ruby
Artist.where(name: 'AC/DC')
```

#### Order
You can order your queries based on one or more column with `.order`. [See more details here](http://guides.rubyonrails.org/active_record_querying.html#ordering). It can be used alone or chained with other query statements.

```ruby
Album.where(artist_id: 1).order(created_at: :desc)
```

#### Limit
You can also [limit the amount of results](http://guides.rubyonrails.org/active_record_querying.html#limit-and-offset) you get with `.limit`. Best combined with other queries.

```ruby
Playlist.limit(5)
```

#### Calculations
`.count`, `.maximum`, `.minimum`, `.average`, `.sum` are common calculation methods you can run on your results. [See more details here](http://guides.rubyonrails.org/active_record_querying.html#calculations)

```ruby
Album.count
```

```ruby
Track.minimum(:unit_price)
```

### Exercise
Of course, these can be done as one or more steps.

**Answer with Ruby code, not the query results!**

1) Count how many tracks belong to the "Hip Hop/Rap" genre
```ruby
genre_id = Genre.find_by(name: "Hip Hop/Rap")
tracks = Track.find(genre_id = 17) #that's not it but good to know.
tracks = Track.count(genre_id = 17)

```
2) Find the most expensive Track that has the MediaType "MPEG audio file".
```ruby
MediaType.all #looking for [MediaType id: 1, name: "MPEG audio file"..

#find Tracks => media_type_id = 1 ?
tracks = Track.find(media_type_id = 1) #ok... but limits to 1 result.
tracks = Track.where(media_type_id: 1)
tracks.maximum(:unit_price)

```
3) Find the 2 oldest Artists.
```ruby
Artist.minimum(:created_at) #nope. this only gives me a date!
artist_oldest = Artist.order(created_at: :asc)
artist_oldest[0]
artist_oldest[1]
```
4) Find all the Tracks that belong to the first Playlist.
```ruby
Playlist.all
Playlist.first
# Track.joins(:playlists).where(playlists: {id: 1})
```
5) Find all the Tracks that belong to the 2 most recent playlists. *(HINT: This takes at least two ActiveRecord queries)*
```ruby
recent = Playlist.order(created_at: :desc)
recent[0]
recent[1]
#another way:
recent = Playlist.order(created_at: :desc).limit(2)
```
