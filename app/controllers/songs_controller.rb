class SongsController < ApplicationController
	respond_to :html, :json

	def index
		@songs = Song.all.sort_by{|s| s.played_at}
	end

	def download
		song = Song.find(params[:id])
  		send_data IO.binread(song.filename),
    	:filename => song.filename,
    	:type => "audio/mp3", 
    	:disposition => "inline"
	end

end
