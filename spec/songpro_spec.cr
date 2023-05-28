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

    context "sections" do
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

    context "lyrics" do
      it "parses lyrics" do
        song = SongPro.parse("I don't see! a bad, moon a-rising. (a-rising)")

        song.sections.size.should eq 1
        song.sections[0].lines.size.should eq 1
        song.sections[0].lines[0].parts.size.should eq 1
        song.sections[0].lines[0].parts[0].lyric.should eq "I don't see! a bad, moon a-rising. (a-rising)"
      end

      it "handles parens in lyics" do
        song = SongPro.parse("singing something (something else)")

        song.sections.size.should eq 1
        song.sections[0].lines.size.should eq 1
        song.sections[0].lines[0].parts.size.should eq 1
        song.sections[0].lines[0].parts[0].lyric.should eq "singing something (something else)"
      end

      it "handles special characters" do
        song = SongPro.parse("singing sömething with Röck dots")

        song.sections.size.should eq 1
        song.sections[0].lines.size.should eq 1
        song.sections[0].lines[0].parts.size.should eq 1
        song.sections[0].lines[0].parts[0].lyric.should eq "singing sömething with Röck dots"
      end
    end

    context "chords" do
      it "parses chords" do
        song = SongPro.parse("[D] [D/F#] [C] [A7]")
        song.sections.size.should eq 1
        song.sections[0].lines.size.should eq 1
        song.sections[0].lines[0].parts.size.should eq 4
        song.sections[0].lines[0].parts[0].chord.should eq "D"
        song.sections[0].lines[0].parts[0].lyric.should eq " "
        song.sections[0].lines[0].parts[1].chord.should eq "D/F#"
        song.sections[0].lines[0].parts[1].lyric.should eq " "
        song.sections[0].lines[0].parts[2].chord.should eq "C"
        song.sections[0].lines[0].parts[2].lyric.should eq " "
        song.sections[0].lines[0].parts[3].chord.should eq "A7"
        song.sections[0].lines[0].parts[3].lyric.should eq ""
      end
    end

    context "chords and lyrics" do
      it "parses chords and lyrics" do
        song = SongPro.parse("[G]Don't go 'round tonight")
        song.sections.size.should eq 1
        song.sections[0].lines.size.should eq 1
        song.sections[0].lines[0].parts.size.should eq 1
        song.sections[0].lines[0].parts[0].chord.should eq "G"
        song.sections[0].lines[0].parts[0].lyric.should eq "Don't go 'round tonight"
      end

      it "parses lyrics before chords" do
        song = SongPro.parse("It's [D]bound to take your life")
        song.sections.size.should eq 1
        song.sections[0].lines.size.should eq 1
        song.sections[0].lines[0].parts.size.should eq 2
        song.sections[0].lines[0].parts[0].chord.should eq ""
        song.sections[0].lines[0].parts[0].lyric.should eq "It's "
        song.sections[0].lines[0].parts[1].chord.should eq "D"
        song.sections[0].lines[0].parts[1].lyric.should eq "bound to take your life"
      end

      it "parses lyrics before chords" do
        song = SongPro.parse("It's a[D]bout a [E]boy")
        song.sections.size.should eq 1
        song.sections[0].lines.size.should eq 1
        song.sections[0].lines[0].parts.size.should eq 3
        song.sections[0].lines[0].parts[0].chord.should eq ""
        song.sections[0].lines[0].parts[0].lyric.should eq "It's a"
        song.sections[0].lines[0].parts[1].chord.should eq "D"
        song.sections[0].lines[0].parts[1].lyric.should eq "bout a "
        song.sections[0].lines[0].parts[2].chord.should eq "E"
        song.sections[0].lines[0].parts[2].lyric.should eq "boy"
      end
    end

    context "measures" do
      it "parses chord-only measures" do
        song = SongPro.parse("
# Instrumental

| [A] [B] | [C] | [D] [E] [F] [G] |
")

        song.sections.size.should eq 1
        song.sections[0].lines[0].measures?.should eq true
        song.sections[0].lines[0].measures.size.should eq 3
        song.sections[0].lines[0].measures[0].chords.should eq %w[A B]
        song.sections[0].lines[0].measures[1].chords.should eq %w[C]
        song.sections[0].lines[0].measures[2].chords.should eq %w[D E F G]
      end
    end

    context "tablature" do
      it "parses tablature" do
        song = SongPro.parse("
# Riff

|-3---5-|
|---4---|
")
        song.sections.size.should eq 1
        song.sections[0].lines[0].tablature?.should eq true
        song.sections[0].lines[0].tablature.should eq "|-3---5-|"
        song.sections[0].lines[1].tablature?.should eq true
        song.sections[0].lines[1].tablature.should eq "|---4---|"
      end
    end
  end
end
