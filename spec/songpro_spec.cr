require "./spec_helper"

describe SongPro do
  describe "parse" do
    it "parses attributes" do
      song = SongPro.parse("
@title=Bad Moon Rising
@artist=Creedence Clearwater Revival
@capo=1st Fret
@key=C# Minor
@tempo=120
@year=1975
@album=Foo Bar Baz
@tuning=Eb Standard
")

      song.title.should eq "Bad Moon Rising"
      song.artist.should eq "Creedence Clearwater Revival"
      song.capo.should eq "1st Fret"
      song.key.should eq "C# Minor"
      song.tempo.should eq "120"
      song.year.should eq "1975"
      song.album.should eq "Foo Bar Baz"
      song.tuning.should eq "Eb Standard"
    end

    it "parses custom attributes" do
      song = SongPro.parse("
!difficulty=Easy
!spotify_url=https://open.spotify.com/track/5zADxJhJEzuOstzcUtXlXv?si=SN6U1oveQ7KNfhtD2NHf9A
")

      song.custom["difficulty"].should eq "Easy"
      song.custom["spotify_url"].should eq "https://open.spotify.com/track/5zADxJhJEzuOstzcUtXlXv?si=SN6U1oveQ7KNfhtD2NHf9A"
    end

    describe "sections" do
      it "parses section names" do
        song = SongPro.parse("# Verse 1")

        song.sections.size.should eq 1
        song.sections[0].name.should eq "Verse 1"
      end

      it "parses multiple section names" do
        song = SongPro.parse("
# Verse 1
# Chorus
")
        song.sections.size.should eq 2
        song.sections[0].name.should eq "Verse 1"
        song.sections[1].name.should eq "Chorus"
      end
    end
  end
end
