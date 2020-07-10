require "./song"

module SongPro
  VERSION = "0.1.0"

  ATTRIBUTE_REGEX = /@(\w*)=([^%]*)/
  CUSTOM_ATTRIBUTE_REGEX = /!(\w*)=([^%]*)/

  def self.parse(lines : String)
    song = Song.new

    lines.split("\n").each do |text|
      if text.starts_with?("@")
        process_attribute(song, text)
      elsif text.starts_with?("!")
        process_custom_attribute(song, text)
      end
    end

    return song
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
end
