MP3_PATH = YAML.load_file("#{Rails.root}/config/config.yml")["mp3_path"]

listener = Listen.to(MP3_PATH, latency: 0.5) do |modified, added, removed|
	if added != [] && added.first.include?("incomplete")
	 	s = Song.where(:filename => added.first).first
	 	if s == nil
	 		s = Song.create(:filename => added.first)
	 	end
	 	s.play(added.first)
	elsif added != [] && !added.first.include?("incomplete")
		data = added.first.split("/").last.gsub(".mp3", "").split(" - ")
		s = Song.where(:artist => data.first).where(:track => data.last).first
		if s != nil
			s.move_to_archive(added.first)
		end
	end
end
listener.start # not blocking
