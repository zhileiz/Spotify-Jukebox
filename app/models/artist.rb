require 'json'
class Artist < ActiveRecord::Base
  has_many :songs, dependent: :destroy
  validates :name, presence: true
  accepts_nested_attributes_for :songs
  def artist_search
    name.tr(' ', '+')
  end

  def in_spotify?
    return false if name.empty?
    url = 'https://api.spotify.com/v1/search?q=' + artist_search + '&type=artist'
    return false if JSON.parse(open(url).read)['artists']['items'].empty?
    true
  end

  def add_song(artist_params)
    song = Song.new(artist_params[:song_attributes])
    song.artist = self
    if song.in_spotify?
      songs.push(song)
      song.save
      return true
    else
      return false
    end
  end
end
