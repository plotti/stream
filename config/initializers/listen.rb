MP3_PATH="/Users/plotti/SwissGroove"

listener = Listen.to(MP3_PATH, latency: 0.5) do |modified, added, removed|
	if added != [] && added.first.include?("incomplete")
	 	s = Song.where(:filename => added.first).first
	 	if s == nil
	 		s = Song.create(:filename => added.first)
	 	end
	 	s.play(added.first)
	elsif added != [] && !added.first.include?("incomplete")
		s = Song.where(:playing => true).first
		if s != nil
			s.move_to_archive(added.first)
		end
	end
end
listener.start # not blocking
