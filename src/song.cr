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
end
