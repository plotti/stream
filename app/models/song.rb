class Song
	include Mongoid::Document  
	include Mongoid::Timestamps
  	include Mongoid::Letsrate
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
	field :playing, type: Boolean, default: false

	validates :filename, uniqueness: true
	after_create :get_additional_data
	letsrate_rateable
 	
 	def self.onair
 		Song.where(:playing => true).first
 	end

 	def play(filename)
 	   Song.all.each{|s| s.playing = false; s.save}
       self.playing = true
       self.filename = filename 
       self.played_at = Time.now
       self.save!
       puts "Playing Song with filename #{self.filename}. Playing: #{self.playing}"
 	end

  	def move_to_archive(filename)
  		self.playing = false
  		if Song.where(:filename => filename).first == nil
  			self.filename = filename 
 			self.length = self.get_length
 		end
 		self.save!
		puts "Moved Song to Archive with filename #{self.filename} Playing: #{self.playing}"
	end

	def get_additional_data
		puts "Getting Additional data for #{self.filename}"
		data = self.filename.split("/").last.gsub(".mp3", "").split(" - ")
		self.artist = data.first
		self.track = data.last
		self.last_fm_data ||= $lastfm.track.get_info(artist:artist, track:track) rescue {}
		self.save
	end

	def get_length
		out = ""
		TagLib::FileRef.open(self.filename) do |fileref|
		  unless fileref.null?
		    properties = fileref.audio_properties
		    out = properties.length  #=> 335 (song length in seconds)
		  end
		end
		puts "Determining length #{out}"
		return out
	end

	def self.import_all
		Dir.glob("#{MP3_PATH}/*").sort_by{|a| File.stat(a).mtime}.each do |item|
			if !item.include? "incomplete"
				s = Song.create(:filename => item, :played_at => File.stat(item).mtime)
				s.length = s.get_length
				s.save
			end
		end
	end

end
