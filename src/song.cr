require "./section"

class Song
  property title : String = "",
    artist : String = "",
    capo : String = "",
    key : String = "",
    tempo : String = "",
    year : String = "",
    album : String = "",
    tuning : String = "",
    custom : Hash(String, String) = {} of String => String

  property sections : Array(Section) = Array(Section).new

  def chords
    sections.map do |section|
      section.lines.map do |line|
        if line.measures?
          line.measures.map { |m| m.chords }
        else
          line.parts.map { |p| p.chord }
        end
      end
    end.flatten.uniq.reject { |c| c.empty? }
  end
end
