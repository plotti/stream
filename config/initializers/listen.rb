MP3_PATH="/Users/plotti/SwissGroove"

listener = Listen.to(MP3_PATH) do |modified, added, removed|
	if added != [] && !added.first.include?("incomplete")
		s = Song.create(:filename => added.first, :played_at => File.stat(added.first).mtime)
	end
end
listener.start # not blocking