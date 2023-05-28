describe Song do
  describe "chords" do
    it "returns all chords through the song" do
      song = SongPro.parse("
# Chords

Some [D] chord [A]
| [B] [C] |
")

      song.chords.should eq(%w[D A B C])
    end
  end
end
