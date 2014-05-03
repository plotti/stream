class Song
	include Mongoid::Document  
	field :title, type: String
	field :studio, type: String, default: ""
	field :country, type: String, default: ""
	field :budget, type: String, default: "NA"
	field :year, type: Integer
	field :filename, type: String
	field :artist, type: String
	field :track, type:String
	field :last_fm_data, type:Hash
	field :length, type: Integer
	field :played_at, type: DateTime
	validates :filename, uniqueness: true
	after_create :get_additional_data
  	rateable range: (-5..7), raters: [User, Admin]

	def get_additional_data
		data = self.filename.split("/").last.gsub(".mp3", "").split(" - ")
		self.artist = data.first
		self.track = data.last
		self.last_fm_data ||= $lastfm.track.get_info(artist:artist, track:track) rescue {}
		self.length = self.get_length
		self.save
	end

	def get_length
		TagLib::FileRef.open(self.filename) do |fileref|
		  unless fileref.null?
		    properties = fileref.audio_properties
		    properties.length  #=> 335 (song length in seconds)
		  end
		end
	end

	def self.read_in_songs
		Dir.glob("#{MP3_PATH}/*").sort_by{|a| File.stat(a).mtime}.each do |item|
			if !item.include? "incomplete"
				s = Song.create(:filename => item, :played_at => File.stat(item).mtime)
				puts item
			end
		end
	end

end
