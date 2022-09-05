class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  # class method to create a table (with matching column_names to Class attributes) and establish connection to Database
  def self.create_table
    sql = %Q(
      CREATE TABLE IF NOT EXISTS songs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      )
      DB[:conn].execute(sql)
  end

  # instance method that saves attributes of Song Instances to Database.

  def save 
    sql = %Q(
    INSERT INTO songs (name, album)
    VALUES (?, ?)
    )
    DB[:conn].execute(sql, self.name, self.album)

    # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance (object)
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end


end

# STEPS:How a new Song Instance (object) is created and persisted into songs database.

# 1. Class Method #self.create invokes, init_method (def_initialize) to create new Song Instance or Object.
# 2. Class Method #self.create invokes class method #save which does the ff;
# -uses heredoc script to insert attributes of new Song Instance (Object) into songs database
# -returns database id of Song Object and save it as the Object's id, to enable consistent Object id and table_id
# -returns object (self)

# ** DRY NOTICE (EFFICIENCY)
# it's better to utilze the #self.create Method to instantiate and persist new objects to database
# RATHER THAN
# uSE #initialise_method // #save_method to instantiate and persist new objects to db

# self.create abstracts both #initialize and #save methods into one method
