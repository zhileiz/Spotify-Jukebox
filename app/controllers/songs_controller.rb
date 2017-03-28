class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # GET /songs
  def index
    @songs = Song.all
  end

  def all
    @songs = Song.all
  end

  # GET /songs/new
  def new
    @song = Song.new
    @song.artist = Artist.find(params[:artist_id])
  end

  # POST /songs
  def create
    @song = Song.new(name: song_params[:song][:name])

    if @song.add_artist(song_params)
      redirect_to artist_songs_path(@song.artist_id), notice: 'Song was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /songs/1
  def update
    if @song.update(song_params)
      redirect_to @song, notice: 'Song was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /songs/1
  def destroy
    @song.destroy
    redirect_to songs_url, notice: 'Song was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = Song.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def song_params
    params
  end
end
