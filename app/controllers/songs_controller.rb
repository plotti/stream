class SongsController < ApplicationController
	respond_to :html, :json
	before_filter :authenticate_user!

	def current
		@songs = Song.all.where(:playing => false).sort_by{|s| s.played_at}
		@current_song = Song.where(:playing => true).first
	end

	def index
		@current_song = current
		@songs = Song.all.where(:playing => false).sort_by{|s| s.played_at}
	end

	def download
		song = Song.find(params[:id])
  		send_data IO.binread(song.filename),
    	:filename => song.filename,
    	:type => "audio/mp3", 
    	:disposition => "inline"
	end

end
