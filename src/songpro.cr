require "./song"

module SongPro
  VERSION = "0.1.0"

  SECTION_REGEX           = /#\s*([^$]*)/
  ATTRIBUTE_REGEX         = /@(\w*)=([^%]*)/
  CUSTOM_ATTRIBUTE_REGEX  = /!(\w*)=([^%]*)/
  CHORDS_AND_LYRICS_REGEX = %r{(\[[\w#b+/]+\])?([^\[]*)}i

  MEASURES_REGEX = %r{([[\w#b/\]+\]\s]+)[|]*}i
  CHORDS_REGEX   = %r{\[([\w#b+/]+)\]?}i
  COMMENT_REGEX  = />\s*([^$]*)/

  def self.parse(lines : String)
    song = Song.new
    current_section = nil

    lines.split("\n").each do |text|
      if text.starts_with?("@")
        process_attribute(song, text)
      elsif text.starts_with?("!")
        process_custom_attribute(song, text)
      elsif text.starts_with?("#")
        current_section = process_section(song, text)
      else
        process_lyrics_and_chords(song, current_section, text)
      end
    end

    return song
  end

  def self.process_section(song, text)
    if matches = SECTION_REGEX.match(text)
      name = matches[1].strip
      current_section = Section.new(name: name)
      song.sections << current_section
      current_section
    end
  end

  def self.process_attribute(song, text)
    if matches = ATTRIBUTE_REGEX.match(text)
      key = matches[1]
      value = matches[2].strip

      case key
      when "title"
        song.title = value
      when "artist"
        song.artist = value
      when "capo"
        song.capo = value
      when "key"
        song.key = value
      when "tempo"
        song.tempo = value
      when "year"
        song.year = value
      when "album"
        song.album = value
      when "tuning"
        song.tuning = value
      else
        puts "Whoops!"
      end
    end
  end

  def self.process_custom_attribute(song, text)
    if matches = CUSTOM_ATTRIBUTE_REGEX.match(text)
      key = matches[1]
      value = matches[2].strip

      song.custom[key] = value
    end
  end

  def self.process_lyrics_and_chords(song, current_section, text)
    return if text == ""

    if current_section.nil?
      current_section = Section.new(name: "")
      song.sections << current_section
    end

    line = Line.new

    if text.starts_with?("|-")
      line.tablature = text
    elsif text.starts_with?("| ")
      captures = text.scan(MEASURES_REGEX)
      measures = Array(Measure).new

      captures.each do |capture|
        chords = capture[1].scan(CHORDS_REGEX).map { |c| c[1] }
        measure = Measure.new
        measure.chords = chords
        measures << measure
      end

      line.measures = measures
    elsif text.starts_with?(">")
      matches = COMMENT_REGEX.match(text)

      if matches
        line.comment = matches[1].strip
      end
    else
      captures = text.scan(CHORDS_AND_LYRICS_REGEX)
      captures.each do |pair|
        part = Part.new

        part.chord = pair[1]? ? pair[1].strip.gsub("[", "").gsub("]", "") : ""
        part.lyric = pair[2]? ? pair[2] : ""

        line.parts << part unless (part.chord == "") && (part.lyric == "")
      end
    end

    current_section.lines << line
  end
end
