require_relative('../db/sql_runner.rb')

class Album

  attr_reader :name, :genre, :id, :artist_id
  attr_writer :name

  def initialize(options)
    @name = options['name']
    @genre = options['genre']
    @id = options['id'].to_i if options['id']
    @artist_id = options['artist_id'].to_i
  end

  def save()
    sql = "INSERT INTO albums (name, genre, artist_id) VALUES ($1, $2, $3) RETURNING id;"
    values = [@name, @genre, @artist_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM albums;"
    albums = SqlRunner.run(sql)
    return albums.map { |album| Album.new(album) }
  end

  def self.artist(id)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    artist = results.map { |artist| Artist.new(artist) }
    return artist
  end

  def self.delete_all()
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
  end

  def update()
    sql = "
    UPDATE albums SET (
      name,
      genre,
      artist_id
    ) =
    (
      $1,$2,$3
    )
    WHERE id = $4"
    values = [@name, @genre, @artist_id, @id]
    update = SqlRunner.run(sql, values)
  end

end
