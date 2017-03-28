class Song < ActiveRecord::Base
  belongs_to :artist
  validates :name, presence: true, uniqueness: true
  accepts_nested_attributes_for :artist
  def song_search
    artist.name.tr(' ', '+') + '+' + name.tr(' ', '+')
  end

  def spotify_uri
    return nil unless in_spotify?
    url = 'https://api.spotify.com/v1/search?q=' + song_search + '&type=track'
    JSON.parse(open(url).read)['tracks']['items'][1]['uri'] unless JSON.parse(open(url).read)['tracks']['items'][1]['uri'].empty?
  end

  def in_spotify?
    return false if name.empty?
    url = 'https://api.spotify.com/v1/search?q=' + song_search + '&type=track'
    return false if JSON.parse(open(url).read)['tracks']['items'].empty?
    true
  end

  def add_artist(song_params)
    artist = Artist.find(song_params[:artist_id])
    self.artist = artist
    if in_spotify?
      artist.songs.push(self)
      self.save
      return true
    else
      return false
    end
  end
end
