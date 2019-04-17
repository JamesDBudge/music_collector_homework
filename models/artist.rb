require_relative('../db/sql_runner.rb')
require_relative('album.rb')

class Artist

  attr_reader :id, :name

 def initialize(options)
   @name = options['name']
   @id = options['id'].to_i if options['id']
 end

 def save()
   sql = "INSERT INTO artists (name) VALUES ($1) RETURNING id;"
   values = [@name]
   result = SqlRunner.run(sql, values)
   @id = result[0]['id'].to_i
 end

 def self.all()
   sql = "SELECT * FROM artists;"
   artists = SqlRunner.run(sql)
   return artists.map { |artist| Artist.new(artist) }
 end

 def self.display_albums_by_artist(id)
   sql = "SELECT * FROM albums WHERE artist_id = $1;"
   values = [id]
   results = SqlRunner.run(sql, values)
   albums = results.map { |album| Album.new(album)  }
   return albums
 end

end
