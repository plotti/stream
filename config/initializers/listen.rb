MP3_PATH = YAML.load_file("#{Rails.root}/config/config.yml")["mp3_path"]

listener = Listen.to(MP3_PATH, latency: 0.5) do |modified, added, removed|
	puts "GENERAL ADDED: #{added}"
	puts "GENERAL MODIFIED #{modified}"
	puts "GENERAL REMOVED #{removed}"
	if added != []
		added.each do |added_file|
		if added_file.include?("incomplete")
	 		s = Song.where(:filename => added_file).first
	 		if s == nil
	 			s = Song.create(:filename => added_file)
	 		end
	 		s.play(added_file)
		elsif !added_file.include?("incomplete")
			data = added_file.split("/").last.gsub(".mp3", "").split(" - ")
			s = Song.where(:artist => data.first).where(:track => data.last).first
			if s != nil
				s.move_to_archive(added_file)
			end
		end
		end
	end
end
listener.start # not blocking
