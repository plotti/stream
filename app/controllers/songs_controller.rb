class SongsController < ApplicationController
	respond_to :html, :json
	before_filter :authenticate_user!

	def current
		@songs = Song.all.where(:playing => false).sort_by{|s| s.played_at}.reverse[0..20]
		@current_song = Song.where(:playing => true).first
	end

	def index
		@current_song = Song.where(:playing => true).first
		@songs = Song.all.where(:playing => false).sort_by{|s| s.played_at}.reverse[0..20]
	end

	def favorite
		@songs = []
		Rate.where(:rater_id => current_user.id).each do |rating|
			@songs << Song.where(:id => rating.rateable_id).first
		end
		@songs.compact.sort_by{|s| s.played_at}.reverse
	end

	def download
		song = Song.find(params[:id])
  		send_data IO.binread(song.filename),
    	:filename => song.filename,
    	:type => "audio/mp3", 
    	:disposition => "inline"
	end

end
