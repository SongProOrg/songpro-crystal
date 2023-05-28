require "./line"

class Section
  property name : String = "",
    lines : Array(Line) = Array(Line).new

  def initialize(name : String)
    @name = name
  end
end
